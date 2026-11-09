program single
  implicit none
  integer, parameter :: n = 6
  real :: a(n), b(n)
  integer :: i

  !$omp parallel shared(a, b) private(i)
  !$omp do
  do i = 1, n
    a(i) = real(i)
  end do
  !$omp end do

  !$omp single
  a = a - cos(a)
  !$omp end single

  !$omp do
  do i = 1, n
    b(i) = 2 * a(i)
  end do
  !$omp end do
  !$omp end parallel

  print '(*(f7.3))', b
end program single
