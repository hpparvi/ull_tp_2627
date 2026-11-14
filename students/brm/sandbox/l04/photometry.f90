module photometry
    implicit none
contains

    elemental function flux_to_mag(flux) result(mag)
        real, intent(in) :: flux
        real :: mag
       !in an elemental function, one cannot add I/O operations like a print. If done, the compiler will throw an error. 
        mag = -2.5 * log10(flux)
    end function flux_to_mag

end module photometry