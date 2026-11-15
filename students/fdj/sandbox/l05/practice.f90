program widths
    implicit none
    real :: r(5) = [0.5, -2.5, 3.25, 10.0, 12345.6]
    print '(i3, "|", i0, "|", f6.1)', 12345, 12345, r(5)
    print '(3f8.2)', r(1:3)
    print '(3(f5.2, ";"))', r(1:3)
    print '(a, *(1x, f0.2))', 'r =', r
    print '(2f4.2)', r
end program widths