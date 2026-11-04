program parallel_loop
  !$ use omp_lib
  implicit none
  integer, parameter :: n = 8
  real :: a(n)
  integer :: i, id

  !$omp parallel private(i, id) shared(a)
  id = 0
  !$ id = omp_get_thread_num()
  !$omp do
  do i = 1, n
    a(i) = i**2 + 3.0
    print '(a, i0, a, i0)', 'i = ', i, ' on thread ', id
  end do
  !$omp end do
  !$omp end parallel
  print '(*(f6.1))', a
end program parallel_loop
