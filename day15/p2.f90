program hello
  implicit none
  ! I know, this code kind of sucks...
  character :: c
  character :: world(0:199, 0:199) 
  character(len=1000) :: the_input
  integer :: length, world_width, world_height
  integer :: i
  integer :: j, w
  integer :: pX 
  integer :: pY
  character :: dir
  integer :: dirX, dirY
  integer :: posX, posY, total
  logical :: canMove

  world(:, :) = ' '
  i = 0
  leloop: do while (1==1)
    read (*, *) the_input
    print *, the_input, "len:", len_trim(the_input)
    length = len_trim(the_input)
    if (the_input(1:1) /= '#') then
      exit
    end if
    world_width = length*2

    do j = 0, length-1
      c = the_input(j+1:j+1)
      w = j * 2
      if (c == '.' .or. c == '#') then 
        world(i, w) = c
        world(i, w+1) = c
      else if (c == 'O') then 
        world(i, w) = '['
        world(i, w+1) = ']'
      else if (c == '@') then 
        world(i, w) = '@'
        world(i, w+1) = '.'
      else 
        print *, "[ERROR] BAD INPUT!!"
      end if
      ! find the player
      if (the_input(j+1:j+1) == "@") then 
        pX = j*2
        pY = i
      end if
    end do
    print *, "wrote: ", world(i, 0:length-1)
    i = i + 1
  end do leloop
  world_height = i

  print *, "whole thing: ", world

  print *, "next part"
  print *, "pX: ", pX, "pY:", pY, " world width: ", world_width, " world height: ", world_height

  leloop2: do while (1==1)
    print *, the_input, "len:", len_trim(the_input)
    do j = 0, length-1
      ! iterate over '<v>^' characters
      dir = the_input(j+1:j+1)
      print *, "player pos:", pY, " ", pX, " col: ", world(0:world_height-1, pX), " row: ", world(pY, 0:world_width-1)
      dirX = 0
      dirY = 0
      if (dir == ">") then 
        dirX = 1
      else if (dir == "<") then 
        dirX = -1
      else if (dir == '^') then 
        dirY = -1 
      else if (dir == 'v') then 
        dirY = 1
      else 
        print *, "ERROR!!!"
      end if
      !print *, dir, ", realdir:", dirY, " ", dirX
      ! now iterate in that direction and find a ' ' (space) where we can move stuff. If we find space, we can just move everything there
      if (dirX /= 0) then 
        posX = pX 
        posY = pY
        walk: do while (1==1)
          posX = posX + dirX 
          posY = posY + dirY
          ! if at '#' we cancel
          c = world(posY, posX)
          if (c == '#' .or. c == '.') then 
            exit walk
          end if
        end do walk
        ! if we found the space
        if (c == '.') then 
          if (posX > pX) then 
            world(pY, pX+1:posX) = world(pY, pX:posX-1)
          else if (posX < pX) then 
            world(pY, posX:pX-1) = world(pY, posX+1:pX)
          else 
            print *, "[ERROR] WRONGFULL POSITIONING!!!"
          end if
          world(pY, pX) = "."
          pY = pY + dirY 
          pX = pX + dirX
        end if
      else 
        ! THE Y IS CHANGING!! VERY COMPLICATED STUFF FOLLOWS:
        ! first we recursively check if we can move in our y dir
        ! then we do postorder movement of ourselves y-wards
        canMove = can_move_ywards(pX, pY)
        if (canMove) then 
          call move_ywards(pX, pY)
          pY = pY + dirY
        end if

      end if
    end do
    ! get the sum of the boxes and print it
    total = 0 
    do i = 0, world_height-1 
      do j = 0, world_width-1
        if (world(i, j) == '[') then 
          total = total + 100*i + j
        end if
      end do
    end do
    print *, "TOTAL: ", total

    read (*, *) the_input
    length = len_trim(the_input)
  end do leloop2

  contains  ! closure?? it can access data from the 'main' program... nice (though maybe that data is basically 'global' data...)
    recursive function can_move_ywards(x, y) result(res)
      implicit none 
      integer, intent(in) :: x, y
      integer :: newY
      logical :: res
      character :: above
      newY = y + dirY ! got from program
      above = world(newY, x)
      if (above == '#') then 
        res = .false.
        return
      else if (above == '.') then 
        res = .true.
        return
      else if (above == '[') then 
        res = can_move_ywards(x, newY) .and. can_move_ywards(x+1, newY)
        return
      else if (above == ']') then 
        res = can_move_ywards(x, newY) .and. can_move_ywards(x-1, newY)
        return
      end if
    end function can_move_ywards

    recursive subroutine move_ywards(x, y)
      implicit none
      integer, intent(in) :: x, y
      integer :: newY
      character :: above
      ! postorder move the things
      newY = y + dirY
      ! first do on children 
      above = world(newY, x)
      if (above == '[') then 
        call move_ywards(x, newY)
        call move_ywards(x+1, newY)
      else if (above == ']') then 
        call move_ywards(x, newY)
        call move_ywards(x-1, newY)
      end if
      ! move current char up 
      world(newY, x) = world(y,x)
      world(y, x) = '.'
    end subroutine move_ywards
end program hello