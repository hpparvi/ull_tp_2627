! this program create a IC in a sphere with radius 1, initial position 
! inside the sphere, initial velocities in three coordinates in betewn
! 0 to 1 and each particle with mass equal to 1 .

! it's create 7 random numbers for a single particle. r
! define the radius, the first 3, are the three define the three coordinates
! from the vector position, the last 3 are the velocities.

! to calculate de position of a single particle the next calculation is donne:
! r * position/|position|. ussing this we assure the particle position 
! is on a sphere with radius 1 and furthermore, it's homogenious.

program sphere

   !!!!!!!!!!!!!!!!!
   ! LIBRARIES
   !!!!!!!!!!!!!!!!!
   
   use iso_fortran_env, only: real64
   
   implicit none
   
   !!!!!!!!!!!!!!!!!
   ! VARIABLES
   !!!!!!!!!!!!!!!!!

   integer :: i, s, n, ident, unit
   integer, allocatable :: seed(:)
   real(real64) :: time_step, snap_step, total_time
   real(real64), allocatable :: x(:,:), r(:) 

   n = 1000
   time_step = 0.001_real64
   snap_step = 0.1_real64
   total_time= 100.0_real64
   
   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! MAIN: GENERATING THE SPHERE
   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   
   
   call random_seed(size=s)
   allocate(seed(s))

   seed = 10
   call random_seed(put=seed)

   allocate(x(n,7))
   allocate(r(n))

   x(:,1) = 1.0_real64 ! de momento la masa es toda la misma y vale 1

   call random_number(x(:,2:7))
   
   ! Next line become rand (0,1) in rand(-1,1)
   x(:,2:7) = 2*x(:,2:7) - 1.0_real64 

   ! changing seed for the radious.
   seed = 11
   call random_seed(put=seed)

   call random_number(r(:))

   do i = 1, n
      x(i,2:4) = r(i) * x(i,2:4) / &
      sqrt(x(i,2)**2 + x(i,3)**2 + x(i,4)**2)
   end do

   !!!!!!!!!!!!!!!!!
   ! SAVING THE DATA
   !!!!!!!!!!!!!!!!!

   open(newunit=unit, file="input.dat", status="replace", action="write")
   
   ! I will do the same format as in the example
   write (unit , *) time_step
   write (unit , *) snap_step
   write (unit , *) total_time
   write (unit , *) n
   ! write (unit , *) "ID	", "X	", "Y	", "Z	", "VX	", "VY	", "VZ	", "M	"
   
   ! Loop over particles
   do ident = 1, n
   
      write (unit , *) x(ident,:) ! guardo resultados
   
   end do

   close(unit)

end program sphere
