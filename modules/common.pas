﻿Unit common;

Uses
  GraphABC;

Const
  width = 810; // width of the window
  height = 610; // height of the window
  indent = 5; // maze borders from window borders | player from cell borders
  
  cell_size = 20; // size of one square cell
  player_size = 10; // size of square player

  line_size = 3; // width of all lines
  maze_color = clBlue; // color of the maze
  track_color = clYellow; // color of the track
  player_color = clRed; // color of the player
  
  // Coordinates of the finish cell
  finish_x = width;
  finish_y = height-indent-indent-player_size;
  
  //-------buttons` coordinates begin-------//
  
  button_x1 = width + 10;
  button_x2 = width + 180;
  
  
  button1_y1 = round((4/24)*height);
  button1_y2 = round((6/24)*height);
  
  button2_y1 = round((7/24)*height);
  button2_y2 = round((9/24)*height);
  
  button3_y1 = round((10/24)*height);
  button3_y2 = round((12/24)*height);
  
  button4_y1 = round((13/24)*height);
  button4_y2 = round((15/24)*height);
  
  button5_y1 = round((16/24)*height);
  button5_y2 = round((18/24)*height);
  
  button_menu_y1 = round((1/24)*height);
  button_menu_y2 = round((3/24)*height);
  
  button_ok_y1 = round((21/24)*height);
  button_ok_y2 = round((23/24)*height);

  //-------buttons` coordinates end-------//
  
  
Type
  stack = array[1..10000] of integer;

Var
  optimal_solution_moves: integer;
  win_checker: boolean;

// Draws formated button in rectangle with x1,y1-x2,y2 coordinates and text s
Procedure MakeSpecialButton(x1,y1,x2,y2: integer; s: string);
var
  current_pen_color: color;
  current_pen_width: integer;
  current_font_size: integer;
  current_font_color: color;
  
begin
  
  current_pen_color:= PenColor;
  current_pen_width:= PenWidth;
  current_font_size:= FontSize;
  current_font_color:= FontColor;
  
  SetPenWidth(3);
  SetPenColor(clLightBlue);
  SetFontSize(22);
  SetFontColor(clLightBlue);
  
  Rectangle(x1, y1, x2, y2);
  TextOut(x1+2*indent, y1+2*indent, s);
  
  SetPenWidth(current_pen_width);
  SetPenColor(current_pen_color);
  SetFontSize(current_font_size);
  SetFontColor(current_font_color);
  
end;

Procedure MakeDangerButton(x1,y1,x2,y2: integer; s: string);
var
  current_pen_color: color;
  current_pen_width: integer;
  current_font_size: integer;
  current_font_color: color;
  
begin
  
  current_pen_color:= PenColor;
  current_pen_width:= PenWidth;
  current_font_size:= FontSize;
  current_font_color:= FontColor;
  
  SetPenWidth(3);
  SetPenColor(clOrange);
  SetFontSize(22);
  SetFontColor(clOrange);
  
  Rectangle(x1, y1, x2, y2);
  TextOut(x1+2*indent, y1+2*indent, s);
  
  SetPenWidth(current_pen_width);
  SetPenColor(current_pen_color);
  SetFontSize(current_font_size);
  SetFontColor(current_font_color);
  
end;

Procedure Sort();
Var
  f: text;
  i,j: integer;
  
  s: array[1..100] of string;
  st: string;
  amount: integer;
  
Begin
  
  assign(f, 'src/mazes/maze_amount.txt');
  reset(f);
  readln(f, amount);
  close(f);
  
  assign(f, 'src/mazes/maze_list.txt');
  reset(f);
  for i:= 1 to amount do
    readln(f, s[i]);
  
  close(f);
  
  for i:= 1 to (amount - 1) do
    for j:= 1 to (amount - 1) do
      if (s[j] > s[j + 1])
      then
      begin
        st:= s[j];
        s[j]:= s[j + 1];
        s[j + 1]:= st;
      end;
  
  assign(f, 'src/mazes/maze_list.txt');
  rewrite(f);
  for i:= 1 to amount do
    writeln(f, s[i]);
  
  close(f);
  
  
end;  

Procedure DrawFinish();
begin
  // Draw finish
  MoveTo(width-indent, height-indent);
  SetPenColor(clWhite);
  SetPenWidth(line_size);
  LineTo(width-indent, height-cell_size-indent);
  SetPenColor(maze_color);
  SetPenWidth(line_size);
end;

Procedure DrawBorderWalls();
Begin
  
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
  
end; 
  
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
  SetPenColor(player_color);
  SetPenWidth(line_size);
  DrawRectangle(x,y, x+player_size,y+player_size);
  MoveTo(x,y);
  
  // Fill rectangle
  SetBrushColor(player_color);
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

// Check if a move doesn`t cross track
Function CheckDirection(current_x: integer; current_y: integer; target_x: integer; target_y: integer): boolean;
begin
  
    SetPixel(1,1, track_color);
    SetPixel(1,2, clOrange);
    CheckDirection:= false;
    
    if ((target_x >= width) or (target_y >= height) or (target_x <= 0) or (target_y <= 0))
    then
      CheckDirection:= false
    else
    begin
    
    // Check if move left
    if (current_y = target_y) and (current_x > target_x)
    then
      if ((GetPixel(1, 1) <> GetPixel(target_x+1, target_y)) and (GetPixel(1, 2) <> GetPixel(target_x+1, target_y)))
      then
        CheckDirection:= true;
      
    // Check if move right
    if (current_y = target_y) and (current_x < target_x)
    then
      if ((GetPixel(1, 1) <> GetPixel(target_x+1, target_y)) and (GetPixel(1, 2) <> GetPixel(target_x+1, target_y)))
      then
        CheckDirection:= true;    
      
    // Check if move up
    if (current_y > target_y) and (current_x = target_x)
    then
      if ((GetPixel(1, 1) <> GetPixel(target_x, target_y+1)) and (GetPixel(1, 2) <> GetPixel(target_x, target_y+1)))
      then
        CheckDirection:= true;    
      
    // Check if move down
    if (current_y < target_y) and (current_x = target_x)
    then
      if ((GetPixel(1, 1) <> GetPixel(target_x, target_y+1)) and (GetPixel(1, 2) <> GetPixel(target_x, target_y+1)))
      then
        CheckDirection:= true;    
   end; // else
    
end; // CheckDirection
   
// Removes yellow track
Procedure RemoveTrack();
Var
  i, j: integer; // for loop
  
Begin  
  i:= 2*indent;
  j:= 2*indent;
  
  SetPenColor(clWhite);
  SetBrushColor(clWhite);
  
  
  i:= indent {+ cell_size};
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      
      if (CheckDirection(i,j, i,j+round(cell_size/2)) = false)
      then
      begin
        SetPenWidth(indent + 2);
        SetPenColor(clWhite);
        MoveTo(i - 1, j + line_size);
        LineTo(i - 1, j + cell_size - 2);
        MoveTo(i, j);
      end;
      
      if (CheckDirection(i,j, i+round(cell_size/2),j) = false)
      then
      begin
        SetPenWidth(indent + 2);
        SetPenColor(clWhite);
        MoveTo(i + line_size, j);
        LineTo(i + cell_size - 2, j);
        MoveTo(i,j);
      end;
      
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
  
  
  j:= 2*indent;
  
  SetBrushColor(clWhite);
  SetPixel(1,1, track_color);
  
  while(j < height) do
  begin
    i:= 2*indent;
    while (i < width) do
    begin
      if GetPixel(i,j) = GetPixel(1, 1)
      then
        FillRectangle(i - line_size,j - line_size, i + cell_size - indent - line_size, j + cell_size - 2*indent + line_size);
      
      i:= i + cell_size;
      
    end;
    j:= j + cell_size;
  end;
  
  SetPenWidth(line_size);
  SetPenColor(maze_color);
  MoveTo(width-indent, height-indent-cell_size);
  LineTo(width-indent, indent);
  
end; // RemoveTrack

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
  
  // Draw rectangle
  MoveTo(target_x, target_y);
  SetPenColor(track_color);
  SetPenWidth(line_size);
  DrawRectangle(target_x,target_y, target_x+player_size,target_y+player_size);
  MoveTo(target_x,target_y);
  
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

// ---------STACK SUBPROGRAMS BLOCK--------//

{
  Realization of stack in Pascal:
  
  - Procedure "push" pushes element c in array a with current number of elements equal to size
  - Procedure "pop" removes the last element from the top of array a with current number of elements equal to size
  - Function "top" returns the last elements of array a with current number of elements equal to size
}

Procedure push(c :integer; var a: stack; var size: integer);
begin
  size := size + 1;
  a[size] := c; 
end;  
 
Procedure pop(var a: stack; var size: integer);
begin
  size := size - 1;
end;

Function top(a: stack; size: integer) : integer;
begin
  top := a[size];
end;


// ---------END OF STACK SUBPROGRAMS BLOCK--------//

begin
end.