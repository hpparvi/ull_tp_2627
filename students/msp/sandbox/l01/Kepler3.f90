program Kepler3
  implicit none
  real :: semimajor, Mstar, period ! semi-major axis in AU and the stellar mass in solar masses
  real, parameter :: year = 365.25 ! days in a year
  print *, ' semimajor (AU) axis and stellar mass (M_sun)'
  read *, semimajor, Mstar
  period = (semimajor ** 3 / Mstar) ** (1.0 / 2.0) * year ! in day
  print *, 'the period is ', period, ' days.'
end program Kepler3
  
