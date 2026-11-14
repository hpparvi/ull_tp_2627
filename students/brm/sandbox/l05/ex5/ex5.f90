program image_window
    implicit none
    
    integer :: nx, ny
    real, allocatable, target :: image(:,:)
    real, pointer :: window(:,:) => null()
    real, pointer :: col_ptr(:) => null()
    
    read(*, *) nx, ny
    
    allocate(image(nx, ny))
    image = 0.0
    
    window => image(nx/4+1:3*nx/4, ny/4+1:3*ny/4)
    
    print *, "Shape of window: ", shape(window)
    print *, "Lower bounds:    ", lbound(window)
    
    window = 1.0
    print *, "Sum of image:    ", sum(image)
    
    col_ptr => image(1:nx:2, 1)
    
    col_ptr = 5.0
    print *, "First column:    ", image(:, 1)
    
    deallocate(image)
    
    print *, "Is window associated? ", associated(window)
    
    nullify(window)
    nullify(col_ptr)

end program image_window