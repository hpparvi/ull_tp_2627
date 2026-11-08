! Direct N-body simulation with the leapfrog integrator.

program ex1
    use iso_fortran_env, only: error_unit
    use geometry
    use particle
    implicit none

    character(len=*), parameter :: output_file = 'output.dat'

    type(particle3d), allocatable :: b(:)    ! the particles
    type(vector3d), allocatable :: a(:)    ! the accelerations
    real(dp) :: dt, dt_out, t_end
    integer :: n, n_steps, out_every, step, i
    integer :: u_in, u_out, ios
    character(len=256) :: input_file

    ! --- Read the simulations ---
    if (command_argument_count() /=1 ) then
        write(error_unit, '(a)') 'Usage: ./ex1 <input file>'
        stop 1
    end if
    call get_command_argument(1, input_file)

    open(newunit=u_in, file=trim(input_file), status='old', action='read', iostat=ios)
    if (ios /= 0) then
        write(error_unit, '(a)') 'Cannot open the input file ' // trim(input_file)
        stop 1
    end if

    read(u_in, *) dt
    read(u_in, *) dt_out
    read(u_in, *) t_end
    read(u_in, *) n

    allocate(b(n), a(n))
    do i = 1, n
        read(u_in, *, iostat=ios) b(i)%m, b(i)%p, b(i)%v
        if (ios /= 0) then
            write(error_unit, '(a, i0)') 'Cannot read the particle ', i
            stop 1
        end if
    end do
    close(u_in)

    n_steps = nint(t_end / dt)
    out_every = max(1, nint(dt_out / dt))

    ! --- Integrate ---
    open(newunit=u_out, file=output_file, status='replace', action='write')
    call write_state(u_out, 0.0_dp, b)

    ! Accelerations at t = 0
    call accelerations(b, a)

    do step = 1, n_steps
        b%v = b%v + a * (dt / 2)     ! kick:  v(n+1/2) = v(n) + a(n) dt/2
        b%p = b%p + b%v * dt         ! drift: r(n+1)   = r(n) + v(n+1/2) dt
        call accelerations(b, a)     ! force: a(n+1) from r(n+1)
        b%v = b%v + a * (dt / 2)     ! kick:  v(n+1)   = v(n+1/2) + a(n+1) dt/2

        if (mod(step, out_every) == 0) call write_state(u_out, step * dt, b)
    end do

    close(u_out)
        
contains

    ! Compute the accelerations of the particles due to their mutual gravitational attraction.
    subroutine accelerations(b, a)
        type(particle3d), intent(in) :: b(:)
        type(vector3d), intent(out) :: a(:)
        type(vector3d) :: rji
        real(dp) :: r2, r3
        integer :: i, j

        a = vector3d(0.0_dp, 0.0_dp, 0.0_dp)
        do i = 1, size(b)
            do j = i + 1, size(b)
                rji = b(j)%p - b(i)%p
                r2 = rji%x**2 + rji%y**2 + rji%z**2
                r3 = r2 * sqrt(r2)
                a(i) = a(i) + rji * (b(j)%m / r3)
                a(j) = a(j) - rji * (b(i)%m / r3)
            end do
        end do
    end subroutine accelerations    

    ! Write one line of the output file, with the time and the state of all particles.
    subroutine write_state(u, t, b)
        integer, intent(in) :: u
        real(dp), intent(in) :: t
        type(particle3d), intent(in) :: b(:)
        integer :: i

        write(u, '(es23.15, *(1x, es23.15))') t, (b(i)%p, i = 1, size(b))
    end subroutine write_state

end program ex1
