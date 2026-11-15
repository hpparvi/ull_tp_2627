!main program for N-body simulation with leapfrog integrator using modules kinds, geomtry and particle
program ex1
  use kinds, only: dp
  use geometry, only: point3d, vector3d, operator(+), operator(-), operator(*), operator(/)
  use particle, only: particle3d
  implicit none

  integer :: i, j, n, step, n_steps, out_every, ios
  real(dp) :: dt, t_end, dt_out, r2, r3
  !softening length squared (eps^2 = 1e-6) to prevent singularities during close encounters
  real(dp), parameter :: eps2 = 1.0e-6_dp
  !variables for optional energy conservation diagnostics
  real(dp) :: e_kin, e_pot, e_tot, e_init, rel_err
  character(len=256) :: input_file
  character(len=32)  :: energy_flag
  logical :: calc_energy

  type(particle3d), allocatable :: bodies(:)
  type(vector3d), allocatable :: a(:)
  type(vector3d) :: rji

  ! Read the simulation setup from a file given as  a command-line argument
  if (command_argument_count() < 1 .or. command_argument_count() > 2) then
     print *, "Usage: ./ex1 <input_file> [energy]"
     stop 1
  end if
  call get_command_argument(1, input_file)

  ! Check if the optional second argument enables energy calculation
  calc_energy = .false.
  if (command_argument_count() == 2) then
     call get_command_argument(2, energy_flag)
     if (trim(energy_flag) == "energy") then
        calc_energy = .true.
     else
        print *, "Unknown flag: ", trim(energy_flag), ". Use 'energy' to enable energy diagnostics."
        stop 1
     end if
  end if

  open(unit=10, file=trim(input_file), status='old', action='read', iostat=ios)
  if (ios /= 0) then
     print *, "Error opening input file: ", trim(input_file)
     stop 1
  end if

  read(10, *) dt
  read(10, *) dt_out
  read(10, *) t_end
  read(10, *) n

  allocate(bodies(n))
  allocate(a(n))

  do i = 1, n
     read(10, *) bodies(i)%m, bodies(i)%p%x, bodies(i)%p%y, bodies(i)%p%z, &
                 bodies(i)%v%x, bodies(i)%v%y, bodies(i)%v%z
  end do
  close(10)

  open(unit=20, file='output.dat', status='replace', action='write')
  ! Open secondary diagnostic file only if the energy flag is active
  if (calc_energy) then
     open(unit=30, file='energy.dat', status='replace', action='write')
     write(30, '(a)') "# time          E_kin           E_pot           E_tot           rel_error"
  end if

  n_steps = nint(t_end / dt)
  out_every = max(1, nint(dt_out / dt))

  ! initial accelerations calculatio
  !$omp parallel do
  do i = 1, n
     a(i) = vector3d(0.0_dp, 0.0_dp, 0.0_dp)
  end do
  
  !$omp parallel do private(j, rji, r2, r3) schedule(dynamic)
  do i = 1, n
     do j = 1, n
        if (i == j) cycle
        
        rji = bodies(j)%p - bodies(i)%p
        !softening length squared eps2 to r2
        r2 = rji%x**2 + rji%y**2 + rji%z**2 + eps2
        r3 = r2 * sqrt(r2)
        
        a(i)%x = a(i)%x + rji%x * (bodies(j)%m / r3)
        a(i)%y = a(i)%y + rji%y * (bodies(j)%m / r3)
        a(i)%z = a(i)%z + rji%z * (bodies(j)%m / r3)
     end do
  end do

  ! Compute initial energy at t = 0 if energy flag is enabled
  if (calc_energy) then
     e_kin = 0.0_dp
     e_pot = 0.0_dp
     !$omp parallel do reduction(+:e_kin)
     do i = 1, n
        e_kin = e_kin + 0.5_dp * bodies(i)%m * &
                (bodies(i)%v%x**2 + bodies(i)%v%y**2 + bodies(i)%v%z**2)
     end do
     !$omp parallel do private(j, rji, r2) reduction(+:e_pot) schedule(dynamic)
     do i = 1, n - 1
        do j = i + 1, n
           rji = bodies(j)%p - bodies(i)%p
           r2 = rji%x**2 + rji%y**2 + rji%z**2 + eps2
           e_pot = e_pot - (bodies(i)%m * bodies(j)%m) / sqrt(r2)
        end do
     end do
     e_init = e_kin + e_pot
     write(30, '(f12.6, 4(1x, es15.7))') 0.0_dp, e_kin, e_pot, e_init, 0.0_dp
  end if

  ! leapfrog integration loop
  do step = 1, n_steps
     ! 1.kick component-wise
     do i = 1, n
        bodies(i)%v%x = bodies(i)%v%x + a(i)%x * (dt / 2.0_dp)
        bodies(i)%v%y = bodies(i)%v%y + a(i)%y * (dt / 2.0_dp)
        bodies(i)%v%z = bodies(i)%v%z + a(i)%z * (dt / 2.0_dp)
     end do

     ! 2.drift using sumpv and mulvr
     do i = 1, n
        bodies(i)%p = bodies(i)%p + bodies(i)%v * dt
     end do

     ! 3.force, accelerations from new positions
     !$omp parallel do
     do i = 1, n
        a(i) = vector3d(0.0_dp, 0.0_dp, 0.0_dp)
     end do
     
     !$omp parallel do private(j, rji, r2, r3) schedule(dynamic)
     do i = 1, n
        do j = 1, n
           if (i == j) cycle
           
           rji = bodies(j)%p - bodies(i)%p
           ! Add softening length squared eps2 to r2
           r2 = rji%x**2 + rji%y**2 + rji%z**2 + eps2
           r3 = r2 * sqrt(r2)
           
           a(i)%x = a(i)%x + rji%x * (bodies(j)%m / r3)
           a(i)%y = a(i)%y + rji%y * (bodies(j)%m / r3)
           a(i)%z = a(i)%z + rji%z * (bodies(j)%m / r3)
        end do
     end do

     ! 4.kick again component-wise
     do i = 1, n
        bodies(i)%v%x = bodies(i)%v%x + a(i)%x * (dt / 2.0_dp)
        bodies(i)%v%y = bodies(i)%v%y + a(i)%y * (dt / 2.0_dp)
        bodies(i)%v%z = bodies(i)%v%z + a(i)%z * (dt / 2.0_dp)
     end do

     ! write output in the following format: t p1x p1y p1z p2x p2y p2z ... pnx pny pnz
     if (mod(step, out_every) == 0) then
        write(20, '(f12.6)', advance='no') step * dt
        do i = 1, n
           write(20, '(3(1x, es15.7))', advance='no') bodies(i)%p%x, bodies(i)%p%y, bodies(i)%p%z
        end do
        write(20, *) "" ! Move to the next line

        !compute and log current energy state at output steps if enabled
        if (calc_energy) then
           e_kin = 0.0_dp
           e_pot = 0.0_dp
           !$omp parallel do reduction(+:e_kin)
           do i = 1, n
              e_kin = e_kin + 0.5_dp * bodies(i)%m * &
                      (bodies(i)%v%x**2 + bodies(i)%v%y**2 + bodies(i)%v%z**2)
           end do
           !$omp parallel do private(j, rji, r2) reduction(+:e_pot) schedule(dynamic)
           do i = 1, n - 1
              do j = i + 1, n
                 rji = bodies(j)%p - bodies(i)%p
                 r2 = rji%x**2 + rji%y**2 + rji%z**2 + eps2
                 e_pot = e_pot - (bodies(i)%m * bodies(j)%m) / sqrt(r2)
              end do
           end do
           e_tot = e_kin + e_pot
           rel_err = (e_tot - e_init) / abs(e_init)
           write(30, '(f12.6, 4(1x, es15.7))') step * dt, e_kin, e_pot, e_tot, rel_err
        end if
     end if
  end do

  close(20)
  if (calc_energy) close(30)

end program ex1