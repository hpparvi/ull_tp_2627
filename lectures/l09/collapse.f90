program collapse
  !$ use omp_lib
  implicit none
  real :: a(4,3)
  integer :: i, j, id

  !$omp parallel private(i, j, id) shared(a)
  id = 0
  !$ id = omp_get_thread_num()
  !$omp do collapse(2)
  do j = 1, 3
    do i = 1, 4
      a(i,j) = i + j
      print '(3(a, i0))', '(', i, ',', j, ') on thread ', id
    end do
  end do
  !$omp end do
  !$omp end parallel
end program collapse
