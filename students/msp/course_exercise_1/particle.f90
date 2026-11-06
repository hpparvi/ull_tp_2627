module particle

   use iso_fortran_env, only: real64
   use geometry
   
   implicit none
   
   type :: particle3d
   
      type(point3d) :: p  ! Position
      type(vector3d) :: v ! velocity
      real(real64) :: m   ! mass
      
   end type particle3d
   
end module particle
   ! Primero se debe compilar geometry, segundo particle
