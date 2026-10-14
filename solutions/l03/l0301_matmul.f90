! Lecture 3 exercise 1: Matrix multiplication
!
! Computes the product C = AB of a 3x4 matrix A and a 4x3 matrix B in
! four ways, and checks that the results agree:
!
!   1. three nested loops, one multiplication at a time,
!   2. a loop over the elements of C, with array slices for the sum,
!   3. the same loop, with the dot_product intrinsic, and
!   4. the matmul intrinsic.
!
! The matrices are written row by row in the source, as on the slide, but
! reshape fills an array in column-major order. Reshaping the values into
! the transposed shape and then transposing gives the intended matrix.
!
! C(i,j) is the dot product of row i of A and column j of B. The inner
! extents must agree (4 here), and C has the shape [3, 3].
program l0301_matmul
  implicit none
  real :: a(3,4), b(4,3)
  real :: c_loops(3,3), c_slices(3,3), c_dot(3,3), c_matmul(3,3)
  integer :: i, j, k

  a = transpose(reshape([3., 2., 4., 1., &
                         2., 4., 2., 2., &
                         1., 2., 3., 7.], [4, 3]))
  b = transpose(reshape([3., 2., 4., &
                         2., 4., 2., &
                         1., 2., 3., &
                         0., 2., 1.], [3, 4]))

  ! 1. Nested loops. The innermost loop runs over i, the first index of
  ! c_loops and a, so that consecutive iterations access neighbouring
  ! elements in memory.
  c_loops = 0.0
  do j = 1, size(c_loops, 2)
    do k = 1, size(a, 2)
      do i = 1, size(c_loops, 1)
        c_loops(i,j) = c_loops(i,j) + a(i,k) * b(k,j)
      end do
    end do
  end do

  ! 2. Array slices. a(i,:) is row i of A and b(:,j) is column j of B,
  ! both with four elements. Their elementwise product summed is the dot
  ! product, which replaces the loop over k.
  do j = 1, size(c_slices, 2)
    do i = 1, size(c_slices, 1)
      c_slices(i,j) = sum(a(i,:) * b(:,j))
    end do
  end do

  ! 3. dot_product. The same as method 2, with the intrinsic doing the
  ! multiplication and the sum.
  do j = 1, size(c_dot, 2)
    do i = 1, size(c_dot, 1)
      c_dot(i,j) = dot_product(a(i,:), b(:,j))
    end do
  end do

  ! 4. The intrinsic, which is the clearest and usually the fastest.
  c_matmul = matmul(a, b)

  print *, 'C = AB:'
  do i = 1, size(c_matmul, 1)
    print '(3f8.1)', c_matmul(i,:)
  end do

  if (all(c_loops == c_matmul) .and. all(c_slices == c_matmul) &
      .and. all(c_dot == c_matmul)) then
    print *, 'All four methods agree.'
  else
    print *, 'The methods give different results!'
  end if
end program l0301_matmul
