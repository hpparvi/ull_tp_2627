program machine_epsilon
  implicit none
  integer :: tipo
  print *, "what kind of real value do you whant to know the machine epsilon? 32 or 64"
  read *, tipo
  if (tipo == 64) then
    real(real64) :: variable = 1.0_real64 
    real(real64), intent(inout) :: eps = 1.0_real64, iterable = 2.0_real64
    do while (iterable == variable)
      iterable = varieble + eps
      eps = eps/2.0
    print*,  n, " ", nfact   
   end do 
  else if (tipo == 32) then
    real(real32), intent(inout) :: variable = 1.0_real32
    real(real32), intent(inout) :: eps = 1.0_real32
    do while (iterable == variable)
      iterable = varieble + eps
      eps = eps/2.0
    print*,  n, " ", nfact   
  
  else
    stop "That's not an existing format allowed"
  end if
  print *, eps
  
  
end program machine_epsilon
