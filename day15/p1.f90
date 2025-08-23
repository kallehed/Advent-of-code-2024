program hello
  implicit none
  ! This is a comment line; it is ignored by the compiler
  character :: c
  ! 2d array 100x100
  character :: world(0:99, 0:99)
  character(len=1000) :: the_input
  integer :: length, world_width, world_height
  integer :: i
  integer :: j
  integer :: pX 
  integer :: pY
  character :: dir
  integer :: dirX, dirY
  integer :: posX, posY, total

  world(:, :) = ' '
  i = 0
  leloop: do while (1==1)
    read (*, *) the_input
    print *, the_input, "len:", len_trim(the_input)
    length = len_trim(the_input)
    if (the_input(1:1) /= '#') then
      exit
    end if
    world_width = length

    do j = 0, length-1
      world(i, j) = the_input(j+1:j+1)
      ! find the player
      if (the_input(j+1:j+1) == "@") then 
        pX = j
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
      print *, "player pos:", pY, " ", pX
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
        else if (posY > pY) then 
          world(pY+1:posY, pX) = world(pY:posY-1, pX)
        else if (posY < pY) then 
          world(posY:pY-1, Px) = world(posY+1:pY, pX)
        else 
          print *, "[ERROR] WRONGFULL POSITIONING!!!"
        end if
        world(pY, pX) = "."
        pY = pY + dirY 
        pX = pX + dirX
      end if
    end do
    ! get the sum of the boxes and print it
    total = 0 
    do i = 0, world_height-1 
      do j = 0, world_width-1
        if (world(i, j) == 'O') then 
          total = total + 100*i + j
        end if
      end do
    end do
    print *, "TOTAL: ", total

    read (*, *) the_input
    length = len_trim(the_input)
  end do leloop2
end program hello