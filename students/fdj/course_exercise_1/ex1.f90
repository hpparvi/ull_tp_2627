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
module physics
  use particle
  implicit none

  contains
    pure function acceleration (n_part, part) result(a)
      integer(int64), intent(in) :: n_part
      type(particle3d), dimension(n_part), intent(in):: part
      
      type(vector3d) :: rji
      real(dp) :: r3
      integer(int64) :: i, j

      type(vector3d), dimension(n_part) :: a

      a = vector3d(0.0,0.0,0.0)

      do i = 1, n_part
        do j = i+1, n_part
            rji = part(j)%p - part(i)%p
            r3 = dist(part(j)%p,part(i)%p)**3
            a(i) = a(i) + (part(j)%m * (rji / r3))
            a(j) = a(j) - (part(i)%m * (rji / r3))
        end do
      end do
     
    end function  
end module 

program leapfrog
  use physics

  implicit none

  integer(int64) :: i, n, step, n_steps, out_every, u_in, u_out, ios
  real(dp) :: t, dt, t_end, dt_out
  character(len=256) :: fname

  character(len=*), parameter :: fmt_row = '(*(es15.7e2,1x))'
  
  
  type(particle3d), dimension(:), allocatable :: part
  type(vector3d),   dimension(:), allocatable :: a


  if (command_argument_count() < 1) then
    print *, 'Usage: ./exercise_1 <input_file.dat>'
    stop 1
  end if
  call get_command_argument(1, fname)

  open(newunit=u_in, file=trim(fname), status='old', action='read', iostat=ios)
  if (ios /= 0) then
    print *, 'Cannot open file: ', trim(fname)
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

  open(newunit=u_out, file='output.dat', status='replace', action='write')

  n_steps = nint(t_end / dt)
  out_every = max(1, nint(dt_out / dt))


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
    
    close(u_out)
end program leapfrog
