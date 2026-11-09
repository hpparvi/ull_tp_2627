program ex3c
use iso_c_binding, only: c_float, c_double
implicit none
real(c_float) :: x
real(c_double) :: y
print *, tiny(x), huge(x)
print *, tiny(y), huge(y)
end program ex3c