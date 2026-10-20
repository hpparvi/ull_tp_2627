module geometry
  implicit none

  type :: vector2d
     real :: x, y
  end type vector2d

  interface operator(+)
     module procedure sumvv
  end interface

  interface operator(-)
     module procedure subvv
  end interface
  
  interface operator(*)
     module procedure mulrv, muliv
  end interface

  interface operator(/)
     module procedure divvr
  end interface

  interface operator(.dot.)
     module procedure dotvv
  end interface
  
contains
  pure type(vector2d) function sumvv(a, b)
    type(vector2d), intent(in) :: a, b
    sumvv = vector2d(a%x + b%x, a%y + b%y)
  end function sumvv

  pure type(vector2d) function subvv(a, b)
    type(vector2d), intent(in) :: a, b
    subvv = vector2d(a%x - b%x, a%y - b%y)
  end function subvv
  
  pure type(vector2d) function mulrv(a, b)
    real, intent(in) :: a
    type(vector2d), intent(in) :: b
    mulrv = vector2d(a*b%x, a*b%y)
  end function mulrv

  pure type(vector2d) function muliv(i, v)
    integer, intent(in) :: i
    type(vector2d), intent(in) :: v
    muliv = mulrv(real(i), v)
  end function muliv

  pure type(vector2d) function divvr(v, r)
    real, intent(in) :: r
    type(vector2d), intent(in) :: v
    divvr = vector2d(v%x/r, v%y/r)
  end function divvr

  pure real function dotvv(a, b)
    type(vector2d), intent(in) :: a, b
    dotvv = a%x*b%x + a%y*b%y
  end function dotvv
  
end module geometry

program test_dot
  use geometry
  implicit none
  type(vector2d) :: a, b
  a = vector2d(1.0, 2.0)
  b = vector2d(3.0, 4.0)
  print *, a .dot. b            ! 11.0
  print *, 1.0 + (a .dot. b)    ! 12.0
  ! Not allowed: read as (1.0 + a) .dot. b
  ! print *, 1.0 + a .dot. b
end program test_dot
