module stats
    use kinds
    implicit none
    private 
    public :: mean_and_std 

contains

    subroutine mean_and_std(x, mean, std)
        real(dp), intent(in) :: x(:)
        real(dp), intent(out) :: mean, std
        integer :: n
        
        n = size(x)
        
        if (n == 0) then
            mean = 0.0_dp
            std = 0.0_dp
            return
        end if
        
        mean = sum(x) / real(n, dp)
        
        if (n > 1) then
            std = sqrt(sum((x - mean)**2) / real(n - 1, dp))
        else
            std = 0.0_dp
        end if
    end subroutine mean_and_std
! if we try to modify x, we cant, since we said it was just an input parameter in the subroutine so the compiler fails
end module stats