! an example program wich is gona be compiled
program test
  implicit none
  real, parameter :: pi = 3.14159
  real :: mass, radius, rho
  print *, 'Mass (kg) and radius (m)?'
  read *, mass, radius
  rho = mass /(4.0/3.0 * pi *radius**3)
  print *,'Mean density (kg/m^3):', rho
end program test
