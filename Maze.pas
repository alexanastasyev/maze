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

// Make right move
Procedure MoveRight(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= true;
  
  // Checking
  if (GetPixel(indent+1, indent+1) = GetPixel(x+player_size+indent+1, y))
  then
    check_move:= false;
  
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
  
  check_move:= true;
  
  // Checking
  if (GetPixel(indent+1, indent+1) = GetPixel(x-indent-1, y))
  then
    check_move:= false;
  
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
  
  check_move:= true;
  
  // Checking
  if (GetPixel(indent+1, indent+1) = GetPixel(x, y-indent-1))
  then
    check_move:= false;
  
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
  
  check_move:= true;
  
  // Checking
  if (GetPixel(indent+1, indent+1) = GetPixel(x, y+indent+player_size+1))
  then
    check_move:= false;
  
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
  
  // Draw border
  MoveTo(indent, indent);
  LineTo(indent, height-indent);
  LineTo(width-indent, height-indent);
  MoveTo(width-indent, height-cell_size-indent);
  LineTo(width-indent, indent);
  LineTo(indent, indent);
  
  {
    // Draw maze
  }
  
  // Set start position
  SetPlayer(2*indent, 2*indent);
  
  time_start:= DateTime.Now;
  
  // Making moves
  while (not check_win) do
  begin
    
    // Make a move
    OnKeyDown:= MakeMove;
    
    // Check for win
    check_win:= (PenX = finish_x) and (PenY = finish_y); 
    if (check_win)
    then
    begin
       time_finish:= DateTime.Now;
       writeln('Win in ', time_finish-time_start, ' seconds!');  
    end;
    
  end;    
  
End.