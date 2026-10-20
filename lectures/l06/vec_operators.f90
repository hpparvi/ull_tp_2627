module geometry
  implicit none
  type :: vector2d
     real :: x, y
  end type vector2d
  interface operator(+)
     module procedure sumvv
  end interface
  interface operator(*)
     module procedure mulrv
  end interface
contains
  pure type(vector2d) function sumvv(a, b)
    type(vector2d), intent(in) :: a, b
    sumvv = vector2d(a%x + b%x, a%y + b%y)
  end function sumvv
  pure type(vector2d) function mulrv(a, b)
    real, intent(in) :: a
    type(vector2d), intent(in) :: b
    mulrv = vector2d(a*b%x, a*b%y)
  end function mulrv
end module geometry

program test
  use geometry
  implicit none
  type(vector2d) :: a, b, c
  real :: s = 2.3
  a = vector2d(0.0, 1.0)
  b = vector2d(1.0, 1.0)
  c = s*a + b
  print *, c
end program test
