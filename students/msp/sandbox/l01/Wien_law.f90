program wien
  real, parameter :: b = 2.897772e6
  real :: T, max_lambda
  print *, "set Temperature for wien's law calculations"
  read *, T
  max_lambda = b/T 
  print *, "the maximun is in ", max_lambda, " nm"
end program wien
 
