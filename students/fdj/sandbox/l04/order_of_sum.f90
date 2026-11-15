program sum
    use iso_fortran_env, only: real32, real64
    real(real32) :: k, add
    real(real64) :: k_64, add_64

    k = 1.0
    add = 0.0
    do while (k <= 10**7)
        add = add + 1.0/k
        k = k + 1
    end do

    print *, "add = ", add
    print *, "k has now the value ", k
    
    k = 10**7
    add = 0.0
    do while (k >= 1)
        add = add + 1.0/k
        k = k - 1
    end do

    print *, "add = ", add
    print *, "k has now the value ", k

    print *, "Now for 64-bytes: "

    k_64 = 1.0
    add_64 = 0.0
    do while (k_64 <= 10**7)
        add_64 = add_64 + 1.0/k_64
        k_64 = k_64 + 1
    end do

    print *, "add_64 = ", add_64
    print *, "k_64 has now the value ", k_64
    
    k_64 = 10**7
    add_64 = 0.0
    do while (k_64 >= 1)
        add_64 = add_64 + 1.0/k_64
        k_64 = k_64 - 1
    end do

    print *, "add_64 = ", add_64
    print *, "k_64 has now the value ", k_64
   
end program