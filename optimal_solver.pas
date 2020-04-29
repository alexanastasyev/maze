Unit optimal_solver;

Uses
  common;
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
  
  if (CheckDirection(x,y, x + cell_size, y) and CheckMove(x,y, x + cell_size, y)) // Right
  then
  begin
    PaveRight(x,y);
    checker[1]:= true;
  end;
  
  if (CheckDirection(x,y, x - cell_size, y) and CheckMove(x,y, x - cell_size, y)) // Left
  then
  begin
    PaveLeft(x,y);
    checker[2]:= true;
  end;
  
  if (CheckDirection(x,y, x, y - cell_size) and CheckMove(x,y, x, y - cell_size)) // Up
  then
  begin
    PaveUp(x,y);
    checker[3]:= true;
  end;
  
  if (CheckDirection(x,y, x, y + cell_size) and CheckMove(x,y, x, y + cell_size)) // Down
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
  i, j: integer;
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
        end;
      if (checker[2] = true) // Left
      then
        begin
          number:= number + 1;
          points[number].x := points[i].x - cell_size;
          points[number].y := points[i].y;
          live:= live + 1;
        end;
      if (checker[3] = true) // Up
      then
        begin
          number:= number + 1;
          points[number].x := points[i].x;
          points[number].y := points[i].y - cell_size;
          live:= live + 1;
        end;
      if (checker[4] = true) // Down
      then  
        begin
          number:= number + 1;
          points[number].x := points[i].x;
          points[number].y := points[i].y + cell_size;
          live:= live + 1;
        end;
        
      if ((checker[1] = false) and (checker[2] = false) and (checker[3] = false) and (checker[4] = false))
      then
        live:= live - 1;
      
    end;
    finish:= CheckFinish();
  end; 
  
  SetPlayer(2*indent, 2*indent);
end;


Begin
end.