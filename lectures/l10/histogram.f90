! Counts n random numbers into bins in three ways: with a critical
! section, with an atomic update, and with an array reduction.
program histogram
  use omp_lib
  use iso_fortran_env, only: real64
  implicit none
  integer, parameter :: n = 10000000, n_bins = 10
  real, allocatable :: x(:)
  integer :: counts(n_bins), i, bin
  real(real64) :: t0

  allocate(x(n))
  call random_number(x)

  counts = 0
  t0 = omp_get_wtime()
  !$omp parallel do private(bin) shared(x, counts)
  do i = 1, n
    bin = int(x(i) * n_bins) + 1
    !$omp critical
    counts(bin) = counts(bin) + 1
    !$omp end critical
  end do
  !$omp end parallel do
  print '(a, f6.3, a, i0)', 'critical:  ', omp_get_wtime() - t0, ' s, total ', sum(counts)

  counts = 0
  t0 = omp_get_wtime()
  !$omp parallel do private(bin) shared(x, counts)
  do i = 1, n
    bin = int(x(i) * n_bins) + 1
    !$omp atomic
    counts(bin) = counts(bin) + 1
  end do
  !$omp end parallel do
  print '(a, f6.3, a, i0)', 'atomic:    ', omp_get_wtime() - t0, ' s, total ', sum(counts)

  counts = 0
  t0 = omp_get_wtime()
  !$omp parallel do private(bin) shared(x) reduction(+:counts)
  do i = 1, n
    bin = int(x(i) * n_bins) + 1
    counts(bin) = counts(bin) + 1
  end do
  !$omp end parallel do
  print '(a, f6.3, a, i0)', 'reduction: ', omp_get_wtime() - t0, ' s, total ', sum(counts)
end program histogram
