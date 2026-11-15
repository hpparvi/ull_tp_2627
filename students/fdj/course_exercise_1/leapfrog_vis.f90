! Direct N-body simulation with the leapfrog (kick-drift-kick) integrator.
! Versión original (arrays de reales), leyendo de fichero y escribiendo en output_original.dat
!
!   gfortran -o leapfrog_original leapfrog_original.f90
!   ./leapfrog_original input.dat
program leapfrog
    implicit none
    integer :: i, j, n, step, n_steps, out_every
    real :: dt, t_end, dt_out
    real :: r2, r3, t
    
    real, dimension(:), allocatable :: m
    real, dimension(:,:), allocatable :: r, v, a
    real, dimension(3) :: rji
    
    character(len=256) :: fname
    integer :: u_in, u_out, ios
    
    ! fichero de entrada: primer argumento de la línea de comandos (por defecto input.dat)
    fname = 'input.dat'
    if (command_argument_count() >= 1) call get_command_argument(1, fname)
    
    open(newunit=u_in, file=trim(fname), status='old', action='read', iostat=ios)
    if (ios /= 0) then
       print *, 'No se puede abrir el fichero: ', trim(fname)
       stop 1
    end if
    
    read(u_in, *) dt
    read(u_in, *) dt_out
    read(u_in, *) t_end
    read(u_in, *) n
    
    allocate(m(n))
    allocate(r(n,3))
    allocate(v(n,3))
    allocate(a(n,3))
    
    do i = 1, n
        read(u_in, *) m(i), r(i,:), v(i,:) 
    end do
    close(u_in)
    
    open(newunit=u_out, file='output_original.dat', status='replace', action='write')
    
    n_steps = nint(t_end / dt)
    out_every = max(1, nint(dt_out / dt))

    ! estado inicial (t = 0), igual que en la versión con tipos derivados
    write(u_out, '(*(es23.15e3,1x))') 0.0, (r(i,:), i = 1, n)

    a = 0.0
    do i = 1, n
        do j = i+1, n
            rji = r(j,:) - r(i,:)
            r2 = sum(rji**2)
            r3 = r2 * sqrt(r2)
            a(i,:) = a(i,:) + m(j) * rji / r3
            a(j,:) = a(j,:) - m(i) * rji / r3
        end do
    end do
    
    do step = 1, n_steps
        v = v + a * dt/2
        r = r + v * dt
        a = 0.0
        do i = 1, n
            do j = i+1, n
                rji = r(j,:) - r(i,:)
                r2 = sum(rji**2)
                r3 = r2 * sqrt(r2)
                a(i,:) = a(i,:) + m(j) * rji / r3
                a(j,:) = a(j,:) - m(i) * rji / r3
            end do
        end do
    
          v = v + a * dt/2
    
        if (mod(step, out_every) == 0) then
            t = step * dt
            write(u_out, '(*(es23.15e3,1x))') t, (r(i,:), i = 1, n)
        end if
    end do
    
    close(u_out)

end program leapfrog