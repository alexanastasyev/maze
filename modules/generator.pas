Unit generator;

Uses
  GraphABC;
Uses
  common;

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
  
  r: integer; // random

begin

  
  total_cells:= round((width-2*indent)/cell_size)*round((height-2*indent)/cell_size);
  
  // Set pen settings
  SetPenColor(maze_color);
  SetPenWidth(line_size);
  
  // Draw border
  DrawBorderWalls;
  
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
            
            if ((CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY+cell_size) = true))
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
  
  // Draw blue lines 
  i:= indent {+ cell_size};
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      r:= PABCSystem.random(22);
      
      if (CheckDirection(i,j, i,j+round(cell_size/2)) = true)
      then
      begin
        if (r <> 0)
        then
        begin
          SetPenWidth(line_size);
          SetPenColor(maze_color);
          MoveTo(i,j);
          LineTo(i,j+cell_size+1);
          MoveTo(i,j);
        end;
      end;
      
      if (CheckDirection(i,j, i+round(cell_size/2),j) = true)
      then
      begin
        if (r <> 0)
        then
        begin 
          SetPenWidth(line_size);
          SetPenColor(maze_color);
          MoveTo(i, j);
          LineTo(i+cell_size+1,j);
          MoveTo(i,j);
        end;
      end
      else;
      
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
    
  // Draw finish
  DrawFinish;
  
  RemoveTrack();

end; // GenerateMaze

begin
end.