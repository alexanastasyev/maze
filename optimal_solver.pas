Unit optimal_solver;

Uses
  common;
Uses
  back_solver;
Uses
  GraphABC;

Type
  point = record
    x: integer;
    y: integer;
  end;

Var  
  points: array[1..10000000] of point; 
  number: integer;
  checker: array[1..4] of boolean;

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
  
end; // DrawSolutionTrack

Function CheckSolutionDirection(current_x, current_y, target_x, target_y: integer): boolean;
begin
  SetPixel(1,1, track_color);
  CheckSolutionDirection:= false;
  
  if ((GetPixel(target_x, target_y) <> GetPixel(1,1)) and
      (GetPixel(target_x - 2*indent + cell_size, target_y) <> GetPixel(1,1)) and
      (GetPixel(target_x, target_y - 2*indent + cell_size) <> GetPixel(1,1)) and
      (GetPixel(target_x - 2*indent + cell_size, target_y - 2*indent + cell_size) <> GetPixel(1,1)))
  then
    CheckSolutionDirection:= true;
  
end;

Procedure PaveRight(x: integer; y: integer);
begin
  DrawTrack(x,y, x + cell_size, y);
  MoveTo(x, y);
end;

Procedure PaveLeft(x: integer; y: integer);
begin
  DrawTrack(x,y, x - cell_size, y);
  MoveTo(x, y);
end;

Procedure PaveUp(x: integer; y: integer);
begin
  DrawTrack(x,y, x, y - cell_size);
  MoveTo(x, y);
end;

Procedure PaveDown(x: integer; y: integer);
begin
  DrawTrack(x,y, x, y + cell_size);
  MoveTo(x, y);
end;
  
Procedure PaveWay(x: integer; y: integer);
begin
  checker[1] := false;
  checker[2] := false;
  checker[3] := false;
  checker[4] := false;
  
  if (CheckMove(x,y, x + cell_size, y) and CheckSolutionDirection(x,y, x + cell_size, y)) // Right
  then
  begin
    PaveRight(x,y);
    checker[1]:= true;
  end;
  
  if (CheckMove(x,y, x - cell_size, y) and CheckSolutionDirection(x,y, x - cell_size, y)) // Left
  then
  begin
    PaveLeft(x,y);
    checker[2]:= true;
  end;
  
  if (CheckMove(x,y, x, y - cell_size) and CheckSolutionDirection(x,y, x, y - cell_size)) // Up
  then
  begin
    PaveUp(x,y);
    checker[3]:= true;
  end;
  
  if (CheckMove(x,y, x, y + cell_size) and CheckSolutionDirection(x,y, x, y + cell_size)) // Down
  then
  begin
    PaveDown(x,y);
    checker[4]:= true;
  end;
end;

Function CheckFinish(): boolean;
var
  i: integer;
  
begin
  for i:= 1 to number do
    if ((points[i].x = finish_x - cell_size) and (points[i].y = finish_y))
    then
    begin
      CheckFinish:= true;
      exit;
    end;
  
end;

Procedure FindPath(x: integer; y: integer);
var
  i: integer;
  local_number: integer;
  finish: boolean;
  live: integer;
  
begin
  number:= 1;
  DeletePlayer(x,y);
  RemoveTrack();
  points[1].x := 2*indent;
  points[1].y := 2*indent;
  live:= 1;
  
  finish:= false;
  while not(finish) do
  begin
    
    local_number:= number;
    for i:= (local_number - live + 1) to local_number do
    begin
      PaveWay(points[i].x, points[i].y);

      if (checker[1] = true) // Right
      then 
        begin
          number:= number + 1;
          points[number].x := points[i].x + cell_size;
          points[number].y := points[i].y;
          live:= live + 1;
          checker[1] := false;
        end;
      if (checker[2] = true) // Left
      then
        begin
          number:= number + 1;
          points[number].x := points[i].x - cell_size;
          points[number].y := points[i].y;
          live:= live + 1;
          checker[2] := false;
        end;
      if (checker[3] = true) // Up
      then
        begin
          number:= number + 1;
          points[number].x := points[i].x;
          points[number].y := points[i].y - cell_size;
          live:= live + 1;
          checker[3] := false;
        end;
      if (checker[4] = true) // Down
      then  
        begin
          number:= number + 1;
          points[number].x := points[i].x;
          points[number].y := points[i].y + cell_size;
          live:= live + 1;
          checker[4] := false;
        end;
        
      if ((checker[1] = false) and (checker[2] = false) and (checker[3] = false) and (checker[4] = false))
      then
        live:= live - 1;
      
    end;
    finish:= CheckFinish();
  end; 
  
  FindStart();
  
  SetPlayer(final_x, final_y);
end;


Begin
end.