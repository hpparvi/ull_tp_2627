program test_vector_ops
    use vector_math
    implicit none

    type(vector3d) :: a, b, c

    a = vector3d(1.0, 0.0, 0.0)
    b = vector3d(0.0, 1.0, 0.0)

    c = a .cross. b
    print *, "c = a .cross. b :", c%x, c%y, c%z
    print *, "c .dot. a       :", c .dot. a
    print *, "c .dot. b       :", c .dot. b

end program test_vector_ops

!   In Fortran, custom named operators (like .dot.) have the 
    !lowest precedence, even lower than addition or multiplication.
    ! If we make 2.0 * a .dot. b, it evaluates as (2.0 * a) .dot. b.
    ! If we make 1.0 + a .dot. b it evaluates as (1.0 + a) .dot. b. Because we did not define 
    ! a '+' operator for adding a real to a vector3d, this causes 
    ! a compiler error. To add 1.0 to the scalar result of the dot 
    ! product, you must use parentheses: 1.0 + (a .dot. b).
    ! By adding the elemental keyword to the operator functions in the module, you can now pass entire arrays of vector3d 
    ! objects to these operators instead of just single scalars.
    ! If u and v are arrays of vectors, writing 'u .dot. v' will 
    ! automatically perform an element-by-element dot product and 
    ! return an array of reals, all without needing a do-loop. Convenient.