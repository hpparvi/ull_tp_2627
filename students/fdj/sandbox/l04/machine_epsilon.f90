program machine_epsilon
    use iso_fortran_env, only: real32, real64
    implicit none
    
    real(real32) :: eps_32
    real(real64) :: eps_64

    eps_32 = 1.0
    print *, "For real32: "
    do while (1.0 + eps_32/2 > 1.0)
        eps_32 = eps_32/2
        print *, eps_32
    end do

    eps_64 = 1.0
    print *, "For real64: "
    do while (1.0 + eps_64/2 > 1.0)
        eps_64 = eps_64/2
        print *, eps_64
    end do

    print *, " "
    print *, "For 32-bytes, epsilon =", epsilon(eps_32)
    print *, "For 64-bytes, epsilon =", epsilon(eps_64)

end program