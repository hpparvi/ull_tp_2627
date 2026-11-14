program pointer_exercises
    implicit none

    
    real, target :: a(3) = [1.0, 2.0, 3.0]
    real, target :: b(3) = [4.0, 5.0, 6.0]
    real, pointer :: p(:) => null()
    real, pointer :: q(:) => null()
    real, pointer :: temp(:) => null() ! スワップ用のテンポラリポインタ

    p => a
    q => b
    p(2) = 99.0
    print *, "--- Task 2 ---"
    print *, "Array a: ", a

    temp => p
    p => q
    q => temp

    print *, "--- Task 4 ---"
    print *, "Is p associated with b? ", associated(p, b)
    print *, "Is q associated with a? ", associated(q, a)

    allocate(p(3))
    p = [7.0, 8.0, 9.0]
    
    deallocate(p)

end program pointer_exercises