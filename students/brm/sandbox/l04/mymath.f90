module mymath
    use kinds
    implicit none
   
    real(dp), parameter :: pi = 3.14159_dp
    
contains

    function circle_area(r) result(area)
        real(dp), intent(in) :: r
        real(dp) :: area
        area = pi * r**2
    end function circle_area
    
end module mymath