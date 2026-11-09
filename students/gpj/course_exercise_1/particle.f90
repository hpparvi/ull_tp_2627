! Module particle: a point mass for the N-body simulation.

module particle
    use geometry
    implicit none
    private

    ! Re-export everything from geometry module
    public :: dp, point3d, vector3d
    public :: sumvp, sumpv, subpv, subpp, mulrv, mulvr, divvr
    public :: sumvv, subvv, distance
    public :: operator(+), operator(-), operator(*), operator(/)
    
    ! A point mass
    type, public :: particle3d
        type(point3d) :: p ! position
        type(vector3d) :: v ! velocity
        real(dp) :: m ! mass
    end type particle3d

end module particle