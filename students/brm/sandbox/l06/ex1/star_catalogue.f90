module star_catalogue
    implicit none

    type vector3d
        real :: x, y, z
    end type vector3d

    type star
        character(len=20) :: name
        real :: mass
        type(vector3d) :: position
    end type star

contains

    function centre_of_mass(stars) result(com)
        type(star), intent(in) :: stars(:)
        type(vector3d) :: com
        real :: total_mass
        
        total_mass = sum(stars%mass)
        
        com%x = sum(stars%mass * stars%position%x) / total_mass
        com%y = sum(stars%mass * stars%position%y) / total_mass
        com%z = sum(stars%mass * stars%position%z) / total_mass
    end function centre_of_mass

end module star_catalogue