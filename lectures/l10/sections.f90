program sections
  !$ use omp_lib
  implicit none
  integer :: id

  !$omp parallel private(id)
  id = 0
  !$ id = omp_get_thread_num()
  !$omp sections
  !$omp section
  print '(a, i0)', 'Section 1 on thread ', id
  !$omp section
  print '(a, i0)', 'Section 2 on thread ', id
  !$omp section
  print '(a, i0)', 'Section 3 on thread ', id
  !$omp end sections
  !$omp end parallel
end program sections
