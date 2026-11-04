program thread_ids
  use omp_lib
  implicit none
  integer :: n_threads, id

  !$omp parallel private(n_threads, id)
  n_threads = omp_get_num_threads()
  id = omp_get_thread_num()
  print '(a, i0, a, i0)', 'Thread ', id, ' of ', n_threads
  !$omp end parallel
end program thread_ids
