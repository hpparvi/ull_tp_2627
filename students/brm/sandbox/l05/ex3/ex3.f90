
program test_sigma_clipping
    use kinds
    use sigma_clipping
    implicit none
    
    real(dp), allocatable :: data_array(:), temp_array(:)
    real(dp) :: nsigma
    
    data_array = [10.1_dp, 9.8_dp, 10.3_dp, 9.9_dp, 55.0_dp, 10.0_dp, 10.2_dp]
    nsigma = 2.0_dp
    
    print *, "Original data: ", data_array
    
    temp_array = clip(data_array, nsigma)
    
    print *, "Clipped data:  ", temp_array
    
    
    data_array = [10.1_dp, 9.8_dp, 10.3_dp, 9.9_dp, 55.0_dp, 10.0_dp, 10.2_dp]
    
    do
        temp_array = clip(data_array, nsigma)
                if (size(temp_array) == size(data_array)) exit
        
        data_array = temp_array
    end do
    
    print *, "Final array: ", data_array
    print *, "Final mean:  ", sum(data_array) / real(size(data_array), dp)
    
end program test_sigma_clipping
! The 55 value is removed since it is treated as an outlier and falls outside the 2sigma. 
! We need to allocate that array, yes, altough i think in modern fortran version it is dealt with automatically.