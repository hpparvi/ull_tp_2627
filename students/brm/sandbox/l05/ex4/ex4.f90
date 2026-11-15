program histogram
    implicit none
    
    integer, allocatable :: data_array(:)
    integer, allocatable :: counts(:)
    integer :: val, io_status
    integer :: min_val, max_val, i

    allocate(data_array(0))
    do
        read(*, *, iostat=io_status) val
        if (io_status < 0) exit
        data_array = [data_array, val]
    end do

    if (size(data_array) == 0) then
        print *, "Error: The input is empty. Please provide at least one integer."
        stop
    end if

    min_val = minval(data_array)
    max_val = maxval(data_array)
    
    allocate(counts(min_val:max_val))
    counts = 0 

    do i = 1, size(data_array)
        counts(data_array(i)) = counts(data_array(i)) + 1
    end do

    do i = min_val, max_val
        if (counts(i) > 0) then
            print *, "Value:", i, "  Count:", counts(i)
        end if
    end do

    print *, "Lower bound: ", lbound(counts, 1)
    print *, "Upper bound: ", ubound(counts, 1)
    print *, "Size of counts array:          ", size(counts)

end program histogram