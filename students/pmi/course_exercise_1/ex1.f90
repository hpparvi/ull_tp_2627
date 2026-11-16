! Direct N-body simulation with the leapfrog (kick-drift-kick) integrator.
!
! Reads the simulation setup from standard input:
!
!   dt                  time step
!   dt_out              time between outputs
!   t_end               end time of the simulation
!   n                   number of particles
!   m x y z vx vy vz    mass, position, and velocity (one line per particle)
!
! and prints the positions of all the particles every dt_out. The units
! are chosen so that the gravitational constant G = 1.
!
!   gfortran -o leapfrog leapfrog.f90
!   ./leapfrog < input.dat
program Exercise_1
  use Geometry
  use Particle
  use omp_lib
  
  
!  We modify some things from the original leapfrog.f90, such as using double
!  precission or using r, v and m as dummy variables, just to read the ICs.

  implicit none
  integer :: i, j, n, step, n_steps, out_every, t_0, t_f, rate
  real(dp) :: dt, t_end, dt_out, t, run_time
  real(dp) :: r2, r3

  real(dp) :: m
  real(dp), dimension(3) :: r, v
  
!  We will use our defined types from Particle.f90 and Geometry.f90  
  type(vector3d) :: rji
  type(vector3d), dimension(:), allocatable :: a
  type(particle3d), dimension(:), allocatable :: particles
  


  read *, dt
  read *, dt_out
  read *, t_end
  read *, n
  
  allocate(a(n))
  allocate(particles(n))

!  Reading the ICs and saving them in particles, an array of particle3d's
  do i = 1, n
     read *, m, r(:), v(:)
     particles(i) = particle3d(point3d(r(1), r(2), r(3)), vector3d(v(1), v(2), v(3)), m)
  end do

  n_steps = nint(t_end / dt)
  out_every = max(1, nint(dt_out / dt))
  
!  We prepare the output file
  open(111, file = 'output.dat')
!  And write the ICs on it
  write(111, *) 0.0, particles(:)%p

!  Initialize the accelerations as zero
  a(:) = vector3d(0.0, 0.0, 0.0)
  
  !$omp parallel private(rji, r2, r3)
  !$omp do reduction(+:a)
  do i = 1, n
     do j = i+1, n
        rji = particles(j)%p - particles(i)%p
        r2 = rji .dot. rji
        r3 = r2 * sqrt(r2)
        a(i) = a(i) + rji * (particles(j)%m / r3)
        a(j) = a(j) - rji * (particles(i)%m / r3)
     end do
  end do
  !$omp end do
  !$omp end parallel
    
!  Start measuring time for the heavier part of the code
  call system_clock(count_rate=rate)
  call system_clock(count=t_0)

  do step = 1, n_steps
    particles(:)%v = particles(:)%v + a(:) * (dt/2)
    particles%p = particles%p + particles%v * dt
    a(:) = vector3d(0.0, 0.0, 0.0)
    !$omp parallel private(rji, r2, r3)
    !$omp do reduction(+:a)
    do i = 1, n
      do j = i+1, n
        rji = particles(j)%p - particles(i)%p
        r2 = rji .dot. rji
        r3 = r2 * sqrt(r2)
        a(i) = a(i) + rji * particles(j)%m / r3
        a(j) = a(j) - rji * particles(i)%m / r3
      end do
    end do
    !$omp end do
    !$omp end parallel

    particles(:)%v = particles(:)%v + a(:) * (dt/2.0)

!  Save current time and positions when we reach n * dt_out
    if (mod(step, out_every) == 0) then
      t = step * dt
      write(111, *) t, particles(:)%p
    end if
  end do
  
  close(111)
  
!  Stop the timer
  call system_clock(count = t_f)
  run_time = real(t_f - t_0) / real(rate)
  print*, ''
  print*, ''
  print '(A, ES8.2, A)', 'This program took ', run_time, ' seconds to run'
  print*, ''
  print*, ''

end program
