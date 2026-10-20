module lists
  implicit none
  type :: cell
    integer :: val
    type(cell), pointer :: next => null()
  end type cell
end module lists

program linked_list
  use lists
  implicit none
  type(cell), pointer :: head => null()  ! empty list
  type(cell), pointer :: cur, new, old
  integer :: i

  ! Build 1 -> 2 -> 3 by adding 3, 2, 1 at the front
  do i = 3, 1, -1
    allocate(new)     ! a new cell
    new%val = i
    new%next => head  ! link to the old first cell
    head => new       ! new is now the first cell
  end do

  ! Insert a new cell after the first one
  cur => head
  allocate(new)
  new%val = 5
  new%next => cur%next
  cur%next => new

  ! Walk through the list
  cur => head
  do while (associated(cur))
    print *, cur%val
    cur => cur%next
  end do

  ! Remove the cell after the first one
  cur => head
  old => cur%next
  cur%next => old%next
  deallocate(old)

  ! Free the whole list
  do while (associated(head))
    old => head
    head => head%next
    deallocate(old)
  end do
end program linked_list
