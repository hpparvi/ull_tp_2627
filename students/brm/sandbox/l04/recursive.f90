module recursive_math
    implicit none
contains

    recursive function factorial(n) result(fact)
        integer, intent(in) :: n
        integer :: fact
        
        if (n < 0) then
            fact = -1 
        else if (n == 0) then
            fact = 1
        else
            fact = n * factorial(n - 1)
        end if
    end function factorial

    recursive function fibonacci(n) result(fib)
        integer, intent(in) :: n
        integer :: fib
        
        if (n <= 0) then
            fib = -1 ! 無効な入力
        else if (n == 1 .or. n == 2) then
            fib = 1
        else
            fib = fibonacci(n - 1) + fibonacci(n - 2)
        end if
    end function fibonacci

    function fibonacci_iterative(n) result(fib)
        integer, intent(in) :: n
        integer :: fib, i, a, b
        
        if (n <= 0) then
            fib = -1
        else if (n == 1 .or. n == 2) then
            fib = 1
        else
            a = 1
            b = 1
            do i = 3, n
                fib = a + b
                a = b
                b = fib
            end do
        end if
    end function fibonacci_iterative

end module recursive_math
