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
    integer :: period_int, period_plain
    logical :: debugging = .false.
    real, parameter :: year_to_days = 365.25
    print *, 'Lets calculate the orbital period. Enter the semi-major axis and mass of your planet.'
    read *, a, M

    do while (a < 0 .or. M < 0) 
        print *, 'Please insert positive values.'
        read *, a, M
    end do
    
    print *, 'The period is:'
    print *, period(a, M), 'years.'
    if (debugging .eqv. .true.) then
        print *, "Plain assingment:"
    end if

    period_plain = period(a, M)*year_to_days
    print *, period_plain, 'days.'

    if (debugging .eqv. .true.) then
        print *, "int( )"
        period_int = int(period(a, M)*year_to_days)
        print *, period_int, 'days.'
    end if
end program calculate_period




