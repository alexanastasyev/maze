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
  SetPenColor(current_pen_color);
  SetPenWidth(current_width);
  SetBrushColor(current_brush_color);
  
end; // DeletePlayer

// Function for checking if a move is possible
Function CheckMove(current_x: integer; current_y: integer; target_x: integer; target_y: integer): boolean;
begin
 { 
  CheckMove:= false;
  
  // Check if target cell is neighboor
  if (((abs(current_x-target_x) = cell_size) and (current_y = target_y)) or ((abs(current_y-target_y) = cell_size) and (current_x = target_x))) // and ((GetPixel(indent+1, indent+1) = GetPixel(target_x-indent-1, target_y-indent-1)))
  then
  begin
  }  
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
    
//  end; // if
  

  
end; // CheckMove

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
    DeletePlayer(PenX,PenY);
    SetPlayer(PenX, PenY-cell_size);
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
    DeletePlayer(PenX,PenY);
    SetPlayer(PenX, PenY+cell_size);
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



procedure GenerateMaze();
Var
//  i,j: integer; // for loop
  direction: integer; // random direction choose variable
  visited: integer; // visited cells counter
  total_cells: integer; // total amount of cells
  
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
  
  visited:= 1;
  
  
  while (visited < total_cells) do
  begin
    randomize;
    direction:= PABCSystem.random(4) + 1;

    case direction of
      
      1: // Right
        begin
          
          if (CheckMove(PenX,PenY, PenX+cell_size,PenY) = true)
          then
          begin
            MoveRight(PenX, PenY);
            visited:= visited+1;
          end;
          
        end;
        
      2: // Left
        begin
          
          if (CheckMove(PenX,PenY, PenX-cell_size,PenY) = true)
          then
          begin
            MoveLeft(PenX, PenY);
            visited:= visited+1;
          end;
          
        end;
        
        
      3: // Up
        begin
          
          if (CheckMove(PenX,PenY, PenX,PenY-cell_size) = true)
          then
          begin
            MoveUp(PenX, PenY);
            visited:= visited+1;
          end;
          
        end;
        
      4: // Down
        begin
          
          if (CheckMove(PenX,PenY, PenX,PenY+cell_size) = true)
          then
          begin
            MoveDown(PenX, PenY);
            visited:= visited+1;
          end;
          
        end;
      
    end; // case
    
  end; // while
  
  DeletePlayer(PenX, PenY);
  
  MoveTo(width-indent, height-indent);
  SetPenColor(clWhite);
  SetPenWidth(line_size);
  LineTo(width-indent, height-cell_size-indent);
  SetPenColor(maze_color);
  SetPenWidth(line_size);

  
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
  
  // Set pen settings
  SetPenColor(maze_color);
  SetPenWidth(line_size);  
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width);
  CenterWindow;  
  
  GenerateMaze();


// DON`T DELETE !!! This is a playing part of program. Uncomment when generation is done.
  
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
  writeln('Win in ', time_finish-time_start, ' seconds!');

  
End.