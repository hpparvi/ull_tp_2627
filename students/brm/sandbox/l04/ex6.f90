program test_photometry
    use photometry
    implicit none
    
    real :: single_flux, single_mag
    real :: flux_array(4), mag_array(4)
    
    single_flux = 100.0
    single_mag = flux_to_mag(single_flux)
    print *, "Magnitude: ", single_mag
    
    flux_array = [1.0, 10.0, 100.0, 1000.0]
    mag_array = flux_to_mag(flux_array)
    
    print *, "Magnitudes: ", mag_array
    
    flux_array = [100.0, 0.0, -50.0, 10.0]
    mag_array = -99.9 
    
    where (flux_array > 0.0)
        mag_array = flux_to_mag(flux_array)
    elsewhere
     
        mag_array = -99.9 
    end where
  
    print *, "Protected Magnitudes: ", mag_array

end program test_photometry