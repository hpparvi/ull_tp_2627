module kepler2
    implicit none
contains
    logical function mean_anomaly (M, e, eccentric_anomaly, n)
        real, intent(in) :: M, e   ! rad 
        real, intent(out) :: eccentric_anomaly
        integer, intent(out) :: n

        real :: E_n, E_n1   ! E_n , E_n+1
        logical :: converged

        E_n = M
        n = 0
        converged = .false.

        do while (.not. converged .and. n < 50)
            E_n1 = E_n - (E_n - e*sin(E_n) - M)/(1 - e*cos(E_n))
            n = n+1
            converged = abs(E_n1 - E_n) < 1.0e-6
            E_n = E_n1
        end do

        eccentric_anomaly = E_n
        mean_anomaly = converged
    end function
end module

program kepler_equation
    use kepler2
    implicit none
    real :: M, e, eccentric_anomaly
    integer :: iter
    logical :: converged

    print *, "Enter the mean anomaly and the eccentricity (0 <= e < 1)"
    read *, M, e
    do while (e < 0 .or. e >= 1)
        print *, "Please, enter a valid eccentricity"
        read *, e 
    end do

    converged = mean_anomaly(M, e, eccentric_anomaly, iter)

    if (converged) then
        print *, "The eccentric anomaly is ", eccentric_anomaly, " after ", iter, " iterations"
    else
        print *, "Warning: did not converge after ", iter, " iterations"
    end if
end program