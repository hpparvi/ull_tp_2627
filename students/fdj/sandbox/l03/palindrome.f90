program palindrome

integer :: number, front, back, div    ! 4321234
print *, "Enter a number and I will tell whether it is a palindrome."
read *, number

do while (number/10 /= 0)
    div = 10
    back = mod(number,div)

    print *, "back = ", back

    do while (number/div /= 0)       
        front = number/div          
        div=div*10
        print *, front, div
    end do

    if (back /= front) then
        print *, "Not a palindrome"
        stop
    end if

    number = (number - div/10*front - back)/10 ! First time: number = 32123
    print *, number


end do

print *, "It is a palindrome."
end program palindrome