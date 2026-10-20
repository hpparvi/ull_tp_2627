module geometry
  implicit none

  type :: vector3d
    real :: x, y, z
  end type vector3d

end module geometry

program test_geometry
  use geometry
  implicit none
  type(vector3d) :: a
  a = vector3d(0.0, 1.0, 0.0)
  print *, a
end program test_geometry
