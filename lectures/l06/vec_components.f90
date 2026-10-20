module geometry
  implicit none
  type :: vector2d
     real :: x, y
  end type vector2d
end module geometry

program test
  use geometry
  implicit none
  type(vector2d) :: a, b, c
  real :: s = 2.3
  a = vector2d(0.0, 1.0)
  b = vector2d(1.0, 1.0)
  c = vector2d(s*a%x+b%x, s*a%y+b%y)
  print *, c
end program test
