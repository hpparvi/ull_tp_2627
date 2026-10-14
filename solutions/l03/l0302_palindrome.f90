! Lecture 3 exercise 2: Palindromic integers
!
! Reads an integer and tells whether its digits read the same forwards
! and backwards.
!
! The digits are taken off one at a time with mod(m, 10) and m / 10, and
! stored in an array from the last digit to the first. The number is a
! palindrome if the array equals itself reversed, d(n:1:-1).
!
! Reversing the number itself (rev = 10*rev + mod(m, 10)) would also work,
! but the reversed number can overflow: 1999999999 fits in a default
! integer, but 9999999991 does not. The digit array avoids this. Ten
! digits are enough, because huge(1) = 2147483647.
!
! For a negative number, mod and integer division both keep the sign, so
! every digit is negative and the comparison still works. The sign is
! therefore ignored: -121 counts as a palindrome.
program l0302_palindrome
  implicit none
  integer :: number, m, n, ios
  integer :: d(10)
  character(len=100) :: line

  ! Read the line as text first, so that bad input can be asked for again
  do
    print *, 'Give an integer:'
    read(*, '(a)', iostat=ios) line
    if (ios /= 0) stop 'No input'
    read(line, *, iostat=ios) number
    if (ios == 0) exit
    print *, 'Not an integer, try again.'
  end do

  ! The loop runs at least once, so that 0 gets one digit
  m = number
  n = 0
  do
    n = n + 1
    d(n) = mod(m, 10)
    m = m / 10
    if (m == 0) exit
  end do

  if (all(d(1:n) == d(n:1:-1))) then
    print *, number, 'is a palindrome.'
  else
    print *, number, 'is not a palindrome.'
  end if
end program l0302_palindrome
