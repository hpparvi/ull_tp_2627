! ===== TASK =====
! Set the semi-major axis a (AU) of a planet and the mass M (M⊙ ) of its star in variables. Print
! the orbital period in years, in days, and as a whole number of days.
! ▶ Store the number of days in a year (365.25) as a parameter.
! ▶ Stop with an error message if either value is not positive (stop ’message’).
! ▶ Get the whole days by converting the period to an integer. Try both plain assignment
! and int(): what does -Wall say?
! ================


module kepler
    implicit none
contains
    function period (a, M)

        real :: period              ! output
        real, intent(in) :: a, M    ! semi major axis and mass
        
        period = ((a**3)/M)**(1.0/2) 

    end function period
end module kepler

program calculate_period
    use kepler
    implicit none
    real :: a, M
    real, parameter :: year_to_days = 365.25
    print *, 'Lets calculate the orbital period. Enter the semi-major axis and mass of your planet.'
    print *, 'The period is:'
    print *, period(a, M), 'years.'
    print *, period(a, M)*year_to_days, 'days.'
    print *, int(period(a, M)*year_to_days), 'days.'

end program calculate_period




