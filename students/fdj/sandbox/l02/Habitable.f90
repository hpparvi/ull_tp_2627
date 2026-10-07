! ===== TASK =====
! Set the luminosity L (L⊙ ) of a star, and the semi-major axis a (AU) and eccentricity e of a
! planet in variables. Report whether the planet is always, partly, or never in the habitable zone
! (and if never, whether it is too hot or too cold).
! ▶ Use two logical variables: is the periapsis in the zone, and is the apoapsis in the zone?
! ▶ Hint: .neqv. is true when exactly one of its operands is true.
! ▶ Reject eccentricities outside 0 ≤ e < 1. What if the orbit crosses the whole zone?ç
! ================

module habitable
    implicit none
contains
    function is_habitable(L, a, e) ! Units: L_sun, AU
        logical :: is_habitable

        real, intent(in) :: L, a, e
        real :: periapsis, apoapsis, r_in, r_out

        logical :: is_periapsis, is_apoapsis, too_hot, too_cold

        is_periapsis = .false.
        is_apoapsis  = .false.
        too_hot      = .false.
        too_cold     = .false.

        r_in  = sqrt(L/1.1)
        r_out = sqrt(L/0.53)
        
        periapsis = a*(1-e)
        apoapsis  = a*(1+e)

        if (r_in <= periapsis .and. periapsis <= r_out) then
            is_periapsis = .true.
        else if (periapsis <= r_in .and. apoapsis <= r_in) then
            too_hot  = .true.
        else if (periapsis >= r_out .and. apoapsis >= r_out) then
            too_cold = .true.
        end if

        if (r_in <= apoapsis .and. apoapsis <= r_out) then
            is_apoapsis  = .true.
        end if

        ! Check habitability
        if ((is_periapsis .eqv. is_apoapsis)) then    ! Are both points habitable or not habitable?
            if (is_periapsis .eqv. .true.) then          ! Both habitable
                print *, "The planet is fully habitable."
                is_habitable = .true.
            else if (too_cold .eqv. too_hot) then
                print *, "The planet is partly habitable, going through two extreme phases."
                is_habitable = .false.
            else if (too_cold .eqv. .true.) then         ! Neither is habitable. We check if it is too close or too far. 
                print *, "The planet is too far from the star (too cold)"
                 is_habitable = .false.
            else if (too_hot  .eqv. .true.) then
                print *, "The planet is too close to the star (too hot)"
                is_habitable = .false.
            end if
        else if ((is_periapsis .neqv. is_apoapsis)) then  
            print *, "The planet is partly habitable, having one extreme phase"
            is_habitable = .false.
        end if
    end function
end module

program new_world
    use habitable
    implicit none
    real :: L, a, e
    logical :: planet

    print *, "Enter the luminosity (L_sun), semi-major axis (AU) and eccentricity (0 < e < 1)."
    read *, L, a, e
    do while (e < 0 .or. e >= 1)
        print *, "Please, let the eccentricity be 0 <= e < 1"
        read *, e
    end do

    planet = is_habitable(L, a, e)

end program

