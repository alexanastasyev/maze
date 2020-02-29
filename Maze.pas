﻿{
  TODO:
 
    - User maze input
    - Saving mazes into files
    - Menu
    - "Game finished" window
    - High scores table
    - Maze solver
}

Program Maze;

Uses
  GraphABC;
Uses
  System;
  
Const
  width = 820; // width of the window
  height = 620; // height of the window
  cell_size = 40; // size of one square cell
  player_size = 20; // size of square player
  indent = 10; // maze borders from window borders | player from cell borders
  line_size = 3; // width of all lines
  maze_color = clBlue; // color of the maze
  track_color = clYellow; // color of the track

Type
  arr = array[1..10000] of integer;

// Set player to position with x,y - top left cornner  
Procedure SetPlayer(x: integer; y: integer);
Var
  current_pen_color: Color;
  current_width: integer;
  current_brush_color: Color;
  
Begin
  
  // Remember current settings
  current_pen_color:= PenColor;
  current_width:= PenWidth;
  current_brush_color:= BrushColor;
  
  // Draw rectangle
  MoveTo(x, y);
  SetPenColor(clRed);
  SetPenWidth(line_size);
  DrawRectangle(x,y, x+player_size,y+player_size);
  MoveTo(x,y);
  
  // Fill rectangle
  SetBrushColor(clRed);
  FillRectangle(x,y, x+player_size,y+player_size);
  
  // Get settings back
  SetPenColor(current_pen_color);
  SetPenWidth(current_width);
  SetBrushColor(current_brush_color);
  
  MoveTo(x,y);
  
end; // SetPlayer

// Deletes player from the position with x,y - top left corner
Procedure DeletePlayer(x: integer; y: integer);
Var
  current_pen_color: Color;
  current_width: integer;
  current_brush_color: Color;
  
Begin
  
  // Remember current settings
  current_pen_color:= PenColor;
  current_width:= PenWidth;
  current_brush_color:= BrushColor;
  
  // Draw rectangle
  MoveTo(x, y);
  SetPenColor(clWhite);
  SetPenWidth(line_size);
  DrawRectangle(x,y, x+player_size,y+player_size);
  
  // Fill rectangle
  SetBrushColor(clWhite);
  FillRectangle(x,y, x+player_size,y+player_size);
  
  // Get settings back
  MoveTo(x,y);
  SetPenColor(current_pen_color);
  SetPenWidth(current_width);
  SetBrushColor(current_brush_color);
  
end; // DeletePlayer

// Function for checking if a move is possible
Function CheckMove(current_x: integer; current_y: integer; target_x: integer; target_y: integer): boolean;
begin
    CheckMove:= true;
    
    // Check if move left
    if (current_y = target_y) and ((current_x - target_x)= cell_size)
    then
      if (GetPixel(indent+1, indent+1) = GetPixel(target_x+player_size+indent+1, target_y))
      then
        CheckMove:= false;
      
    // Check if move right
    if (current_y = target_y) and ((current_x - target_x) = -cell_size)
    then
      if (GetPixel(indent+1, indent+1) = GetPixel(target_x-indent-1, target_y))
      then
        CheckMove:= false;    
      
    // Check if move up
    if ((current_y - target_y) = cell_size) and (current_x = target_x)
    then
      if (GetPixel(indent+1, indent+1) = GetPixel(target_x, target_y+player_size+indent+1))
      then
        CheckMove:= false;    
      
    // Check if move down
    if ((current_y - target_y) = -cell_size) and (current_x = target_x)
    then
      if (GetPixel(indent+1, indent+1) = GetPixel(target_x, target_y-indent-1))
      then
        CheckMove:= false;    
  
end; // CheckMove

// Check if a move doesn`t cross track
Function CheckDirection(current_x: integer; current_y: integer; target_x: integer; target_y: integer): boolean;
begin
  
    SetPixel(1,1, track_color);
    CheckDirection:= false;
    
    if ((target_x >= width) or (target_y >= height) or (target_x <= 0) or (target_y <= 0))
    then
      CheckDirection:= false
    else
    begin
    
    // Check if move left
    if (current_y = target_y) and (current_x > target_x)
    then
      if (GetPixel(1, 1) <> GetPixel(target_x+1, target_y))
      then
        CheckDirection:= true;
      
    // Check if move right
    if (current_y = target_y) and (current_x < target_x)
    then
      if (GetPixel(1, 1) <> GetPixel(target_x+1, target_y))
      then
        CheckDirection:= true;    
      
    // Check if move up
    if (current_y > target_y) and (current_x = target_x)
    then
      if (GetPixel(1, 1) <> GetPixel(target_x, target_y+1))
      then
        CheckDirection:= true;    
      
    // Check if move down
    if (current_y < target_y) and (current_x = target_x)
    then
      if (GetPixel(1, 1) <> GetPixel(target_x, target_y+1))
      then
        CheckDirection:= true;    
   end; // else
    
end; // CheckDirection

// Draw player track
Procedure DrawTrack(current_x: integer; current_y: integer; target_x: integer; target_y: integer);
Var
  current_pen_color: Color;
  current_width: integer;
  current_brush_color: Color;
  
Begin
  
  // Remember settings
  current_pen_color:= PenColor;
  current_width:= PenWidth;
  current_brush_color:= BrushColor;
  
  // Draw rectangle
  MoveTo(current_x, current_y);
  SetPenColor(track_color);
  SetPenWidth(line_size);
  DrawRectangle(current_x,current_y, current_x+player_size,current_y+player_size);
  MoveTo(current_x,current_y);
  
  // Fill rectangle
  SetBrushColor(track_color);
  FillRectangle(current_x,current_y, current_x+player_size,current_y+player_size);
  
  // Draw line
  SetPenColor(track_color);
  SetPenWidth(player_size+line_size-1);
  MoveTo(round(current_x+(player_size/2)), round(current_y+(player_size/2)));
  LineTo(round(target_x+(player_size/2)), round(target_y+(player_size/2)));
  
  // Get settings back
  MoveTo(current_x, current_y);
  SetPenColor(current_pen_color);
  SetPenWidth(current_width);
  SetBrushColor(current_brush_color);
  
end; // DrawTrack

// Make right move
Procedure MoveRight(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x+cell_size,y);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x+cell_size,y);
    SetPlayer(x+cell_size, y);
  end;
  
end; // MoveRight

// Make left move
Procedure MoveLeft(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x-cell_size,y);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x-cell_size,y);
    SetPlayer(x-cell_size, y);
  end;
  
end; // MoveLeft

// Make up move
Procedure MoveUp(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x,y-cell_size);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x,y-cell_size);
    SetPlayer(x, y-cell_size);
  end;
  
end; // MoveUp

// Make down move
Procedure MoveDown(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x,y+cell_size);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x,y+cell_size);
    SetPlayer(x, y+cell_size);
  end;
  
end; // MoveDown

// Make move
procedure MakeMove(key: integer);  
begin
   
   case key of
     
     VK_Left:
        MoveLeft(PenX, PenY);
       
     VK_Right:
        MoveRight(PenX, PenY);
       
     VK_Up:
        MoveUp(PenX, PenY);
       
     VK_Down:
        MoveDown(PenX, PenY);
     
   end;
   
end; // KeyDown


// ---------STACK SUBPROGRAMS BLOCK--------//

{
  Realization of stack in Pascal:
  
  - Procedure "push" pushes element c in array a with current number of elements equal to size
  - Procedure "pop" removes the last element from the top of array a with current number of elements equal to size
  - Function "top" returns the last elements of array a with current number of elements equal to size
}

Procedure push(c :integer; var a: arr; var size: integer);
begin
  size := size + 1;
  a[size] := c; 
end;  
 
procedure pop(var a: arr; var size: integer);
begin
  size := size - 1;
end;

function top(a: arr; size: integer) : integer;
begin
  top := a[size];
end;


// ---------END OF STACK SUBPROGRAMS BLOCK--------//


// Generate maze inside
procedure GenerateMaze();

Label
  point1;
Label
  point2;
  
Var
  i,j: integer; // for loop
  direction: integer; // random direction choose variable
  visited: integer; // visited cells counter
  total_cells: integer; // total amount of cells
  
  stackX: arr; // stack of x coordinates
  stackY: arr; // stack of y coordinates
  
  sizeX: integer; // size of stackX
  sizeY: integer; // size of stackY

begin

  
  total_cells:= round((width-2*indent)/cell_size)*round((height-2*indent)/cell_size);
  
  // Set pen settings
  SetPenColor(maze_color);
  SetPenWidth(line_size);
  
  // Draw border
  MoveTo(indent, indent);
  LineTo(indent, height-indent);
  LineTo(width-indent, height-indent);
  LineTo(width-indent, indent);
  LineTo(indent, indent);
  MoveTo(2*indent, 2*indent);
  
  SetPlayer(PenX, PenY);
  
  sizeX:= 0;
  sizeY:= 0;
  
  push(PenX, stackX, sizeX);
  push(PenY, stackY, sizeY);
  
  visited:= 1;
  
  while (visited < total_cells) do
  begin
    
    point1:
    // Check if there is a free neighboor
    while  (((CheckDirection(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX+cell_size,PenY) = true)) 
         or ((CheckDirection(PenX,PenY, PenX-cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX-cell_size,PenY) = true)) 
         or ((CheckDirection(PenX,PenY, PenX,PenY-cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY-cell_size) = true)) 
         or ((CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY+cell_size) = true))) 
    do
    begin
    
      randomize;
      direction:= PABCSystem.random(4) + 1;
      
      case direction of
        
        1: // Right
          begin
            
            if ((CheckDirection(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX+cell_size,PenY) = true))
            then
            begin
              
              MoveRight(PenX, PenY);
              visited:= visited+1;
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY);

            end;
            
          end;
          
        2: // Left
          begin
            
            if ((CheckDirection(PenX,PenY, PenX-cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX-cell_size,PenY) = true))
            then
            begin
              MoveLeft(PenX, PenY);
              visited:= visited+1;
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY);
              
            end;
            
          end;
          
          
        3: // Up
          begin
            
            if ((CheckDirection(PenX,PenY, PenX,PenY-cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY-cell_size) = true))
            then
            begin
              MoveUp(PenX, PenY);
              visited:= visited+1;
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY);
              
            end;
            
          end;
          
        4: // Down
          begin
            
            if ((CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true))
            then
            begin
              MoveDown(PenX, PenY);
              visited:= visited+1;
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY); 
              
            end;
            
          end;
        
      end; // case
      
    end; // while

      if (visited < total_cells)
      then
      begin
        // If there is no a free neighboor then hard go to previous cell and repeat the condition
        DeletePlayer(top(StackX,sizeX), top(StackY, sizeY));
        
        SetPenColor(track_color);
        SetPenWidth(line_size);
        DrawRectangle(top(StackX,sizeX),top(StackY, sizeY), top(StackX,sizeX)+player_size,top(StackY, sizeY)+player_size);
        SetBrushColor(track_color);
        FillRectangle(top(StackX,sizeX),top(StackY, sizeY), top(StackX,sizeX)+player_size,top(StackY, sizeY)+player_size);
        SetPenColor(maze_color);
        
        pop(stackX, sizeX);
        pop(stackY, sizeY);
  
        MoveTo(top(StackX,sizeX), top(StackY, sizeY));      
        
        SetPlayer(top(StackX,sizeX), top(StackY, sizeY));
        
        goto point1;
      end; // if

      
  end; // while
  
  DeletePlayer(PenX, PenY);
  
  i:= indent + cell_size;
  
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      
      if (CheckDirection(i,j, i,j+round(cell_size/2)) = true)
      then
      begin
        MoveTo(i,j);
        LineTo(i,j+cell_size+1);
        MoveTo(i,j);
      end;
      
      if (CheckDirection(i,j, i+round(cell_size/2),j) = true)
      then
      begin
        MoveTo(i,j);
        LineTo(i+cell_size+1,j);
        MoveTo(i,j);
      end;
      
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
  
  // Draw finish
  MoveTo(width-indent, height-indent);
  SetPenColor(clWhite);
  SetPenWidth(line_size);
  LineTo(width-indent, height-cell_size-indent);
  SetPenColor(maze_color);
  SetPenWidth(line_size);

  // Draw blue lines everywhere where possible
  for i:= 1 to width do
    for j:=1 to height do
      if GetPixel(i,j) <> GetPixel(indent+1, indent+1)
      then
        SetPixel(i,j, clWhite);
  
end; // GenerateMaze
  
Var // Maze  
  finish_x: integer; // finish X coordinate
  finish_y: integer; // finish Y coordinate
  
  check_win: boolean; // variable for checking win position
  
  time_start: DateTime; // start game time
  time_finish: DateTime; // end game time
  
  
Begin
 
  // Set coordinates of the finish cell
  finish_x:= width;
  finish_y:= height-indent-indent-player_size;
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width);
  CenterWindow;  
  
  GenerateMaze();
  
  // Set start position
  MoveTo(2*indent, 2*indent);
  SetPlayer(PenX, PenY);
  
  time_start:= DateTime.Now;
  
  // Making moves
  while (not check_win) do
  begin
    
    // Make a move
    OnKeyDown:= MakeMove;
    
    // Check for win
    check_win:= (PenX = finish_x) and (PenY = finish_y); 
    
  end;    
  
  time_finish:= DateTime.Now;
  writeln('Win in ', time_finish-time_start);

End.