program order_sum
    implicit none

    integer :: k
    integer, parameter :: N = 10000000
    
    ! 32 bit real
    real(kind=4) :: sum_up_32, sum_down_32
    
    ! 64 bit real
    real(kind=8) :: sum_ref_64
    
    ! sum upwards
    sum_up_32 = 0.0
    do k = 1, N
        sum_up_32 = sum_up_32 + 1.0 / real(k, kind=4) !! it is necessary to specify real since if not, it will perform an integer division
    end do
    
    ! sum downwards
    sum_down_32 = 0.0
    do k = N, 1, -1
        sum_down_32 = sum_down_32 + 1.0 / real(k, kind=4)
    end do
    
    ! --- Task 3: 64-bit reference sum ---
    sum_ref_64 = 0.0_8
    do k = 1, N
        sum_ref_64 = sum_ref_64 + 1.0_8 / real(k, kind=8)
    end do
    
    ! Output results
    print *, "Task 1 (32-bit upwards):  ", sum_up_32
    print *, "Task 2 (32-bit downwards):", sum_down_32
    print *, "Task 3 (64-bit reference):", sum_ref_64
    
end program

! If we add the big number first, in the downwards sum, we will be avoiding rounding off errors since when using the small numbers first, 1/1e7 results
! in a very small number that makes us lose a lot of precision. That is why the downwards sum approaches much more to the 64 bit precision number.