program test_catalogue
    use star_catalogue
    implicit none

    type(star) :: my_stars(3)
    type(vector3d) :: com

    my_stars(1) = star("Sirius", 2.0, vector3d(0.0, 0.0, 0.0))
    my_stars(2) = star("Betelgeuse", 11.0, vector3d(10.0, 5.0, 2.0))
    my_stars(3) = star("Rigel", 21.0, vector3d(-5.0, 12.0, 4.0))

    print *, "Star names: ", my_stars%name
    
    print *, "Total mass: ", sum(my_stars%mass)
    
    com = centre_of_mass(my_stars)
    print *, "Centre of Mass (x,y,z): ", com%x, com%y, com%z
    
    print *, "Whole star print: ", my_stars(1)

end program test_catalogue

!If we use allocatable it throws an error since you cannot print an allocatable component