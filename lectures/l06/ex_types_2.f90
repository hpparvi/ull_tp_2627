module geometry
  implicit none

  type :: vector3d
    real :: x, y, z
  end type vector3d

  type :: sphere
    type(vector3d) :: centre
    real :: radius
  end type sphere
end module geometry

program test_geometry
  use geometry
  implicit none
  type(sphere) :: s
  s = sphere(vector3d(0.0, 1.0, 0.0), 5.0)
  print *, s
end program test_geometry
