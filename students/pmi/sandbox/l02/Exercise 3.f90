program Habitable

implicit none
real :: L, a, e, r_in, r_out, peri, apo
logical :: lower, upper, low_in, up_in

write(*,*) 'Write lumminosity L (in solar units), semi-major axis a (in AU), and eccentricity e, like: L, a, e'
read(*,*) L, a, e
if (abs(e)>=1) stop '0<e<1 only'
if (e<0) stop 'only e>0'

r_in = sqrt(L/1.1)
r_out = sqrt(L/0.53)
peri = a*(1-e)
apo = a*(1+e)

! If 1 true, partly, if both true, completely
lower = peri > r_in
upper = apo < r_out

up_in = (apo < r_out) .and. (apo > r_in)
low_in = (peri < r_out) .and. (peri > r_in)

if (lower .and. upper) print*, 'Always'
if (low_in .neqv. up_in) print*, 'Partly'
if ((.not.(lower)) .and. (.not.(upper))) print*, 'Partly'
if ((peri < r_in) .and. (apo < r_in)) print*, 'Never: too hot'
if ((peri > r_out) .and. (apo > r_out)) print*, 'Never: too cold'

end program
