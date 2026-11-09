module read_input

   use iso_fortran_env, only: real64, iostat_end
   use geometry
   use particle
   
   implicit none
   
   contains
   
      function input(Name_txt, N, time_step, snap_step, total_time) result(particles)

      character(len=*), intent(in) :: Name_txt
      type(particle3d), allocatable :: particles(:)
      integer :: i, ios
      real(real64), intent(out) :: time_step, snap_step, total_time
      integer, intent(out) :: N

      ! Read the set up: for the moment particles position, velocity an mass
      open(unit=1, file=Name_txt, status="old", action="read")

      ! read(1, *) ! Skip Header

      ! Read number of particles
      N = - 4 ! Exclude 4 first lines.

      do
         read(1, *, iostat=ios)
         if (ios == iostat_end) exit
         N = N + 1
      end do

      ! Allocate acceleration and particles:
      allocate(particles(N))

      rewind(1) ! Return to beginning of file

      ! Loop to read particles from the file
      do i = 1, N + 4

         if (i == 4) cycle

         if (i == 1) then

            read(1, *) time_step

         else if (i == 2) then

            read(1, *) snap_step

         else if (i == 3) then

            read(1, *) total_time

         else if (i > 4) then 

            read(1, *) particles(i-4)%m, &
                       particles(i-4)%p%x, &
                       particles(i-4)%p%y, &
                       particles(i-4)%p%z, &
                       particles(i-4)%v%x, &
                       particles(i-4)%v%y, &
                       particles(i-4)%v%z
		   
         end if

      end do

      close(1) ! close the file

   end function input

end module read_input






