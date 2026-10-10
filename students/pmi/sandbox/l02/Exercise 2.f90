program spectral_class

integer :: T_eff
character :: clase

write(*,*) 'Tell me the effective temperature of your star'
read(*,*) T_eff


select case(T_eff)

  case(30000:)
    clase = 'O'
    
  case(10000:29999)
    clase = 'B'
    
  case(7500:9999)
    clase = 'A'
    
  case(6000:7499)
    clase = 'F'
    
  case(5200:5999)
    clase = 'G'
    
  case(3700:5199)
    clase = 'K'
    
  case(2400:3699)
    clase = 'M'
    
  case(:2399)
    stop 'Temperature not on the sequence'
    
end select
print*, 'The star is class-'//clase

end program spectral_class
