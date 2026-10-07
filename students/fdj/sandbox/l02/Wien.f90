! Use page 21 of l02.pdf for the negative (and positive) loop
! for the table

! ===== TASK =====
! Print a table of the peak emission wavelength λmax of a blackbody for
! T = 3000, 6000, . . . , 30 000 K, using an integer loop variable. Then print the table again,
! hottest first, using a negative step.
! ▶ Print the loop variable after each loop. Can you explain the values?
! ▶ What would you get if b were the integer constant 2897772?
! ================


module wien 
    implicit none
contains
    function lambda (T)
        real :: lambda
        real, intent(in) :: T  ! K
        integer, parameter :: b = 2897772  ! nm

        ! lambda = 2.897772 * (10**6) / T
         lambda = b / T
    end function
end module

program wien_law
    
    use wien
    real :: lambda_max
    integer :: aux
    real :: temp

    print *, " Forth:"
    do aux = 3000, 30000, 3000
        temp = real(aux)
        lambda_max = lambda (temp)
        print *, temp, " - ", lambda_max 
    end do
    print *, " Back:"
    do aux = 30000, 3000, -3000
        temp = real(aux)
        lambda_max = lambda (temp)
        print *, temp, " - ", lambda_max 
    end do


end program