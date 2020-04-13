// Find the shortest solution of the maze (on development...)
Unit optimal_solver;

Uses
  common;
Uses
  GraphABC;

Procedure PaveWay(current_x, current_y, target_x, target_y: integer);
Var
  current_pen_color: Color;
  current_width: integer;
  current_brush_color: Color;
  
Begin
  
  // Remember settings
  current_pen_color:= PenColor;
  current_width:= PenWidth;
  current_brush_color:= BrushColor;

  // Fill rectangle
  SetBrushColor(track_color);
  FillRectangle(current_x-1,current_y-1, current_x+player_size+1,current_y+player_size+1);
  
  // Draw line
  SetPenColor(track_color);
  SetPenWidth(player_size+line_size-1);
  MoveTo(round(current_x+(player_size/2)), round(current_y+(player_size/2)));
  LineTo(round(target_x+(player_size/2)), round(target_y+(player_size/2)));
  
  FillRectangle(target_x-1, target_y-1, target_x + player_size+1, target_y + player_size+1);
  
  // Get settings back
  MoveTo(current_x, current_y);
  SetPenColor(current_pen_color);
  SetPenWidth(current_width);
  SetBrushColor(current_brush_color);
  
end; // PaveWay

Procedure FindPath(x, y: integer);

Type
  cell = record 
    X: integer;
    Y: integer;
    status: integer;
  end; 

const
  total_cells = 1200;

var
  left, right, up, down: boolean; // directions
  ways: integer;  
  i, j, k, n, f: integer;
  cells: array[1..total_cells] of cell;
  
begin
  
  DeletePlayer(x,y);
  RemoveTrack();
  MoveTo(2*indent, 2*indent);
  SetPlayer(PenX, PenY);
  
  
  k:= 2*indent;
  n:= 1;
  
  for i:= 1 to round((width-2*indent)/cell_size) do
  begin
    f:= 2*indent;
    for j:= 1 to round((height-2*indent)/cell_size) do
    begin
      
      cells[n].X:= f;
      cells[n].Y:= k;
      cells[n].status:= 0; // unused
      
      f:= f + cell_size;
      n:= n + 1;
      
    end;
    
    k:= k + cell_size;    
  end;
  
  ways:= 1;
  

      left:= ((CheckDirection(PenX,PenY, PenX-cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX-cell_size,PenY) = true));
      right:= ((CheckDirection(PenX,PenY, PenX+cell_size,PenY) = true) and (CheckMove(PenX,PenY, PenX+cell_size,PenY) = true));
      up:= ((CheckDirection(PenX,PenY, PenX,PenY-cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY-cell_size) = true));
      down:= ((CheckDirection(PenX,PenY, PenX,PenY+cell_size) = true) and (CheckMove(PenX,PenY, PenX,PenY+cell_size) = true));
      
      if (left)
      then
      begin
        PaveWay(PenX, PenY, PenX - cell_size, PenY);
        ways:= ways + 1;
      end;
      
      if (right)
      then
      begin
        PaveWay(PenX, PenY, PenX + cell_size, PenY);
        ways:= ways + 1;
      end;
      
      if (up)
      then
      begin
        PaveWay(PenX, PenY, PenX, PenY - cell_size);
        ways:= ways + 1;
      end;
        
      if (down)
      then
      begin
        PaveWay(PenX, PenY, PenX, PenY + cell_size);
        ways:= ways + 1;
      end;
      
      ways:= ways - 1;
     { 
      for i:= 1 to total_cells do
      begin
        writeln(cells[i].X);
        writeln(cells[i].Y);
        writeln(cells[i].status);
      end;
     }
end;
  
Begin
end.