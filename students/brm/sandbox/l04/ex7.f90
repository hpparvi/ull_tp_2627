
program test_recursion
    use recursive_math
    implicit none
    
    print *, "5!  = ", factorial(5)
    print *, "10! = ", factorial(10)
    print *, "-3! = ", factorial(-3), " (Invalid input handling)"
    
    print *, "Recursive: ", fibonacci(10)
    print *, "Iterative: ", fibonacci_iterative(10)

end program test_recursion