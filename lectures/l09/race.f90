program race
  implicit none
  integer, parameter :: n = 1000000
  integer :: i, total

  total = 0
  !$omp parallel do shared(total)
  do i = 1, n
    total = total + 1
  end do
  !$omp end parallel do
  print '(2(a, i0))', 'total = ', total, ', expected ', n
end program race
