! Here are the vector3d and point 3d that will be used in the main
! Programs and other modules:

module geometry

   use iso_fortran_env, only: real64

   implicit none
   
   type :: vector3d
      real(real64) :: x , y , z
   end type vector3d
   
   type :: point3d
      real(real64) :: x , y , z
   end type point3d
   
   interface operator(+)
      module procedure sumvv, sumvp , sumpv
   end interface

   interface operator(-)
      module procedure subpp, subvp, subpv
   end interface

   interface operator(*)
      module procedure mulrv, mulvr 
   end interface

   interface operator(/)
      module procedure divvr
   end interface
      
   contains
   
   ! 3d vector + vector = 3d vector (element by element)
      pure type(vector3d) function sumvv(a,b)
         type(vector3d), intent(in) :: a , b
         sumvv = vector3d(a%x + b%x, a%y + b%y, a%z + b%z)
      end function sumvv
   
   ! 3d vector + point = point (element by element)
      pure type(point3d) function sumvp(a,b)
         type(vector3d), intent(in) :: a
         type(point3d) , intent(in) :: b
         sumvp = point3d(a%x + b%x, a%y + b%y, a%z + b%z)
      end function sumvp
   
   ! 3d point + vector = point (element by element)
      pure type(point3d) function sumpv(a,b)
         type(point3d) , intent(in) :: a
         type(vector3d), intent(in) :: b
         sumpv = point3d(a%x + b%x, a%y + b%y, a%z + b%z)
      end function sumpv
   
   ! point - point = vector (element by element)
      pure type(vector3d) function subpp(a,b)
         type(point3d) , intent(in) :: a , b
         subpp = vector3d(a%x - b%x, a%y - b%y, a%z - b%z)
      end function subpp
   
   ! vector - point = point (element by element)
      pure type(point3d) function subvp(a,b)
         type(vector3d), intent(in) :: a
         type(point3d) , intent(in) :: b
         subvp = point3d(a%x - b%x, a%y - b%y, a%z - b%z)
      end function subvp
      
   ! point - vector = point (element by element)
      pure type(point3d) function subpv(a,b)
         type(point3d) , intent(in) :: a
         type(vector3d), intent(in) :: b
         subpv = point3d(a%x - b%x, a%y - b%y, a%z - b%z)
      end function subpv

   ! real * vector = vector
      pure type(vector3d) function mulrv(a,b)
         real(real64), intent(in) :: a
         type(vector3d) , intent(in) :: b
         mulrv = vector3d(a * b%x, a * b%y, a * b%z)
      end function mulrv  
       
   ! vector * real = vector
      pure type(vector3d) function mulvr(a,b)
         type(vector3d) , intent(in) :: a
         real(real64), intent(in) :: b
         mulvr = vector3d(a%x * b, a%y * b, a%z * b)
      end function mulvr   
   
   ! vector / real = vector
      pure type(vector3d) function divvr(a,b)
         type(vector3d) , intent(in) :: a
         real(real64), intent(in) :: b
         divvr = vector3d(a%x / b, a%y / b, a%z / b)
         end function divvr
                     
end module geometry

