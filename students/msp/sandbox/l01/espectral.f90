program spectral_classification
  implicit none
  real :: Teff
  real, parameter :: O=30000, B=10000, A=7500,F=6000,G=5200,K=3700,M=2400
  print *, 'Insert Teff of a star in Kelvin:'
  read *, Teff
  if (Teff > O) then
    print *, 'Spectral type: O'
  else if (Teff > B) then
    print *, 'Spectral type: B'
  else if (Teff > A) then
    print *, 'Spectral type: A'
  else if (Teff > F) then
    print *, 'Spectral type: F'
  else if (Teff > G) then
    print *, 'Spectral type: G'
  else if (Teff > K) then
    print *, 'Spectral type: K'
  else if (Teff > M) then
    print *, 'Spectral type: M'
  else
    print *, 'Thats too cold to be a star!'
  end if
end program spectral_classification
