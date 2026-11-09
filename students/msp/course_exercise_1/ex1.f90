! Work in progress
! in which we extract the initial conditions from "sphere.txt" and use them to
! run a simulation employing the leapfrog algorithm.

program ex1
   ! THERE IS NO MAKEFILE AT THIS TIME. TO COMPILE IT, USE NEXT LINE IN TERMINAL:
   ! gfortran geometry.f90 particle.f90 gravitational_acceleration.f90 read_input.f90 ex1.f90 -o ex1
   
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
   ! CREATING EACH VARIABLE USED FORWARD
   !!!!!!!!!!!!!!!!!

   integer :: N, ident,n_steps, step, unit ! Loops integer and ios
   type(vector3d), allocatable :: a(:)   ! accelerations
   real(real64) :: dt, snap_step, total_time, sim_time, total_simulated ! time step
   type(particle3d), allocatable :: particles(:) ! allocatable particles
   character(len=100) :: name_IC ! IC file name
   
   integer(int64) :: t_start, t_end, rate

   call system_clock(t_start, rate) ! lets start
   !!!!!!!!!!!!!!!!
   ! READING SETUP
   !!!!!!!!!!!!!!!!
   
   if (command_argument_count() /= 1) then
      print "(a)", "Usage: ./args <input file>"
      stop 1
   end if
   
   call get_command_argument(1, name_IC)
   
   
   particles = input(name_IC, N, dt, snap_step,total_time) ! FUNCTION IN MODULE INSIDE read_input.f90
   sim_time = 0.0_real64
   ! Particles are an array of particle3d type, defined in module particle.f90
   ! this is allocated in input function which read the file.

   n_steps = int( total_time / dt ) ! become the real into an integer
   ! print *, particles(:)%p
   ! Allocate acceleration
   allocate(a(N))
   
   !!!!!!!!!!!!!!!!!!!!
   ! LEAPFROG ALGORITHM
   !!!!!!!!!!!!!!!!!!!!
   
   ! 1- Calculate initial accelerations.
   
   do ident = 1, N ! loop for each particle.
      
      ! Function in gravitational_acceleration.f90
      a(ident) = acceleration(particles, ident) ! aceleración inicial
      
   end do
   
   ! Opening the file in which data is saved: If it doesn't exist it is generated!
   open(newunit=unit, file="results.txt", status="replace", action="write")
   
   ! write (unit , *) 0.0_real64, particles(1:N)%p ! save state at t = 0
   ! 2- Main loops

   ! First loop, over time
   do step = 1, n_steps
   
      ! Second loop, over particles.
      !$omp parallel do
      do ident = 1, N       ! Parallelitation have to be done in the particles loops, not in time!
      
         particles(ident)%v = particles(ident)%v + a(ident) * dt / 2.0_real64
         particles(ident)%p = particles(ident)%p + particles(ident)%v * dt
         a(ident) = acceleration(particles, ident) ! in gravitational_acceleration.f90
         particles(ident)%v = particles(ident)%v + a(ident) * dt / 2.0_real64
         
      end do
      !$omp end parallel do

      ! end of parallel zone
      
      ! save actual simulation time and positions in one line inside results.txt
      
      if (dt * step > sim_time) then
         write (unit , *) dt* step, particles(1:N)%p ! Save results
         sim_time = sim_time + snap_step ! actualize time
      end if
   end do
   
   close(unit) ! close save file
   
   call system_clock(t_end)
   total_simulated = real(t_end - t_start, real64) / real(rate, real64)
   print *, "Time spend: ", total_simulated, "seconds "
end program ex1

