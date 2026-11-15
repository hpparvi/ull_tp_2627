! Initial conditions are created using "sphere.f90"
! run a simulation employing the leapfrog algorithm.

program ex1
   
   !!!!!!!!!!!!!!!!
   ! LIBRARIES
   !!!!!!!!!!!!!!!!
   !$ use omp_lib
   use iso_fortran_env, only: int64, real64, iostat_end
   use geometry
   use particle
   use gravitational_acceleration
   use read_input

   implicit none

   !!!!!!!!!!!!!!!!!
   ! CREATING VARIABLES
   !!!!!!!!!!!!!!!!!

   integer :: N, ident,n_steps, step, unit ! Loops integer and ios
   type(vector3d), allocatable :: a(:)   ! accelerations
   real(real64) :: dt, snap_step, total_time, sim_time, total_simulated ! time step
   type(particle3d), allocatable :: particles(:) ! allocatable particles
   character(len=100) :: name_IC ! IC file name
   
   integer(int64) :: t_start, t_end, rate ! Simulation time

   call system_clock(t_start, rate) ! lets start counting time
   
   !!!!!!!!!!!!!!!!
   ! READING SETUP
   !!!!!!!!!!!!!!!!
   
   if (command_argument_count() /= 1) then
      print "(a)", "Usage: ./ex1 <input file>"
      stop 1
   end if
   
   call get_command_argument(1, name_IC)
   
   
   particles = input(name_IC, N, dt, snap_step,total_time) ! FUNCTION IN MODULE INSIDE read_input.f90
   sim_time = 0.0_real64 ! set simulation time as 0.0 s
   ! Particles is an array of particle3d type, defined in module particle.f90
   ! this is allocated in input function which read the file.

   n_steps = int( total_time / dt ) ! become the real time into an integer

   ! Allocate acceleration
   allocate(a(N))
   
   !!!!!!!!!!!!!!!!!!!!
   ! LEAPFROG ALGORITHM
   !!!!!!!!!!!!!!!!!!!!
   
   ! 1- Calculate initial accelerations.
   !$omp parallel do
   do ident = 1, N ! loop for each particle.
      
      ! Function in gravitational_acceleration.f90
      a(ident) = acceleration(particles, ident) ! aceleración inicial
      
   end do
   !$omp end parallel do
   ! Opening the file in which data is saved: If it doesn't exist it is generated!
   open(newunit=unit, file="results.dat", status="replace", action="write")
   
   ! 2- Main loops

   ! First loop, over time
   do step = 1, n_steps
   
      ! save actual simulation time and positions in one line inside results.dat
      
      if (dt * step > sim_time) then
         write (unit , *) dt * step - dt, particles(1:N)%p ! Save results
         sim_time = sim_time + snap_step ! actualize time
         ! when saving time, the "dt* step- dt" it's because we are 
         ! saving it before the time step is done.
      end if
      
      ! Second loop, over particles. divided in three to avoid parallelization issues
      !$omp parallel do
      do ident = 1, N       ! Parallelization have to be done in the particles loops, not in time!
         particles(ident)%v = particles(ident)%v + a(ident) * dt / 2.0_real64
         particles(ident)%p = particles(ident)%p + particles(ident)%v * dt
      end do
      !$omp end parallel do
      !$omp parallel do
      do ident = 1,N
         a(ident) = acceleration(particles, ident) ! in gravitational_acceleration.f90
      end do
      !$omp end parallel do
      !$omp parallel do
      do ident = 1,N
         particles(ident)%v = particles(ident)%v + a(ident) * dt / 2.0_real64
      end do
      !$omp end parallel do

      ! end of parallel zone
      
   end do
   
   close(unit) ! close save file
   
   call system_clock(t_end)
   total_simulated = real(t_end - t_start, real64) / real(rate, real64)
   print *, "Time spent: ", total_simulated, "seconds "
end program ex1

