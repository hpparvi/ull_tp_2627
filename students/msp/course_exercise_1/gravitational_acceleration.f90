module gravitational_acceleration
   ! Gravitational functions: G=1

   !!!!!!!!!!!
   ! LIBRARIES
   !!!!!!!!!!!

   use iso_fortran_env, only: real64
   use geometry 
   use particle
   
   implicit none

   contains
   
      !!!!!!!!!!!!!!!
      ! FUNCTIONS
      !!!!!!!!!!!!!!!
      
      pure type(vector3d) function acceleration(particles, ident)
      
      ! This function gets as input a particles array and an identificator
      ! integer. Returns the gravitational acceleration (vector3d) for
      ! particles(ident) due to the others particles.
         type(particle3d), intent(in) :: particles(:)
         integer, intent(in) :: ident
         integer :: i
         real(real64) :: factor
         
         ! Initialize acceleration as (0,0,0)
         acceleration = vector3d(0.0_real64,0.0_real64,0.0_real64)
         
         do i = 1, size(particles) ! loop for each particle
         
            if (i == ident) cycle ! do not calculate acceleration due to itself
            
            factor = particles(i)%m / distance(particles(ident)%p,particles(i)%p) ** 3
            
            acceleration%x = acceleration%x + factor * (particles(i)%p%x - particles(ident)%p%x)
            acceleration%y = acceleration%y + factor * (particles(i)%p%y - particles(ident)%p%y)
            acceleration%z = acceleration%z + factor * (particles(i)%p%z - particles(ident)%p%z)
         
         end do
      
      end function acceleration
      
end module gravitational_acceleration
