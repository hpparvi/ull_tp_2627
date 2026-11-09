program shift
implicit none
integer :: a(3,4), b(4,3), c(3,3)
a = reshape([3,2,4,1,2,4,2,2,1,2,3,7], [3,4])
b = reshape([3,2,4,2,4,2,1,2,3,0,2,1], [4,3])
c = matmul(a,b)

print *, c
print *, shape(c)

end program shift