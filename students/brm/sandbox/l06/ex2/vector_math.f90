module vector_math
    implicit none

    type vector3d
        real :: x, y, z
    end type vector3d

    interface operator(+)
        module procedure add_vec
    end interface

    interface operator(-)
        module procedure sub_vec
    end interface

    interface operator(*)
        module procedure mult_real_vec
    end interface

    interface operator(.dot.)
        module procedure dot_prod
    end interface

    interface operator(.cross.)
        module procedure cross_prod
    end interface

contains

    elemental function add_vec(a, b) result(c)
        type(vector3d), intent(in) :: a, b
        type(vector3d) :: c
        c%x = a%x + b%x
        c%y = a%y + b%y
        c%z = a%z + b%z
    end function add_vec

    elemental function sub_vec(a, b) result(c)
        type(vector3d), intent(in) :: a, b
        type(vector3d) :: c
        c%x = a%x - b%x
        c%y = a%y - b%y
        c%z = a%z - b%z
    end function sub_vec

    elemental function mult_real_vec(s, v) result(c)
        real, intent(in) :: s
        type(vector3d), intent(in) :: v
        type(vector3d) :: c
        c%x = s * v%x
        c%y = s * v%y
        c%z = s * v%z
    end function mult_real_vec

    elemental function dot_prod(a, b) result(d)
        type(vector3d), intent(in) :: a, b
        real :: d
        d = a%x*b%x + a%y*b%y + a%z*b%z
    end function dot_prod

    elemental function cross_prod(a, b) result(c)
        type(vector3d), intent(in) :: a, b
        type(vector3d) :: c
        c%x = a%y*b%z - a%z*b%y
        c%y = a%z*b%x - a%x*b%z
        c%z = a%x*b%y - a%y*b%x
    end function cross_prod

end module vector_math