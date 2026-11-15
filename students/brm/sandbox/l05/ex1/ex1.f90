program growing_array
    implicit none
    real, allocatable :: a(:)
    real :: x
    integer :: io_status, n

    allocate(a(0))

    do
        read(*, *, iostat=io_status) x
        
        if (io_status < 0) exit 
        
        a = [a, x]
    end do

    n = size(a)

    if (n == 0) then
        print *, "Error: The input is empty. Please provide at least one number."
        stop
    end if

    print *, "Number of values: ", n
    print *, "Mean:             ", sum(a) / real(n)
    print *, "Reverse order:    ", a(n:1:-1)

end program growing_array