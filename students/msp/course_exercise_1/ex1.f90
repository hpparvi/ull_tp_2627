! Work in progress
! in which we extract the initial conditions from "sphere.txt" and use them to
! run a simulation employing the leapfrog algorithm.

program ex1
   ! THERE IS NO MAKEFILE AT THIS TIME. TO COMPILE IT, USE NEXT LINE IN TERMINAL:
   ! gfortran geometry.f90 particle.f90 gravitational_acceleration.f90 read_input.f90 ex1.f90 -o ex1
   
   !!!!!!!!!!!!!!!!
   ! LIBRARIES
   !!!!!!!!!!!!!!!!
   use iso_fortran_env, only: real64, iostat_end
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
   real(real64) :: dt, snap_step, total_time, sim_time ! time step
   type(particle3d), allocatable :: particles(:) ! allocatable particles
   character(len=100) :: name_IC ! IC file name
   
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

   n_steps = INT( total_time / dt ) ! become the real into an integer

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
      do ident = 1, N
      
         particles(ident)%v = particles(ident)%v + a(ident) * dt / 2.0_real64
         particles(ident)%p = particles(ident)%p + particles(ident)%v * dt
         a(ident) = acceleration(particles, ident) ! in gravitational_acceleration.f90
         particles(ident)%v = particles(ident)%v + a(ident) * dt / 2.0_real64
         
      end do
      
      ! save actual simulation time and positions in one line inside results.txt
      if (dt * step > sim_time) then
         write (unit , *) dt* step, particles(1:N)%p ! guardo resultados
         sim_time = sim_time + snap_step
      end if
   end do
   
   close(unit) ! close file

end program ex1

