program hello_omp
  implicit none

  print *, 'Before parallel'

  !$omp parallel
  print *, 'Inside parallel'
  !$omp end parallel

  print *, 'After parallel'
end program hello_omp
