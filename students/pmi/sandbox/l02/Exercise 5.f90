program Kepler_eq
implicit none

real :: M, ecc, E, E_prev
integer :: caso, counter
logical :: converged

write(*,*) 'Which case do you want? Write:'
write(*,*) '1 for M = 1.0, e = 0.5'
write(*,*) '2 for M = 1.0, e = 0.9'
write(*,*) '3 for giving your own input'
read(*,*) caso

select case(caso)

  case(1)
    M = 1.0
    ecc = 0.5

  case(2)
    M = 1.0
    ecc = 0.9
    
  case(3)
    write(*,*) 'Write your anomaly M:'
    read(*,*) M
    
    write(*,*) 'Write your eccentricity e:'
    read(*,*) ecc
    
  case default
    stop 'Not a valid entry'

end select

E_prev = M + 0.0
E = M+1
counter = 0

do while (abs(E-E_prev) > 1e-6)
  counter = counter + 1
  E_prev = E
  
  E = E_prev - (E_prev - ecc * sin(E_prev) - M) / (1 - ecc * cos(E_prev))

  if(counter >= 50) then
    print*, 'Forcefuly ending the loop after 50 iterations'
    exit
  end if
end do

converged = (abs(E-E_prev) < 1e-6)
if (.not.converged) print*, 'Algorithm did not converge in 50 iterations'
print*, 'Found E =',E, 'after', counter, 'iterations'

end program
