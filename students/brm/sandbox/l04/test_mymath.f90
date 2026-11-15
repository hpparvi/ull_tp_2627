program test_mymath
    use kinds
    use mymath
    implicit none

    real(dp) :: radius
    radius = 2.0_dp

    print *, "Radius: ", radius
    print *, "Area:   ", circle_area(radius)
    
end program test_mymath