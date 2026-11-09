! contains: 
! - sumvp: sum vector + point = point
! - sumpv: sum point + vector = point
! - subpv: substraction point - vector = point
! - subpp: substraction point - point = vector
! - mulrv: multiplication real * vector = vector 
! - mulvr: multiplication vector * real = vector
! - divvr: dividing vector / real = vector
! - dist: calculates the norm of the vector connecting two points


module geometry
    
    use iso_fortran_env, only: real64, int64 
    implicit none

    integer, parameter :: dp = real64

    type :: vector3d
        real(dp) :: x, y, z
    end type vector3d

    type :: point3d
        real(dp) :: a, b, c
    end type point3d

    interface operator(+)
        module procedure sumvp, sumpv, sumvv
    end interface
    interface operator(-)
        module procedure subpv, subpp, subvv
    end interface
    interface operator(*)
        module procedure mulrv, mulvr
    end interface
    interface operator(/)
        module procedure divvr
    end interface

    contains
        elemental type(vector3d) function sumvv(v1, v2)
            type(vector3d), intent(in) :: v1, v2
            sumvv = vector3d(v1%x + v2%x, v1%y + v2%y, v1%z + v2%z)
        end function sumvv

        elemental type(vector3d) function subvv(v1, v2)
            type(vector3d), intent(in) :: v1, v2
            subvv = vector3d(v1%x - v2%x, v1%y - v2%y, v1%z - v2%z)
        end function subvv

        elemental type(point3d) function sumvp(v1, p1)
            type(vector3d), intent(in) :: v1
            type(point3d) , intent(in) :: p1
                sumvp = point3d(v1%x + p1%a, v1%y + p1%b, v1%z + p1%c)
        end function sumvp

        elemental type(point3d) function sumpv(p1, v1)
            type(vector3d), intent(in) :: v1
            type(point3d) , intent(in) :: p1
                sumpv = sumvp(v1,p1)
        end function sumpv

        elemental type(point3d) function subpv(p1, v1)
            type(vector3d), intent(in) :: v1
            type(point3d) , intent(in) :: p1
                subpv = point3d(p1%a - v1%x, p1%b - v1%y, p1%c - v1%z)
        end function subpv

        elemental type(vector3d) function subpp(p1, p2)
            type(point3d), intent(in) :: p1, p2
                subpp = vector3d(p1%a - p2%a, p1%b - p2%b, p1%c - p2%c)
        end function subpp

        elemental type(vector3d) function mulrv(r, v)
            real(dp), intent(in) :: r
            type(vector3d), intent(in) :: v
            mulrv = vector3d(r*v%x, r*v%y, r*v%z)
        end function mulrv

        elemental type(vector3d) function mulvr(v, r)
            real(dp), intent(in) :: r
            type(vector3d), intent(in) :: v
            mulvr = mulrv(r, v)
        end function mulvr

        elemental type(vector3d) function divvr(v, r)
            real(dp), intent(in) :: r
            type(vector3d), intent(in) :: v
            divvr = vector3d(v%x/r, v%y/r , v%z/r)
        end function divvr  
        
        elemental real(dp) function dist(p1, p2)
            type(point3d), intent(in) :: p1, p2
            type(vector3d) :: v
            v = subpp(p1,p2)
            dist = sqrt(v%x**2 + v%y**2 + v%z**2)
        end function dist




end module geometry
