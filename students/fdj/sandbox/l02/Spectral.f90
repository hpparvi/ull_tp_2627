! ===== TASK =====
! Set the effective temperature Teff (K) of a star in an integer variable and print its spectral
! class using select case. Store the class letter in a character(len=1) variable and print it
! with //. Temperatures outside the sequence should give a message.
! ================

module spec
    implicit none
contains 
    function spectral_class (T)
        integer, intent(in) :: T 
        character(len=1) :: spectral_class

        select case (T)
        case (0:2399)
            spectral_class = "?"
            print *, "Please, select a temperature hotter than 2400 K"
        case (2400:3699)
            spectral_class = "M"
        case (3700:5199)
            spectral_class = "K"
        case (5200:5999)
            spectral_class = "G"
        case (6000:7499)
            spectral_class = "F"
        case (7500:9999)
            spectral_class = "A"
        case (10000:29999)
            spectral_class = "B"
        case (30000:)
            spectral_class = "O"
        case default
            spectral_class = "?"
            print *, "Please choose a positive temperature."
        end select
    end function
end module

program spectral_classification
    use spec
    implicit none
    real :: temp
    character(len=1) :: class

    print *, "Please enter the star temperature in Kelvin."
    read *, temp
    class = spectral_class(int(temp))
    
    do while (class == "?" )
        read *, temp
        class = spectral_class(int(temp))
    end do
    print *, "The star type corresponding to", temp, "Kelvin is ", class, "-type." 
    ! Couldn't use "//" instead of "," because I wanted to print the temperature too.
end program