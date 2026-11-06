program quadratic_roots
    implicit none

    !32
    real(kind=4) :: a_32, b_32, c_32
    real(kind=4) :: disc_32, rootplus_32, rootminus_32, x_32, root_32

    ! 64
    real(kind=8) :: a_64, b_64, c_64
    real(kind=8) :: disc_64, rootplus_64, rootminus_64, x_64, root_64

    a_32 = 1.0
    b_32 = -10000.0
    c_32 = 1.0

    disc_32 = sqrt(b_32**2 - 4.0 * a_32 * c_32)
    
    rootplus_32 = (-b_32 + disc_32) / (2.0 * a_32)
    rootminus_32 = (-b_32 - disc_32) / (2.0 * a_32)
    
    root_32 = rootminus_32

    print *, "32-bit Reals"
    print *, "Root (+): ", rootplus_32
    print *, "Root (-): ", rootminus_32

    x_32 = (c_32 / a_32) / rootplus_32
    
    print *, "32-bit Reals"
    print *, "Small root fixed (x_32): ", x_32

    a_64 = 1.0_8
    b_64 = -10000.0_8
    c_64 = 1.0_8

    disc_64 = sqrt(b_64**2 - 4.0_8 * a_64 * c_64)
    rootplus_64 = (-b_64 + disc_64) / (2.0_8 * a_64)
    rootminus_64 = (-b_64 - disc_64) / (2.0_8 * a_64)
    
    root_64 = rootminus_64
    
    x_64 = (c_64 / a_64) / rootplus_64

    print *, "64-bit Reals"
    print *, "Small root (-) (64-bit): ", rootminus_64

end program quadratic_roots