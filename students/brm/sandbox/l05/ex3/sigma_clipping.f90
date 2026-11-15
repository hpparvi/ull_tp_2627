module sigma_clipping
    use kinds
    implicit none
contains
  
    function clip(x, nsigma) result(clipped_x)
        real(dp), intent(in) :: x(:)
        real(dp), intent(in) :: nsigma
        real(dp), allocatable :: clipped_x(:)
        
        real(dp) :: x_mean, x_std
        integer :: n, i, j, keep_count
        
        n = size(x)
        
        if (n == 0) then
            allocate(clipped_x(0))
            return
        end if
        
        x_mean = sum(x) / real(n, dp)
        
        if (n > 1) then
            x_std = sqrt(sum((x - x_mean)**2) / real(n - 1, dp))
        else
            x_std = 0.0_dp
        end if
       
        keep_count = 0
        do i = 1, n
            if (abs(x(i) - x_mean) <= nsigma * x_std) then
                keep_count = keep_count + 1
            end if
        end do
        
        
        allocate(clipped_x(keep_count))
        
        j = 1
        do i = 1, n
            if (abs(x(i) - x_mean) <= nsigma * x_std) then
                clipped_x(j) = x(i)
                j = j + 1
            end if
        end do
        
    end function clip

end module sigma_clipping
