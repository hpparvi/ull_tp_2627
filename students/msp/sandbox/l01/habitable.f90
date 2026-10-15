program habitable
  implicit none
  real :: L, semimajor, eccentricity, rin,rout, peri, apo ! Luminosity in solar L and semimajor un AU
  print *, "set the luminosity of the star in Solar luminosities, the semimajor in AU and the eccentricity"
  read *, L, semimajor, eccentricity
  rin  = (L/1.1) ** (0.5)
  rout = (L/0.53) ** (0.5)
  peri = semimajor * (1 - eccentricity)
  apo  = semimajor * (1 + eccentricity)
  if (rout<peri) then
    print *, 'too cold'
  else if (rin>apo) then
    print *, 'too hot'
  else if (rout>apo .and. rin<peri) then
    print *, 'Perfect! it is always inside habitable zone'
  else
    print *, 'Partly'
  end if
  !print *, 'rin', rin, 'rout',rout, 'peri',peri, 'apo', apo
end program habitable
  
