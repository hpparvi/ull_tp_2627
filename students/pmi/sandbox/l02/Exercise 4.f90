program Wien_Law

implicit none

character :: cuality
real :: landa, b_real
integer :: b_int, i, T ! If T was real, b being an integer does not change anything, since RealxInteger gives a real in fortran

write(*,*) 'Use b as integer or real? (write I or R)'
write(*,*) 'You can write C for comparing both results (this will show Delta_lambda \equiv lambda_real - lambda_int)'
read(*,*) cuality



if ((cuality == 'R').or.(cuality == 'r')) then
  b_real = 2.897772e6
  print*, '       T(K)   |     lambda(nm)'
  print*, '    ----------------------------'
  do i = 1,10
    T = 3000 * i
    landa = b_real / T
    print*, T, '  |  ', landa, '              '
  end do
  print*, ''
  print*, 'Loop variable right now is: i =', i
  print*, ''
  print*, '         Now reverse'
  print*, '         -----------'
  print*, ''
  
  print*, '       T(K)   |     lambda(nm)'
  print*, '    ----------------------------'
  do i = 10,1, -1
    T = 3000 * i
    landa = b_real / T
    print*, T, '  |  ', landa, '              '
  end do
  print*, ''
  print*, 'Loop variable right now is: i =', i
  
elseif ((cuality == 'I').or.(cuality == 'i')) then
  b_int = 2897772
print*, '       T(K)   |     lambda(nm)'
  print*, '    ----------------------------'
  do i = 1,10
    T = 3000 * i
    landa = b_int / T
    print*, T, '  |  ', landa, '              '
  end do
  print*, ''
  print*, 'Loop variable right now is: i =', i
  print*, ''
  print*, '         Now reverse'
  print*, '         -----------'
  print*, ''
  
  print*, '       T(K)   |     lambda(nm)'
  print*, '    ----------------------------'
  do i = 10,1, -1
    T = 3000 * i
    landa = b_int / T
    print*, T, '  |  ', landa, '              '
  end do
  print*, ''
  print*, 'Loop variable right now is: i =', i
  
elseif ((cuality == 'C').or.(cuality == 'c')) then
  print*, '       T(K)   |   Delta lambda(nm)'
  print*, '    ------------------------------'
  b_real = 2.897772e6
  b_int = 2897772
  do i = 1,10
    T = 3000 * i
    landa = b_real / T
    print*, T, '  |  ', b_real / T - b_int / T
  end do
  print*, ''
  print*, 'Loop variable right now is: i =', i
  print*, ''
  print*, '         Now reverse'
  print*, '         -----------'
  print*, ''
  
  print*, '       T(K)   |   Delta lambda(nm)'
  print*, '    ------------------------------'
  do i = 10,1, -1
    T = 3000 * i
    landa = b_real / T
    print*, T, '  |  ', b_real / T - b_int / T
  end do
  print*, ''
  print*, 'Loop variable right now is: i =', i
else
  stop 'Non valid input'
end if
  

end program
