program machine_epsilon
    implicit none

    real(kind=8) :: eps = 1.0
    
    do while (1.0 + eps/2 > 1.0)
    eps = eps/2
    end do
    
    print *, "The value of epslion is", eps
    print *, "The intrinsic function yields", epsilon(eps)

end program