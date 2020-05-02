Unit back_solver;

Uses
  GraphABC;
Uses
  common;
  
Const
  final_x = finish_x - cell_size;
  final_y = finish_y;
  
  solution_color = clLightGreen;

Function CheckStartDirection(current_x: integer; current_y: integer; target_x: integer; target_y: integer): boolean;
var
  counter: byte;
  
begin
  
  if ((target_x >= width) or (target_x <= 0) or (target_y >= height) or (target_y <= 0))
  then
    CheckStartDirection:= false
  else
  begin
      SetPixel(1,1, track_color);
       
      CheckStartDirection:= false; 
       
      counter:= 0;
      
      if (current_x < target_x) // Right
      then
        if (GetPixel(current_x - indent + cell_size, current_y) = GetPixel(1,1))
        then
          counter:= counter + 1;
          
      if (current_x > target_x) // Left
      then
        if (GetPixel(current_x - indent, current_y) = GetPixel(1,1))
        then
          counter:= counter + 1;
      
      if (current_y > target_y) // Up
      then
        if (GetPixel(current_x, current_y - indent) = GetPixel(1,1))
        then
          counter:= counter + 1;
        
          
      if (current_y < target_y) // Down
      then
        if (GetPixel(current_x, current_y - indent + cell_size) = GetPixel(1,1))
        then
          counter:= counter + 1;
     
      if ((GetPixel(target_x, target_y) = GetPixel(1,1)) and
          (GetPixel(target_x - 2*indent + cell_size, target_y) = GetPixel(1,1)) and
          (GetPixel(target_x, target_y - 2*indent + cell_size) = GetPixel(1,1)) and
          (GetPixel(target_x - 2*indent + cell_size, target_y - 2*indent + cell_size) = GetPixel(1,1)))
      then
        counter:= counter + 1;
      
      if (counter > 1)
      then
        CheckStartDirection:= true;
  end;
    
end; // CheckStartDirection

Function CheckOrangeDirection(current_x: integer; current_y: integer; target_x: integer; target_y: integer): boolean;
begin
  
    SetPixel(1,2, clOrange);
    CheckOrangeDirection:= false;
    
    if ((target_x >= width) or (target_y >= height) or (target_x <= 0) or (target_y <= 0))
    then
      CheckOrangeDirection:= false
    else
    begin
    
    // Check if move left
    if (current_y = target_y) and (current_x > target_x)
    then
      if (GetPixel(1, 2) <> GetPixel(target_x+1, target_y))
      then
        CheckOrangeDirection:= true;
      
    // Check if move right
    if (current_y = target_y) and (current_x < target_x)
    then
      if (GetPixel(1, 2) <> GetPixel(target_x+1, target_y))
      then
        CheckOrangeDirection:= true;    
      
    // Check if move up
    if (current_y > target_y) and (current_x = target_x)
    then
      if (GetPixel(1, 2) <> GetPixel(target_x, target_y+1))
      then
        CheckOrangeDirection:= true;    
      
    // Check if move down
    if (current_y < target_y) and (current_x = target_x)
    then
      if (GetPixel(1, 2) <> GetPixel(target_x, target_y+1))
      then
        CheckOrangeDirection:= true;    
   end; // else
    
end; // CheckOrangeDirection

// Removes orange track
Procedure RemoveOrangeTrack();
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
      
      if (CheckOrangeDirection(i,j, i,j+round(cell_size/2)) = false)
      then
      begin
        SetPenWidth(indent);
        SetPenColor(clWhite);
        MoveTo(i - 1, j + line_size);
        LineTo(i - 1, j + cell_size - 2);
        MoveTo(i, j);
      end;
      
      if (CheckOrangeDirection(i,j, i+round(cell_size/2),j) = false)
      then
      begin
        SetPenWidth(indent);
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
  SetPixel(1,3,clOrange);
  
  while(j < height) do
  begin
    i:= 2*indent;
    while (i < width) do
    begin
      if GetPixel(i,j) = GetPixel(1,3)
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
  
end; // RemoveOrangeTrack

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

Procedure DrawSolutionTrack(current_x: integer; current_y: integer; target_x: integer; target_y: integer);
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
  SetPenColor(solution_color);
  SetPenWidth(line_size);
  DrawRectangle(current_x,current_y, current_x+player_size,current_y+player_size);
  MoveTo(current_x,current_y);
  
  // Fill rectangle
  SetBrushColor(solution_color);
  FillRectangle(current_x,current_y, current_x+player_size,current_y+player_size);
  
  // Draw line
  SetPenColor(solution_color);
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
Procedure MoveToStartRight(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x+cell_size,y);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawSolutionTrack(x,y, x+cell_size,y);
    SetPlayer(x+cell_size, y);
  end;
    
end; // MoveRight

// Make left move
Procedure MoveToStartLeft(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x-cell_size,y);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawSolutionTrack(x,y, x-cell_size,y);
    SetPlayer(x-cell_size, y);
  end;
    
end; // MoveLeft

// Make up move
Procedure MoveToStartUp(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x,y-cell_size);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawSolutionTrack(x,y, x,y-cell_size);
    SetPlayer(x, y-cell_size);
  end;
  
end; // MoveUp

// Make down move
Procedure MoveToStartDown(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x,y+cell_size);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawSolutionTrack(x,y, x,y+cell_size);
    SetPlayer(x, y+cell_size);
  end;
  
end; // MoveDown

// Finds the start
Procedure FindStart();

Label
  point1;
Label
  point2;

var
  
  direction: integer; // random direction choose variable
  check_start: boolean;
  
  stackX: stack; // stack of x coordinates
  stackY: stack; // stack of y coordinates
  
  sizeX: integer; // size of stackX
  sizeY: integer; // size of stackY
  
  k1, k2, k3: integer; // reserve directions
  state: boolean;
  
begin
    
  MoveTo(final_x, final_y);
  
  SetPlayer(PenX, PenY);
    
  sizeX:= 0;
  sizeY:= 0;
  
  push(PenX, stackX, sizeX);
  push(PenY, stackY, sizeY);
  
  check_start:= ((PenX = 2*indent) and (PenY = 2*indent));
  
  while (not (check_start)) do
  begin
    
    point1:
    // Check if there is a free neighboor
    while  (((CheckMove(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckStartDirection(PenX,PenY, PenX+cell_size,PenY) = true)) 
         or ((CheckMove(PenX,PenY, PenX-cell_size,PenY) = true) and (CheckStartDirection(PenX,PenY, PenX-cell_size,PenY) = true)) 
         or ((CheckMove(PenX,PenY, PenX,PenY-cell_size) = true) and (CheckStartDirection(PenX,PenY, PenX,PenY-cell_size) = true)) 
         or ((CheckMove(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckStartDirection(PenX,PenY, PenX,PenY+cell_size) = true))) 
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
            
            if ((CheckMove(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckStartDirection(PenX,PenY, PenX+cell_size,PenY) = true))
            then
            begin
              
              MoveToStartRight(PenX, PenY);
              
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
            
            if ((CheckMove(PenX,PenY, PenX-cell_size,PenY) = true) and (CheckStartDirection(PenX,PenY, PenX-cell_size,PenY) = true))
            then
            begin
              MoveToStartLeft(PenX, PenY);
              
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
            
            if ((CheckMove(PenX,PenY, PenX,PenY-cell_size) = true) and (CheckStartDirection(PenX,PenY, PenX,PenY-cell_size) = true))
            then
            begin
              MoveToStartUp(PenX, PenY);
 
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
            
            if ((CheckMove(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckStartDirection(PenX,PenY, PenX,PenY+cell_size) = true))
            then
            begin
              MoveToStartDown(PenX, PenY);
              
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
    check_start:= ((PenX = 2*indent) and (PenY = 2*indent));
    
    if (check_start)
    then
      break;
    
    end; // while
    
    point2:

      if (not (check_start))
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
  
  DeletePlayer(PenX, PenY);
  SetBrushColor(solution_color);
  SetPenColor(solution_color);
  DrawRectangle(PenX, PenY, PenX + player_size, PenY + player_size);
  FillRectangle(PenX, PenY, PenX + player_size, PenY + player_size);
  RemoveTrack();
  RemoveOrangeTrack();
  //SetPlayer(final_x, final_y);
  
  
end;

Begin
end.