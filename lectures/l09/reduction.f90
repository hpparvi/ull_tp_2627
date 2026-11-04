program reduction
  implicit none
  real :: a(5), b(5), dot
  integer :: i
  a = [0.1, 3.4, 7.4, 1.2, 8.3]
  b = [3.8, 0.1, 1.6, 0.1, 0.3]

  dot = 0.0
  !$omp parallel do reduction(+:dot)
  do i = 1, size(a)
    dot = dot + a(i) * b(i)
  end do
  !$omp end parallel do
  print '(a, f0.3)', 'a . b = ', dot
end program reduction
