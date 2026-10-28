! Exercise 1 star cataloge
module Star
  implicit none
  type :: vector3d
    real :: x, y, z
  end type vector3d
  type :: starkind
    character :: names
    real :: mass
    type(vector3d) :: positions
  end type starkind
end module Star

program l06_ex1
  use Star
  implicit none
  type(starkind) :: star1, star2, star3
  star1 = starkind("star1",1.0,vector3d(0.0,0.0,0.0))
  star2 = starkind("star2",2.0,vector3d(-1.0,0.0,0.0))
  star3 = starkind("star3",3.0,vector3d(1.0,0.0,0.0))
  print * , star1(1)
end program l06_ex1
  
