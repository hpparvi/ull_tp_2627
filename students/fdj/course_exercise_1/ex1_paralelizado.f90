! Direct N-body simulation with the leapfrog (kick-drift-kick) integrator.
!
! Reads the simulation setup from the file given as command-line argument:
!
!   dt                  time step
!   dt_out              time between outputs
!   t_end               end time of the simulation
!   n                   number of particles
!   m x y z vx vy vz    mass, position, and velocity (one line per particle)
!
! and writes t and the positions of all the particles to output.dat every
! dt_out. The units are chosen so that the gravitational constant G = 1.
!
!   make
!   ./leapfrog input.dat        (serial)
!   ./leapfrog_omp input.dat    (OpenMP, OMP_NUM_THREADS=4 ./leapfrog_omp ...)
module physics
use particle
implicit none

contains

! Every iteration of the outer loop writes only a(i), so the threads never
! write the same element and there is no race condition. The sum for each
! a(i) always runs over j = 1..n in the same order, so the result does not
! depend on the number of threads.
function acceleration (n_part, part) result(a)
integer(int64), intent(in) :: n_part
type(particle3d), dimension(n_part), intent(in) :: part
type(vector3d), dimension(n_part) :: a
type(vector3d) :: rji
real(dp) :: r3
integer(int64) :: i, j

!$omp parallel do default(none) &
!$omp shared(part, a, n_part) private(j, rji, r3)
do i = 1, n_part
   a(i) = vector3d(0.0_dp, 0.0_dp, 0.0_dp)
   do j = 1, n_part
      if (j == i) cycle
      rji  = part(j)%p - part(i)%p
      r3   = dist(part(j)%p, part(i)%p)**3
      a(i) = a(i) + (part(j)%m * (rji / r3))
   end do
end do
!$omp end parallel do
end function acceleration

end module physics


program leapfrog
use iso_fortran_env, only: error_unit
!$ use omp_lib
use physics
implicit none

integer(int64) :: i, n, step, n_steps, out_every
integer :: u_in, u_out, ios
real(dp) :: t, dt, t_end, dt_out, t0, t1
character(len=256) :: fname
character(len=200) :: msg

character(len=*), parameter :: fmt_row = '(*(g0,1x))'
type(particle3d), dimension(:), allocatable :: part
type(vector3d),   dimension(:), allocatable :: a

if (command_argument_count() < 1) then
   write(error_unit, '(a)') 'Usage: ./leapfrog <input_file.dat>'
   stop 1
end if
call get_command_argument(1, fname)

open(newunit=u_in, file=trim(fname), status='old', action='read', &
     iostat=ios, iomsg=msg)
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
   read(u_in, *) part(i)%m, &
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

n_steps   = nint(t_end / dt)
out_every = max(1, nint(dt_out / dt))

t0 = 0.0_dp
t1 = 0.0_dp
!$ t0 = omp_get_wtime()

write(u_out, fmt_row) 0.0_dp, &
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