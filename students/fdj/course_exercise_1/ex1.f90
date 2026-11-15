! Direct N-body simulation with the leapfrog (kick-drift-kick) integrator.
!
! Reads the simulation setup from the file given as the first command-line
! argument:
!
!   dt                  time step
!   dt_out              time between outputs
!   t_end               end time of the simulation
!   n                   number of particles
!   m x y z vx vy vz    mass, position, and velocity (one line per particle)
!
! and writes the positions of all the particles to output.dat every dt_out.
! Each line has the form
!
!   t  p1a p1b p1c  p2a p2b p2c  ...  pna pnb pnc
!
! and the first line is the initial state (t = 0). The units are chosen so
! that the gravitational constant G = 1.
!
! The accelerations are computed with a loop over all the pairs (i, j), j /= i,
! in which iteration i writes only to a(i). This avoids the race condition of
! the loop over pairs j > i, where two threads could update the same a(j), at
! the cost of twice as many interactions. The loop is parallelised with
! OpenMP; without -fopenmp the directives are comments and the code is serial.
!
! Build and run (see the Makefile and README.md):
!
!   make
!   ./exercise_1 input.dat                         (serial)
!   OMP_NUM_THREADS=4 ./exercise_1_omp input.dat   (OpenMP, 4 threads)
!
! The OpenMP version also prints the wall time of the simulation loop to
! standard error. Set dt_out = t_end when timing, so that writing the output
! does not dominate.

module physics
  use particle
  implicit none

  contains
    function acceleration (n_part, part) result(a)
      integer(int64), intent(in) :: n_part
      type(particle3d), dimension(n_part), intent(in):: part
      
      type(vector3d) :: rji
      real(dp) :: r2, r3
      integer(int64) :: i, j

      type(vector3d), dimension(n_part) :: a


      ! Two possible loops. Benchmarks show that the first one is the fastest,
      ! but I coudn't conclude why.

      ! Keep one of them commented while the other one is active for a correct usage.

      !$omp parallel do default(none) &
      !$omp shared(part, a, n_part) private(j, rji, r3)
      do i = 1, n_part
        a(i) = vector3d(0.0,0.0,0.0)
        do j = 1, n_part
            if (j == i) cycle ! skips self-interaction
            rji = part(j)%p - part(i)%p
            r3 = dist(part(j)%p,part(i)%p)**3
            a(i) = a(i) + (part(j)%m * (rji / r3))
        end do
      end do
      !$omp end parallel do

      ! !$omp parallel do default(none) &
      ! !$omp shared(part, a, n_part) private(j, rji, r2, r3)
      ! do i = 1, n_part
      !   a(i) = vector3d(0.0, 0.0, 0.0)
      !   do j = 1, n_part
      !     if (j == i) cycle
      !     rji  = part(j)%p - part(i)%p
      !     r2   = rji%x**2 + rji%y**2 + rji%z**2
      !     r3   = r2 * sqrt(r2)
      !     a(i) = a(i) + (part(j)%m / r3) * rji
      !   end do
      ! end do
      ! !$omp end parallel do


    end function acceleration
end module physics


program leapfrog
  use physics
  use iso_fortran_env, only: error_unit
  !$ use omp_lib

  implicit none

  integer(int64) :: i, n, step, n_steps, out_every
  integer :: u_in, u_out, ios  ! needed for new_unit, iostat
  real(dp) :: t, dt, t_end, dt_out, t0, t1
  
  character(len=256) :: fname
  character(len=200) :: msg

  ! fmt_row format: 
  !  - g0: better precission for calculating the difference between serial
  !   and parallel outputs
  !  - es15.7e2: affordable precission for the calculations
  character(len=*), parameter :: fmt_row = '(*(es15.7e2,1x))'
  type(particle3d), dimension(:), allocatable :: part
  type(vector3d),   dimension(:), allocatable :: a


  if (command_argument_count() < 1) then
    write(error_unit, '(a)') 'Usage: ./leapfrog <input_file.dat>'
    stop 1
  end if
  call get_command_argument(1, fname)

  open(newunit=u_in, file=trim(fname), status='old', action='read', iostat=ios, iomsg=msg)
  if (ios /= 0) then
    write(error_unit, '(a)') 'Cannot open ' // trim(fname) // ': ' // trim(msg)
    stop 1
  end if

  read(u_in, *) dt
  read(u_in, *) dt_out
  read(u_in, *) t_end
  read(u_in, *) n

  allocate(part(n))
  allocate(a(n))

  do i = 1, n
     read (u_in, *) part(i)%m, &
     part(i)%p%a, part(i)%p%b, part(i)%p%c, &
     part(i)%v%x, part(i)%v%y, part(i)%v%z
  end do
  close(u_in)

  open(newunit=u_out, file='output.dat', status='replace', action='write', &
       iostat=ios, iomsg=msg)

  if (ios /= 0) then
    write(error_unit, '(a)') 'Cannot open output.dat: ' // trim(msg)
    stop 1
  end if

  n_steps = nint(t_end / dt)
  out_every = max(1, nint(dt_out / dt))

  t0 = 0.0
  t1 = 0.0
  !$ t0 = omp_get_wtime()

  write(u_out, fmt_row) 0.0, &
       (part(i)%p%a, part(i)%p%b, part(i)%p%c, i = 1, n)

  a = acceleration(n, part)
  do step = 1, n_steps
    part%v = part%v + (a * (dt/2))
    part%p = part%p + (part%v * dt)
    a = acceleration(n, part)
    part%v = part%v + (a * (dt/2))

    if (mod(step, out_every) == 0) then
      t = step * dt
      write(u_out, fmt_row) t, &
          (part(i)%p%a, part(i)%p%b, part(i)%p%c, i = 1, n)
    end if
  end do
  
  !$ t1 = omp_get_wtime()
  !$ write(error_unit, '(a, f0.3, a)') 'Time: ', t1 - t0, ' s'
  
  close(u_out)
end program leapfrog
