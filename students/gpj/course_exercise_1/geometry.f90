! Module geometry: points and vectors in 3D space.

module geometry
    use iso_fortran_env, only: real64
    implicit none
    private

    integer, parameter, public :: dp = real64

    type, public :: vector3d
        real(dp) :: x, y, z
    end type vector3d

    type, public :: point3d
        real(dp) :: x, y, z
    end type point3d

    public :: sumvp, sumpv, subpv, subpp, mulrv, mulvr, divvr
    public :: sumvv, subvv, distance
    public :: operator(+), operator(-), operator(*), operator(/)

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

    ! Vector + point
    elemental function sumvp(v, p) result(q)
        type(vector3d), intent(in) :: v
        type(point3d), intent(in) :: p
        type(point3d) :: q

        q = point3d(p%x + v%x, p%y + v%y, p%z + v%z)
    end function sumvp

    ! Point + vector
    elemental function sumpv(p, v) result(q)
        type(point3d), intent(in) :: p
        type(vector3d), intent(in) :: v
        type(point3d) :: q
        q = point3d(p%x + v%x, p%y + v%y, p%z + v%z)
    end function sumpv

    ! Point - vector
    elemental function subpv(p, v) result(q)
        type(point3d), intent(in) :: p
        type(vector3d), intent(in) :: v
        type(point3d) :: q
        q = point3d(p%x - v%x, p%y - v%y, p%z - v%z)
    end function subpv  

    ! Point - point
    elemental function subpp(p1, p2) result(v)
        type(point3d), intent(in) :: p1, p2
        type(vector3d) :: v
        v = vector3d(p1%x - p2%x, p1%y - p2%y, p1%z - p2%z)
    end function subpp

    ! Real * vector
    elemental function mulrv(r, v) result(w)
        real(dp), intent(in) :: r
        type(vector3d), intent(in) :: v
        type(vector3d) :: w
        w = vector3d(r * v%x, r * v%y, r * v%z)
    end function mulrv  

    ! Vector * real
    elemental function mulvr(v, r) result(w)
        type(vector3d), intent(in) :: v
        real(dp), intent(in) :: r
        type(vector3d) :: w
        w = vector3d(v%x * r, v%y * r, v%z * r)
    end function mulvr

    ! Vector / real
    elemental function divvr(v, r) result(w)
        type(vector3d), intent(in) :: v
        real(dp), intent(in) :: r
        type(vector3d) :: w
        w = vector3d(v%x / r, v%y / r, v%z / r)
    end function divvr

    ! Vector + vector
    elemental function sumvv(v1, v2) result(w)
        type(vector3d), intent(in) :: v1, v2
        type(vector3d) :: w
        w = vector3d(v1%x + v2%x, v1%y + v2%y, v1%z + v2%z)
    end function sumvv

    ! Vector - vector
    elemental function subvv(v1, v2) result(w)
        type(vector3d), intent(in) :: v1, v2
        type(vector3d) :: w
        w = vector3d(v1%x - v2%x, v1%y - v2%y, v1%z - v2%z)
    end function subvv

    ! Euclidean distance between two points
    elemental function distance(p1, p2) result(d)
        type(point3d), intent(in) :: p1, p2
        real(dp) :: d
        d = sqrt((p1%x - p2%x)**2 + (p1%y - p2%y)**2 + (p1%z - p2%z)**2)
    end function distance   

end module geometry