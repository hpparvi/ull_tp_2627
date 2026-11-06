program ex5
    use kinds
    use stats, only: mean_and_std
    implicit none
    
    real(dp) :: data_array(5)
    real(dp) :: calc_mean, calc_std
    
    data_array = [4.2_dp, 3.9_dp, 4.5_dp, 4.1_dp, 4.3_dp]
    
    call mean_and_std(data_array, calc_mean, calc_std)
    
    print *, "Data: ", data_array
    print *, "Mean: ", calc_mean
    print *, "Sample Standard Deviation: ", calc_std
    
end program ex5