Program Maze;

Uses 
  GraphABC;

Const
  width = 810; // width of the window
  height = 610; // height of the window
  indent = 5; // maze borders from window borders | player from cell borders
  
  //-------buttons` coordinates begin-------//
  
  button_x1 = round((5/14)*width);
  button_x2 = round((9/14)*width);
  
  button1_y1 = round((4/24)*height);
  button1_y2 = round((6/24)*height);
  
  button2_y1 = round((7/24)*height);
  button2_y2 = round((9/24)*height);
  
  button3_y1 = round((10/24)*height);
  button3_y2 = round((12/24)*height);
  
  button_menu_x1 = indent;
  button_menu_x2 = indent+round((1/7)*width);
  button_menu_y1 = round((21/24)*height);
  button_menu_y2 = round((23/24)*height);

  //-------buttons` coordinates end-------//
  
  cell_size = 20; // size of one square cell
  player_size = 10; // size of square player

  line_size = 3; // width of all lines
  maze_color = clBlue; // color of the maze
  track_color = clYellow; // color of the track
  player_color = clRed; // color of the player
  
  // Coordinates of the finish cell
  finish_x = width;
  finish_y = height-indent-indent-player_size;

Type
  stack = array[1..10000] of integer;

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

Procedure RemoveTrack();
Var
  i, j: integer; // for loop
  
Begin  
  i:= 2*indent;
  j:= 2*indent;
  
  SetPenColor(clWhite);
  SetBrushColor(clWhite);
  
  // SetPixel(indent + 1, indent + 1, clYellow);
 { 
  while (i <> width - 2*indent - player_size) do
  begin
    while (j <> height - 2*indent - player_size) do
    begin
      MoveTo(i, j);
      if (GetPixel(i,j) = GetPixel(indent + 1, indent + 1))
      then
        Rectangle(i,j, i+player_size,j+player_size);
      j:= j + player_size;
    
    end;
    i:= i + player_size;
    
  end;    
  }
  
  // Remove track
  for i:= 1 to width do
    for j:=1 to height do
      if GetPixel(i,j) <> GetPixel(indent+1, indent+1)
      then
        SetPixel(i,j, clWhite);
end;

Procedure RemoveOrangeTrack();
Var
  i, j: integer; // for loop
  
Begin  
  i:= 2*indent;
  j:= 2*indent;
  
  SetPenColor(clWhite);
  SetBrushColor(clWhite);
  
  // SetPixel(indent + 1, indent + 1, clYellow);
 { 
  while (i <> width - 2*indent - player_size) do
  begin
    while (j <> height - 2*indent - player_size) do
    begin
      MoveTo(i, j);
      if (GetPixel(i,j) = GetPixel(indent + 1, indent + 1))
      then
        Rectangle(i,j, i+player_size,j+player_size);
      j:= j + player_size;
    
    end;
    i:= i + player_size;
    
  end;    
  }
  
  // Remove track
  for i:= 1 to width do
    for j:=1 to height do
      if (GetPixel(i,j) = clOrange)
      then
        SetPixel(i,j, clWhite);
end;

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

// Draw second player track
Procedure DrawOrangeTrack(current_x: integer; current_y: integer; target_x: integer; target_y: integer);
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
  SetPenColor(clOrange);
  SetPenWidth(line_size);
  DrawRectangle(current_x,current_y, current_x+player_size,current_y+player_size);
  MoveTo(current_x,current_y);
  
  // Fill rectangle
  SetBrushColor(clOrange);
  FillRectangle(current_x,current_y, current_x+player_size,current_y+player_size);
  
  // Draw line
  SetPenColor(clOrange);
  SetPenWidth(player_size+line_size-1);
  MoveTo(round(current_x+(player_size/2)), round(current_y+(player_size/2)));
  LineTo(round(target_x+(player_size/2)), round(target_y+(player_size/2)));
  
  // Get settings back
  MoveTo(current_x, current_y);
  SetPenColor(current_pen_color);
  SetPenWidth(current_width);
  SetBrushColor(current_brush_color);
  
end; // DrawOrangeTrack

// After-game screen
Procedure Win();
Begin
  
  ClearWindow;
  SetFontSize(30);
  SetFontColor(clLightGreen);
  SetBrushColor(clWhite);
  TextOut(round(width/2.325), round((1/24*height)), 'WIN !!!');
  
end;

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
  
  // Check for win
  if ((PenX = finish_x) and (PenY = finish_y))
  then
    Win();
  
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
  
  // Check for win
  if ((PenX = finish_x) and (PenY = finish_y))
  then
    Win();
  
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
  
  // Check for win
  if ((PenX = finish_x) and (PenY = finish_y))
  then
    Win();
  
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
  
  // Check for win
  if ((PenX = finish_x) and (PenY = finish_y))
  then
    Win();
  
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

// Finds the solution (in development...)
// Try to follow right-ahead-left-back
Procedure FindPath(x: integer; y: integer);

Label
  point1;
Label
  point2;
  
var
  i,j: integer; // for loop
  
  direction: integer; // random direction choose variable
  check_win: boolean;
  
  stackX: stack; // stack of x coordinates
  stackY: stack; // stack of y coordinates
  
  sizeX: integer; // size of stackX
  sizeY: integer; // size of stackY
  
begin
  
  DeletePlayer(x,y);
  
  // Remove track
  RemoveTrack();
  
  MoveTo(2*indent, 2*indent);
  
  SetPlayer(PenX, PenY);
  
  sizeX:= 0;
  sizeY:= 0;
  
  push(PenX, stackX, sizeX);
  push(PenY, stackY, sizeY);
  
  check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
  
  while (not (check_win)) do
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
      direction:= (PABCSystem.random(3472)*PABCSystem.Random(8321)) mod 4 + 1;
      
      case direction of
        
        1: // Right
          begin
            
            if ((CheckDirection(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX+cell_size,PenY) = true))
            then
            begin
              
              MoveRight(PenX, PenY);
              check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
              
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
              check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
              
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
              check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
 
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
              check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY); 
              
            end;
            
          end;
        
      end; // case
    
    check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
    
    if (check_win)
    then
      goto point2;
    
    end; // while

      if (not (check_win))
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
        
        MoveTo(top(StackX,sizeX), top(StackY, sizeY)); 
        
        pop(stackX, sizeX);
        pop(stackY, sizeY);
        
        DrawOrangeTrack(PenX,PenY, top(StackX,sizeX), top(StackY, sizeY));
        
        MoveTo(top(StackX,sizeX), top(StackY, sizeY));      
        
        SetPlayer(top(StackX,sizeX), top(StackY, sizeY));
        
        goto point1;
      end; // if

      
  end; // while
  point2:
  
  RemoveOrangeTrack();
  
end;

// Actions on tapping keys while playing
procedure GameKeyDown(key: integer);  
begin
   
   case key of
     
     VK_Left: // Move left
        MoveLeft(PenX, PenY);
       
     VK_Right: // Move right
        MoveRight(PenX, PenY);
       
     VK_Up: // Move up
        MoveUp(PenX, PenY);
       
     VK_Down: // Move down
        MoveDown(PenX, PenY);
        
        
     VK_F5: // Find solution
        FindPath(PenX, PenY);
     
   end;
   
end; // GameKeyDown

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
  
  stackX: stack; // stack of x coordinates
  stackY: stack; // stack of y coordinates
  
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
      direction:= (PABCSystem.random(3472)*PABCSystem.Random(8321)) mod 4 + 1;
      
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
  
  // Draw blue lines everywhere where possible
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
  
  RemoveTrack();
{
  // Remove track
  for i:= 1 to width do
    for j:=1 to height do
      if GetPixel(i,j) <> GetPixel(indent+1, indent+1)
      then
        SetPixel(i,j, clWhite);
 } 
end; // GenerateMaze
  
// Main playing procedure
procedure PlayGame();
var
  check_win: boolean; // variable for checking win position
    
begin
  ClearWindow;
  
  GenerateMaze();
  
  // Set start position
  MoveTo(2*indent, 2*indent);
  SetPlayer(PenX, PenY);
  
  check_win:= false;
  
  // Making moves
   
    // Catch key tapping
    OnKeyDown:= GameKeyDown;
   
    // Check for win
    check_win:= (PenX = finish_x) and (PenY = finish_y); 
    if (check_win)
    then
      Win();  
  
  
end;  // PlayGame

// Desribes rules of the game
procedure Rules();
begin
  
  writeln('Rules');
  
end;

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

// Action for button1
Procedure Action1();
Begin
  
  ClearWindow;
  PlayGame();
  
end;

// Action for button2
Procedure Action2();
Begin
  
  ClearWindow;
  Rules();
  
end;

// Action for button3
Procedure Action3();
Begin
  
  ClearWindow;
  writeln('Action3');
  
end;

// Catch mouse down inside menu
Procedure MenuMouseDown(x, y, mousebutton: integer);
begin
  
  if ((x > button_x1) and (x < button_x2)) 
  then
  begin
    
    if ((y > button1_y1) and (y < button1_y2))
    then
      Action1();
    
    if ((y > button2_y1) and (y < button2_y2))
    then
      Action2();
    
    if ((y > button3_y1) and (y < button3_y2))
    then
      Action3();
    
  end;
  
end;

// Displays menu
Procedure MainMenu();
begin
  
  ClearWindow;
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(round(width/2.325), round((1/24*height)), 'MAZE');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '         Start');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '    How to play');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, '    High scores');
  
  SetFontColor(clRed);
  OnMouseDown:= MenuMouseDown;
  
  
end;


Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width);
  CenterWindow;  
  
  MainMenu();
  
end.