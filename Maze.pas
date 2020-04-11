Program Maze;

Uses 
  GraphABC;
Uses
  System;

Const
  width = 810; // width of the window
  height = 610; // height of the window
  indent = 5; // maze borders from window borders | player from cell borders
  
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
  
  button_menu_y1 = round((1/24)*height);
  button_menu_y2 = round((3/24)*height);

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

Var
  counter: integer;
  
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

// Draws menu buttons
Procedure DrawButtons();
var
  current_size: integer;
  current_color: Color;
  
begin
  current_size:= FontSize;
  current_color:= FontColor;
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(width + 30, round((1/24*height)), 'MENU');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '     Start');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, 'How to play');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, 'High scores');
                    
  MakeSpecialButton(button_x1, button4_y1, 
                    button_x2, button4_y2, '      Exit');
  
  SetFontSize(current_size);
  SetFontColor(current_color);
  
end;

// 'MAZE' and creator name
Procedure StartScreen();
begin
  SetFontColor(clGray);
  SetFontSize(100);
  TextOut(round(width/3), round(height/3), 'MAZE');
  SetFontSize(20);
  TextOut(round(width/3)+3, round(height/3) + 140, 'Created by Alexey Anastasyev');
  DrawButtons();
  
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

// Removes yellow track
Procedure RemoveTrack();
Var
  i, j: integer; // for loop
  
Begin  
  i:= 2*indent;
  j:= 2*indent;
  
  SetPenColor(clWhite);
  SetBrushColor(clWhite);
 
  // Remove track
  for i:= 1 to width do
    for j:=1 to height do
      if GetPixel(i,j) <> GetPixel(indent+1, indent+1)
      then
        SetPixel(i,j, clWhite);
  
end;

// Removes orange track
Procedure RemoveOrangeTrack();
Var
  i, j: integer; // for loop
  
Begin  
  i:= 2*indent;
  j:= 2*indent;
  
  SetPenColor(clWhite);
  SetBrushColor(clWhite);
   
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
Var
  str: string;

Begin
  
  ClearWindow;
  SetFontColor(clGray);
  SetFontSize(100);
  TextOut(round(width/3), round(height/3), 'WIN !!!');
  SetFontSize(20);
  counter:= counter - 1;
  if (counter > 100000)
  then
    str:= 'You didn`t solve the maze by yourself'
            //You solved the maze in 555 moves
  else
    str:= '   You solved the maze in ' + IntToStr(counter) + ' moves';
  
  TextOut(round(width/3)-20, round(height/3) + 140, str);
  DrawButtons();
  
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
    counter:= counter + 1;
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
    counter:= counter + 1;
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
    counter:= counter + 1;
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
    counter:= counter + 1;
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

// Finds the solution
Procedure FindPath(x: integer; y: integer);

Label
  point1;
Label
  point2;

var
  
  direction: integer; // random direction choose variable
  check_win: boolean;
  
  stackX: stack; // stack of x coordinates
  stackY: stack; // stack of y coordinates
  
  sizeX: integer; // size of stackX
  sizeY: integer; // size of stackY
  
  k1, k2, k3: integer; // reserve directions
  state: boolean;
  
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
    
      //------------------------------------------------------------------------
      
      k1 := 0;
      k2 := 0;
      k3 := 0;
      
      state:= false;
      
      while not(state) do
      begin
      
      randomize;
      
        case k1 of
          
          1:
            
            case k2 of
              
              2:
              
                case k3 of
                  
                  3: direction:= 4;
                  4: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 4;
                    end;
                end;
              
              3:
              
                case k3 of
                  
                  2: direction:= 4;
                  4: direction:= 2;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 2
                      else
                        direction:= 4;
                    end;
                end;
              
              4:
              
                case k3 of
                  
                  3: direction:= 2;
                  2: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 2;
                    end;
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)
                  then
                    direction:= 2
                  else
                    if (direction = 1)
                    then
                      direction:= 3
                    else
                        direction:= 4;
                 end;
              
            end;
            
          2:
          
            case k2 of
              
              1:
              
                case k3 of
                  
                  3: direction:= 4;
                  4: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 4;
                    end;
                  
                end;
              
              3:
              
                case k3 of
                  
                  1: direction:= 4;
                  4: direction:= 1;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 4;
                    end;
                end;
              
              4:
              
                case k3 of
                  
                  3: direction:= 1;
                  1: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 3;
                    end;
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)  
                  then
                    direction:= 1
                  else
                    if (direction = 1)
                    then
                      direction:= 3
                    else
                      direction:= 4;
                end;  
              
            end;  
              
          3:
          
            case k2 of
              
              1:
              
                case k3 of
                  
                  2: direction:= 4;
                  4: direction:= 2;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 2
                      else
                        direction:= 4;
                    end;
                end;
              
              2:
              
                case k3 of
                  
                  1: direction:= 4;
                  4: direction:= 1;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 4;
                    end;
                end;
              
              4:
              
                case k3 of
                  
                  1: direction:= 2;
                  2: direction:= 1;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 2;
                    end;
                    
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)  
                  then
                    direction:= 1
                  else
                    if (direction = 1)
                    then
                      direction:= 2
                    else
                      direction:= 4;
                end;  
              
            end;  
          
          4:
          
            case k2 of
              
              1:
              
                case k3 of
                  
                  3: direction:= 2;
                  2: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 2;
                    end;
                  
                end;
              
              3:
              
                case k3 of
                  
                  2: direction:= 1;
                  1: direction:= 2;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 2;
                    end;
                  
                end;
              
              2:
              
                case k3 of
                  
                  3: direction:= 1;
                  1: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 1)
                      then
                        direction:= 1
                      else
                        direction:= 3;
                    end;
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)  
                  then
                    direction:= 1
                  else
                    if (direction = 1)
                    then
                      direction:= 3
                    else
                      direction:= 2;
                end;  
              
            end;
          
          0: 
            begin
              direction:= PABCSystem.random(4)+1;
            end;
          
        end;

          

//------------------------------------------------------------------------

      
      case direction of
        
        1: // Right
          begin
            
            if ((CheckDirection(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX+cell_size,PenY) = true))
            then
            begin
              
              MoveRight(PenX, PenY);
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY);
              
              state:= true;

            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
            end;
            
          end;
          
        2: // Left
          begin
            
            if ((CheckDirection(PenX,PenY, PenX-cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX-cell_size,PenY) = true))
            then
            begin
              MoveLeft(PenX, PenY);
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY);
              
              state:= true;
              
            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
            end;
            
          end;
          
          
        3: // Up
          begin
            
            if ((CheckDirection(PenX,PenY, PenX,PenY-cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY-cell_size) = true))
            then
            begin
              MoveUp(PenX, PenY);
 
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY);
              
              state:= true;
              
            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
            end;
            
          end;
          
        4: // Down
          begin
            
            if ((CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true))
            then
            begin
              MoveDown(PenX, PenY);
              
              push(PenX, stackX, sizeX);
              push(PenY, stackY, sizeY); 
              
              state:= true;
              
            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
            end;
            
          end;
        
      end; // case
    
    end;
    check_win:= ((PenX = finish_x - 2*indent - player_size) and (PenY = finish_y));
    
    if (check_win)
    then
      break;
    
    end; // while
    
    point2:

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
       begin
        SetFontSize(22);
        TextOut(width + 130, round((17/24)*height), '0     ');
        FindPath(PenX, PenY);
        counter:=counter + 100000;
       end;
        
     end;
     SetFontSize(22);
     if (counter < 100000)
     then
       TextOut(width + 130, round((17/24)*height), IntToStr(counter))
     else
       TextOut(width + 130, round((17/24)*height), '0');
   
   // Check for win
  if ((PenX = finish_x) and (PenY = finish_y))
  then
    Win();
   
end; // GameKeyDown

// Generate maze
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
  
  k1, k2, k3: integer; // reserve directions
  state: boolean;

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
      
      
//------------------------------------------------------------------------
      
      k1 := 0;
      k2 := 0;
      k3 := 0;
      
      state:= false;
      
      while not(state) do
      begin
      
      randomize;
      
        case k1 of
          
          1:
            
            case k2 of
              
              2:
              
                case k3 of
                  
                  3: direction:= 4;
                  4: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 4;
                    end;
                end;
              
              3:
              
                case k3 of
                  
                  2: direction:= 4;
                  4: direction:= 2;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 2
                      else
                        direction:= 4;
                    end;
                end;
              
              4:
              
                case k3 of
                  
                  3: direction:= 2;
                  2: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 2;
                    end;
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)
                  then
                    direction:= 2
                  else
                    if (direction = 1)
                    then
                      direction:= 3
                    else
                        direction:= 4;
                 end;
              
            end;
            
          2:
          
            case k2 of
              
              1:
              
                case k3 of
                  
                  3: direction:= 4;
                  4: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 4;
                    end;
                  
                end;
              
              3:
              
                case k3 of
                  
                  1: direction:= 4;
                  4: direction:= 1;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 4;
                    end;
                end;
              
              4:
              
                case k3 of
                  
                  3: direction:= 1;
                  1: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 3;
                    end;
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)  
                  then
                    direction:= 1
                  else
                    if (direction = 1)
                    then
                      direction:= 3
                    else
                      direction:= 4;
                end;  
              
            end;  
              
          3:
          
            case k2 of
              
              1:
              
                case k3 of
                  
                  2: direction:= 4;
                  4: direction:= 2;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 2
                      else
                        direction:= 4;
                    end;
                end;
              
              2:
              
                case k3 of
                  
                  1: direction:= 4;
                  4: direction:= 1;
                  0: 
                    begin
                      direction:= PABCSystem.Random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 4;
                    end;
                end;
              
              4:
              
                case k3 of
                  
                  1: direction:= 2;
                  2: direction:= 1;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 2;
                    end;
                    
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)  
                  then
                    direction:= 1
                  else
                    if (direction = 1)
                    then
                      direction:= 2
                    else
                      direction:= 4;
                end;  
              
            end;  
          
          4:
          
            case k2 of
              
              1:
              
                case k3 of
                  
                  3: direction:= 2;
                  2: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 3
                      else
                        direction:= 2;
                    end;
                  
                end;
              
              3:
              
                case k3 of
                  
                  2: direction:= 1;
                  1: direction:= 2;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 0)
                      then
                        direction:= 1
                      else
                        direction:= 2;
                    end;
                  
                end;
              
              2:
              
                case k3 of
                  
                  3: direction:= 1;
                  1: direction:= 3;
                  0: 
                    begin
                      direction:= PABCSystem.random(2);
                      if (direction = 1)
                      then
                        direction:= 1
                      else
                        direction:= 3;
                    end;
                 
                end;
              
              0: 
                begin
                  direction:= PABCSystem.random(3);
                  if (direction = 0)  
                  then
                    direction:= 1
                  else
                    if (direction = 1)
                    then
                      direction:= 3
                    else
                      direction:= 2;
                end;  
              
            end;
          
          0: 
            begin
              direction:= PABCSystem.random(4)+1;
            end;
          
        end;

          

//------------------------------------------------------------------------

      
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
              
              state:= true;

            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
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
              
              state:= true;
              
            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
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
              
              state:= true;
              
            end
            
            else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
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
              
              state:= true;
              
            end;
            
          end
          
          else
            begin
              
              if (k1 = 0)
              then
                k1:= direction
              else
                if (k2 = 0)
                then
                  k2:= direction
                else
                  if (k3 = 0)
                  then
                    k3:= direction
                  else
                    goto point2;
              
            end;
        
      end; // case
    
    end;
    
    end; // while
      
      point2:
      
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
  i:= indent {+ cell_size};
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

end; // GenerateMaze
  
// Main playing procedure
procedure PlayGame();
begin
  ClearWindow;
  
  DrawButtons();
  GenerateMaze();
  counter:= 0;
  
  SetFontColor(clBlack);
  SetFontSize(12);
  TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
  TextOut(width + 10, round((20/24)*height), 'Tap F5 to find the solution');
  
  SetFontSize(22);
  TextOut(width + 10, round((17/24)*height), 'MOVES: ');
  TextOut(width + 130, round((17/24)*height), '0');

  
  // Set start position
  MoveTo(2*indent, 2*indent);
  SetPlayer(PenX, PenY);

  // Catch key tapping
  OnKeyDown:= GameKeyDown;
   
  
end;  // PlayGame

// Desribes the rules of the game
procedure Rules();
begin
  
  ClearWindow;
  SetFontSize(30);
  SetFontColor(clRed);
  TextOut(1,1,'Rules');
  DrawButtons();
  
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
  SetFontSize(30);
  SetFontColor(clRed);
  TextOut(1,1,'High scores');
  DrawButtons();
  
end;

// Action for button4
Procedure Action4();
begin
  CloseWindow();  
  
end;

// Actions for 'menu' button
Procedure Action0();
begin
  
  ClearWindow;
  StartScreen();
  
end;

// Catch mouse down
Procedure MenuMouseDown(x, y, mousebutton: integer);
begin
  
  if (mousebutton = 1)
  then
    if ((x > button_x1) and (x < button_x2)) 
    then
    begin
      
      if ((y > button1_y1) and (y < button1_y2)) // Start
      then
        Action1();
      
      if ((y > button2_y1) and (y < button2_y2)) // How to play
      then
        Action2();
      
      if ((y > button3_y1) and (y < button3_y2)) // High scores
      then
        Action3();
      
      if ((y > button4_y1) and (y < button4_y2)) // Exit
      then
        Action4();
      
      if ((y > button_menu_y1) and (y < button_menu_y2)) // Menu
      then
        Action0();
      
    end;
  
end;

// Displays menu
Procedure MainMenu();
begin
  
  ClearWindow;
  StartScreen();  
  OnMouseDown:= MenuMouseDown;
  
  
end;

Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width+200);
  CenterWindow;  
  SetWindowIsFixedSize(true); 
  SetWindowTitle('MAZE');
  
  MainMenu();
  
end.