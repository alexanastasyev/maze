Unit input_maze;

Uses
  GraphABC;
Uses
  common in '../modules/common.pas';
Uses
  optimal_solver in '../modules/optimal_solver.pas';
  
Const
  active = maze_color;
  unactive = clLightBlue;
  
 

Procedure DrawUnactiveWalls();
var
  i,j: integer;
  
begin
   
  i:= indent;
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      
      SetPenWidth(line_size);
      SetPenColor(unactive);
      MoveTo(i,j);
      LineTo(i,j+cell_size+1);
      MoveTo(i,j);
      
      SetPenWidth(line_size);
      SetPenColor(unactive);
      MoveTo(i, j);
      LineTo(i+cell_size+1,j);
      MoveTo(i,j);
      
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
    
  
end;

Procedure WallAction(x, y: integer; horizontal: boolean);
begin
  
  SetPixel(1,1, active);
  
  if ((horizontal) and (GetPixel(x + 5,y) = GetPixel(1,1)))
  then
    SetPenColor(unactive);
  
  if ((horizontal) and (GetPixel(x + 5,y) <> GetPixel(1,1)))
  then
    SetPenColor(active);
  
  if (not(horizontal) and (GetPixel(x,y + 5) = GetPixel(1,1)))
  then
    SetPenColor(unactive);
  
  if (not(horizontal) and (GetPixel(x,y + 5) <> GetPixel(1,1)))
  then
    SetPenColor(active);
  
  SetPenWidth(line_size);
  MoveTo(x,y);
  
  if (horizontal)
  then
    LineTo(x + cell_size, y)
  else
    LineTo(x, y + cell_size);
  
  DrawBorderWalls();
  DrawFinish();
  
end;

Procedure InputMouseDown(x, y, mousebutton: integer);
var
  x_start: integer;
  y_start: integer;
  horizontal: boolean;
  vertical: boolean;
  
begin
  
  if (mousebutton = 1)
  then
  begin
    
    x_start:= 0;
    y_start:= 0;
    
    case x of
      
      (indent + line_size + 1)..(indent + cell_size - line_size): // 1
      begin
        x_start:= indent + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + cell_size + 1)..(indent + 2*cell_size - line_size): // 2
      begin
        x_start:= indent + cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 2*cell_size + 1)..(indent + 3*cell_size - line_size): // 3
      begin
        x_start:= indent + 2*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 3*cell_size + 1)..(indent + 4*cell_size - line_size): // 4
      begin
        x_start:= indent + 3*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 4*cell_size + 1)..(indent + 5*cell_size - line_size): // 5
      begin
        x_start:= indent + 4*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 5*cell_size + 1)..(indent + 6*cell_size - line_size): // 6
      begin
        x_start:= indent + 5*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 6*cell_size + 1)..(indent + 7*cell_size - line_size): // 7
      begin
        x_start:= indent + 6*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 7*cell_size + 1)..(indent + 8*cell_size - line_size): // 8
      begin
        x_start:= indent + 7*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 8*cell_size + 1)..(indent + 9*cell_size - line_size): // 9
      begin
        x_start:= indent + 8*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 9*cell_size + 1)..(indent + 10*cell_size - line_size): // 10
      begin
        x_start:= indent + 9*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 10*cell_size + 1)..(indent + 11*cell_size - line_size): // 11
      begin
        x_start:= indent + 10*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 11*cell_size + 1)..(indent + 12*cell_size - line_size): // 12
      begin
        x_start:= indent + 11*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 12*cell_size + 1)..(indent + 13*cell_size - line_size): // 13
      begin
        x_start:= indent + 12*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 13*cell_size + 1)..(indent + 14*cell_size - line_size): // 14
      begin
        x_start:= indent + 13*cell_size + 1;
        horizontal:= true;
      end;
            
      (indent + line_size + 14*cell_size + 1)..(indent + 15*cell_size - line_size): // 15
      begin
        x_start:= indent + 14*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 15*cell_size + 1)..(indent + 16*cell_size - line_size): // 16
      begin
        x_start:= indent + 15*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 16*cell_size + 1)..(indent + 17*cell_size - line_size): // 17
      begin
        x_start:= indent + 16*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 17*cell_size + 1)..(indent + 18*cell_size - line_size): // 18
      begin
        x_start:= indent + 17*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 18*cell_size + 1)..(indent + 19*cell_size - line_size): // 19
      begin
        x_start:= indent + 18*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 19*cell_size + 1)..(indent + 20*cell_size - line_size): // 20
      begin
        x_start:= indent + 19*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 20*cell_size + 1)..(indent + 21*cell_size - line_size): // 21
      begin
        x_start:= indent + 20*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 21*cell_size + 1)..(indent + 22*cell_size - line_size): // 22
      begin
        x_start:= indent + 21*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 22*cell_size + 1)..(indent + 23*cell_size - line_size): // 23
      begin
        x_start:= indent + 22*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 23*cell_size + 1)..(indent + 24*cell_size - line_size): // 24
      begin
        x_start:= indent + 23*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 24*cell_size + 1)..(indent + 25*cell_size - line_size): // 25
      begin
        x_start:= indent + 24*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 25*cell_size + 1)..(indent + 26*cell_size - line_size): // 26
      begin
        x_start:= indent + 25*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 26*cell_size + 1)..(indent + 27*cell_size - line_size): // 27
      begin
        x_start:= indent + 26*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 27*cell_size + 1)..(indent + 28*cell_size - line_size): // 28
      begin
        x_start:= indent + 27*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 28*cell_size + 1)..(indent + 29*cell_size - line_size): // 29
      begin
        x_start:= indent + 28*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 29*cell_size + 1)..(indent + 30*cell_size - line_size): // 30
      begin
        x_start:= indent + 29*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 30*cell_size + 1)..(indent + 31*cell_size - line_size): // 31
      begin
        x_start:= indent + 30*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 31*cell_size + 1)..(indent + 32*cell_size - line_size): // 32
      begin
        x_start:= indent + 31*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 32*cell_size + 1)..(indent + 33*cell_size - line_size): // 33
      begin
        x_start:= indent + 32*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 33*cell_size + 1)..(indent + 34*cell_size - line_size): // 34
      begin
        x_start:= indent + 33*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 34*cell_size + 1)..(indent + 35*cell_size - line_size): // 35
      begin
        x_start:= indent + 34*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 35*cell_size + 1)..(indent + 36*cell_size - line_size): // 36
      begin
        x_start:= indent + 35*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 36*cell_size + 1)..(indent + 37*cell_size - line_size): // 37
      begin
        x_start:= indent + 36*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 37*cell_size + 1)..(indent + 38*cell_size - line_size): // 38
      begin
        x_start:= indent + 37*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 38*cell_size + 1)..(indent + 39*cell_size - line_size): // 39
      begin
        x_start:= indent + 38*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 39*cell_size + 1)..(indent + 40*cell_size - line_size): // 40
      begin
        x_start:= indent + 39*cell_size + 1;
        horizontal:= true;
      end;
      
      //-----------------------------------------------------------------------------------------
      
      (indent + cell_size)..(indent + cell_size + line_size): // 1-2
      begin
        x_start:= indent + cell_size;
        horizontal:= false;
      end;
      
      (indent + 2*cell_size)..(indent + 2*cell_size + line_size): // 2-3
      begin
        x_start:= indent + 2*cell_size;
        horizontal:= false;
      end;
  
      (indent + 3*cell_size)..(indent + 3*cell_size + line_size): // 3-4
      begin
        x_start:= indent + 3*cell_size;
        horizontal:= false;
      end;

      (indent + 4*cell_size)..(indent + 4*cell_size + line_size): // 4-5
      begin
        x_start:= indent + 4*cell_size;
        horizontal:= false;
      end;

      (indent + 5*cell_size)..(indent + 5*cell_size + line_size): // 5-6
      begin
        x_start:= indent + 5*cell_size;
        horizontal:= false;
      end;
      
      (indent + 6*cell_size)..(indent + 6*cell_size + line_size): // 6-7
      begin
        x_start:= indent + 6*cell_size;
        horizontal:= false;
      end;
      
      (indent + 7*cell_size)..(indent + 7*cell_size + line_size): // 7-8
      begin
        x_start:= indent + 7*cell_size;
        horizontal:= false;
      end;
      
      (indent + 8*cell_size)..(indent + 8*cell_size + line_size): // 8-9
      begin
        x_start:= indent + 8*cell_size;
        horizontal:= false;
      end;
      
      (indent + 9*cell_size)..(indent + 9*cell_size + line_size): // 9-10
      begin
        x_start:= indent + 9*cell_size;
        horizontal:= false;
      end;
      
      (indent + 10*cell_size)..(indent + 10*cell_size + line_size): // 10-11
      begin
        x_start:= indent + 10*cell_size;
        horizontal:= false;
      end;
      
      (indent + 11*cell_size)..(indent + 11*cell_size + line_size): // 11-12
      begin
        x_start:= indent + 11*cell_size;
        horizontal:= false;
      end;
      
      (indent + 12*cell_size)..(indent + 12*cell_size + line_size): // 12-13
      begin
        x_start:= indent + 12*cell_size;
        horizontal:= false;
      end;
      
      (indent + 13*cell_size)..(indent + 13*cell_size + line_size): // 13-14
      begin
        x_start:= indent + 13*cell_size;
        horizontal:= false;
      end;
      
      (indent + 14*cell_size)..(indent + 14*cell_size + line_size): // 14-15
      begin
        x_start:= indent + 14*cell_size;
        horizontal:= false;
      end;
      
      (indent + 15*cell_size)..(indent + 15*cell_size + line_size): // 15-16
      begin
        x_start:= indent + 15*cell_size;
        horizontal:= false;
      end;
      
      (indent + 16*cell_size)..(indent + 16*cell_size + line_size): // 16-17
      begin
        x_start:= indent + 16*cell_size;
        horizontal:= false;
      end;
      
      (indent + 17*cell_size)..(indent + 17*cell_size + line_size): // 17-18
      begin
        x_start:= indent + 17*cell_size;
        horizontal:= false;
      end;
      
      (indent + 18*cell_size)..(indent + 18*cell_size + line_size): // 18-19
      begin
        x_start:= indent + 18*cell_size;
        horizontal:= false;
      end;
      
      (indent + 19*cell_size)..(indent + 19*cell_size + line_size): // 19-20
      begin
        x_start:= indent + 19*cell_size;
        horizontal:= false;
      end;
      
      (indent + 20*cell_size)..(indent + 20*cell_size + line_size): // 20-21
      begin
        x_start:= indent + 20*cell_size;
        horizontal:= false;
      end;
      
      (indent + 21*cell_size)..(indent + 21*cell_size + line_size): // 21-22
      begin
        x_start:= indent + 21*cell_size;
        horizontal:= false;
      end;
      
      (indent + 22*cell_size)..(indent + 22*cell_size + line_size): // 22-23
      begin
        x_start:= indent + 22*cell_size;
        horizontal:= false;
      end;
      
      (indent + 23*cell_size)..(indent + 23*cell_size + line_size): // 23-24
      begin
        x_start:= indent + 23*cell_size;
        horizontal:= false;
      end;
      
      (indent + 24*cell_size)..(indent + 24*cell_size + line_size): // 24-25
      begin
        x_start:= indent + 24*cell_size;
        horizontal:= false;
      end;
      
      (indent + 25*cell_size)..(indent + 25*cell_size + line_size): // 25-26
      begin
        x_start:= indent + 25*cell_size;
        horizontal:= false;
      end;
      
      (indent + 26*cell_size)..(indent + 26*cell_size + line_size): // 26-27
      begin
        x_start:= indent + 26*cell_size;
        horizontal:= false;
      end;
      
      (indent + 27*cell_size)..(indent + 27*cell_size + line_size): // 27-28
      begin
        x_start:= indent + 27*cell_size;
        horizontal:= false;
      end;
      
      (indent + 28*cell_size)..(indent + 28*cell_size + line_size): // 28-29
      begin
        x_start:= indent + 28*cell_size;
        horizontal:= false;
      end;
      
      (indent + 29*cell_size)..(indent + 29*cell_size + line_size): // 29-30
      begin
        x_start:= indent + 29*cell_size;
        horizontal:= false;
      end;
      
      (indent + 30*cell_size)..(indent + 30*cell_size + line_size): // 30-31
      begin
        x_start:= indent + 30*cell_size;
        horizontal:= false;
      end;
      
      (indent + 31*cell_size)..(indent + 31*cell_size + line_size): // 31-32
      begin
        x_start:= indent + 31*cell_size;
        horizontal:= false;
      end;
      
      (indent + 32*cell_size)..(indent + 32*cell_size + line_size): // 32-33
      begin
        x_start:= indent + 32*cell_size;
        horizontal:= false;
      end;
      
      (indent + 33*cell_size)..(indent + 33*cell_size + line_size): // 33-34
      begin
        x_start:= indent + 33*cell_size;
        horizontal:= false;
      end;
      
      (indent + 34*cell_size)..(indent + 34*cell_size + line_size): // 34-35
      begin
        x_start:= indent + 34*cell_size;
        horizontal:= false;
      end;
      
      (indent + 35*cell_size)..(indent + 35*cell_size + line_size): // 35-36
      begin
        x_start:= indent + 35*cell_size;
        horizontal:= false;
      end;
      
      (indent + 36*cell_size)..(indent + 36*cell_size + line_size): // 36-37
      begin
        x_start:= indent + 36*cell_size;
        horizontal:= false;
      end;
      
      (indent + 37*cell_size)..(indent + 37*cell_size + line_size): // 37-38
      begin
        x_start:= indent + 37*cell_size;
        horizontal:= false;
      end;
      
      (indent + 38*cell_size)..(indent + 38*cell_size + line_size): // 38-39
      begin
        x_start:= indent + 38*cell_size;
        horizontal:= false;
      end;
      
      (indent + 39*cell_size)..(indent + 39*cell_size + line_size): // 39-40
      begin
        x_start:= indent + 39*cell_size;
        horizontal:= false;
      end;
      
      else
        x_start:= 0;
      
    end;
    
    // -------------------------------------------------------------------------
    
    case y of
      
      (indent + line_size)..(indent + cell_size - line_size): // 1
      begin
        y_start:= indent + 1;
        vertical:= true;
      end;
      
      (indent + line_size + cell_size + 1)..(indent + 2*cell_size - line_size): // 2
      begin
        y_start := indent + cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 2*cell_size + 1)..(indent + 3*cell_size - line_size): // 3
      begin
        y_start := indent + 2*cell_size + 1;
        vertical:= true;
      end;
      
           (indent + line_size + 3*cell_size + 1)..(indent + 4*cell_size - line_size): // 4
      begin
        y_start:= indent + 3*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 4*cell_size + 1)..(indent + 5*cell_size - line_size): // 5
      begin
        y_start:= indent + 4*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 5*cell_size + 1)..(indent + 6*cell_size - line_size): // 6
      begin
        y_start:= indent + 5*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 6*cell_size + 1)..(indent + 7*cell_size - line_size): // 7
      begin
        y_start:= indent + 6*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 7*cell_size + 1)..(indent + 8*cell_size - line_size): // 8
      begin
        y_start:= indent + 7*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 8*cell_size + 1)..(indent + 9*cell_size - line_size): // 9
      begin
        y_start:= indent + 8*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 9*cell_size + 1)..(indent + 10*cell_size - line_size): // 10
      begin
        y_start:= indent + 9*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 10*cell_size + 1)..(indent + 11*cell_size - line_size): // 11
      begin
        y_start:= indent + 10*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 11*cell_size + 1)..(indent + 12*cell_size - line_size): // 12
      begin
        y_start:= indent + 11*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 12*cell_size + 1)..(indent + 13*cell_size - line_size): // 13
      begin
        y_start:= indent + 12*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 13*cell_size + 1)..(indent + 14*cell_size - line_size): // 14
      begin
        y_start:= indent + 13*cell_size + 1;
        vertical:= true;
      end;
            
      (indent + line_size + 14*cell_size + 1)..(indent + 15*cell_size - line_size): // 15
      begin
        y_start:= indent + 14*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 15*cell_size + 1)..(indent + 16*cell_size - line_size): // 16
      begin
        y_start:= indent + 15*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 16*cell_size + 1)..(indent + 17*cell_size - line_size): // 17
      begin
        y_start:= indent + 16*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 17*cell_size + 1)..(indent + 18*cell_size - line_size): // 18
      begin
        y_start:= indent + 17*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 18*cell_size + 1)..(indent + 19*cell_size - line_size): // 19
      begin
        y_start:= indent + 18*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 19*cell_size + 1)..(indent + 20*cell_size - line_size): // 20
      begin
        y_start:= indent + 19*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 20*cell_size + 1)..(indent + 21*cell_size - line_size): // 21
      begin
        y_start:= indent + 20*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 21*cell_size + 1)..(indent + 22*cell_size - line_size): // 22
      begin
        y_start:= indent + 21*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 22*cell_size + 1)..(indent + 23*cell_size - line_size): // 23
      begin
        y_start:= indent + 22*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 23*cell_size + 1)..(indent + 24*cell_size - line_size): // 24
      begin
        y_start:= indent + 23*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 24*cell_size + 1)..(indent + 25*cell_size - line_size): // 25
      begin
        y_start:= indent + 24*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 25*cell_size + 1)..(indent + 26*cell_size - line_size): // 26
      begin
        y_start:= indent + 25*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 26*cell_size + 1)..(indent + 27*cell_size - line_size): // 27
      begin
        y_start:= indent + 26*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 27*cell_size + 1)..(indent + 28*cell_size - line_size): // 28
      begin
        y_start:= indent + 27*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 28*cell_size + 1)..(indent + 29*cell_size - line_size): // 29
      begin
        y_start:= indent + 28*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 29*cell_size + 1)..(indent + 30*cell_size - line_size): // 30
      begin
        y_start:= indent + 29*cell_size + 1;
        vertical:= true;
      end;

      
      //----------------------------------------------------------------------
      
      
      (indent + cell_size)..(indent + cell_size + line_size): // 1-2
      begin
        y_start:= indent + cell_size;
        vertical:= false;
      end;
             
      (indent + 2*cell_size)..(indent + 2*cell_size + line_size): // 2-3
      begin
        y_start:= indent + 2*cell_size;
        vertical:= false;
      end;
   
      (indent + 3*cell_size)..(indent + 3*cell_size + line_size): // 3-4
      begin
        y_start:= indent + 3*cell_size;
        vertical:= false;
      end;
      
           (indent + 4*cell_size)..(indent + 4*cell_size + line_size): // 4-5
      begin
        y_start:= indent + 4*cell_size;
        vertical:= false;
      end;

      (indent + 5*cell_size)..(indent + 5*cell_size + line_size): // 5-6
      begin
        y_start:= indent + 5*cell_size;
        vertical:= false;
      end;
      
      (indent + 6*cell_size)..(indent + 6*cell_size + line_size): // 6-7
      begin
        y_start:= indent + 6*cell_size;
        vertical:= false;
      end;
      
      (indent + 7*cell_size)..(indent + 7*cell_size + line_size): // 7-8
      begin
        y_start:= indent + 7*cell_size;
        vertical:= false;
      end;
      
      (indent + 8*cell_size)..(indent + 8*cell_size + line_size): // 8-9
      begin
        y_start:= indent + 8*cell_size;
        vertical:= false;
      end;
      
      (indent + 9*cell_size)..(indent + 9*cell_size + line_size): // 9-10
      begin
        y_start:= indent + 9*cell_size;
        vertical:= false;
      end;
      
      (indent + 10*cell_size)..(indent + 10*cell_size + line_size): // 10-11
      begin
        y_start:= indent + 10*cell_size;
        vertical:= false;
      end;
      
      (indent + 11*cell_size)..(indent + 11*cell_size + line_size): // 11-12
      begin
        y_start:= indent + 11*cell_size;
        vertical:= false;
      end;
      
      (indent + 12*cell_size)..(indent + 12*cell_size + line_size): // 12-13
      begin
        y_start:= indent + 12*cell_size;
        vertical:= false;
      end;
      
      (indent + 13*cell_size)..(indent + 13*cell_size + line_size): // 13-14
      begin
        y_start:= indent + 13*cell_size;
        vertical:= false;
      end;
      
      (indent + 14*cell_size)..(indent + 14*cell_size + line_size): // 14-15
      begin
        y_start:= indent + 14*cell_size;
        vertical:= false;
      end;
      
      (indent + 15*cell_size)..(indent + 15*cell_size + line_size): // 15-16
      begin
        y_start:= indent + 15*cell_size;
        vertical:= false;
      end;
      
      (indent + 16*cell_size)..(indent + 16*cell_size + line_size): // 16-17
      begin
        y_start:= indent + 16*cell_size;
        vertical:= false;
      end;
      
      (indent + 17*cell_size)..(indent + 17*cell_size + line_size): // 17-18
      begin
        y_start:= indent + 17*cell_size;
        vertical:= false;
      end;
      
      (indent + 18*cell_size)..(indent + 18*cell_size + line_size): // 18-19
      begin
        y_start:= indent + 18*cell_size;
        vertical:= false;
      end;
      
      (indent + 19*cell_size)..(indent + 19*cell_size + line_size): // 19-20
      begin
        y_start:= indent + 19*cell_size;
        vertical:= false;
      end;
      
      (indent + 20*cell_size)..(indent + 20*cell_size + line_size): // 20-21
      begin
        y_start:= indent + 20*cell_size;
        vertical:= false;
      end;
      
      (indent + 21*cell_size)..(indent + 21*cell_size + line_size): // 21-22
      begin
        y_start:= indent + 21*cell_size;
        vertical:= false;
      end;
      
      (indent + 22*cell_size)..(indent + 22*cell_size + line_size): // 22-23
      begin
        y_start:= indent + 22*cell_size;
        vertical:= false;
      end;
      
      (indent + 23*cell_size)..(indent + 23*cell_size + line_size): // 23-24
      begin
        y_start:= indent + 23*cell_size;
        vertical:= false;
      end;
      
      (indent + 24*cell_size)..(indent + 24*cell_size + line_size): // 24-25
      begin
        y_start:= indent + 24*cell_size;
        vertical:= false;
      end;
      
      (indent + 25*cell_size)..(indent + 25*cell_size + line_size): // 25-26
      begin
        y_start:= indent + 25*cell_size;
        vertical:= false;
      end;
      
      (indent + 26*cell_size)..(indent + 26*cell_size + line_size): // 26-27
      begin
        y_start:= indent + 26*cell_size;
        vertical:= false;
      end;
      
      (indent + 27*cell_size)..(indent + 27*cell_size + line_size): // 27-28
      begin
        y_start:= indent + 27*cell_size;
        vertical:= false;
      end;
      
      (indent + 28*cell_size)..(indent + 28*cell_size + line_size): // 28-29
      begin
        y_start:= indent + 28*cell_size;
        vertical:= false;
      end;
      
      (indent + 29*cell_size)..(indent + 29*cell_size + line_size): // 29-30
      begin
        y_start:= indent + 29*cell_size;
        vertical:= false;
      end;

      
      else
        y_start:= 0;
      
    end;
    
    if ((x_start <> 0) and (y_start <> 0) and not(horizontal and vertical) and (horizontal or vertical))
    then
      WallAction(x_start, y_start, horizontal);
  end;
  
end;

Procedure RemoveUnactive();
var
  i,j: integer;
  
begin
   
  i:= indent;
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      SetPixel(1,1, unactive);
      SetPixel(1,2, active);
      if (GetPixel(i + line_size,j) = GetPixel(1,1))
      then
      begin
        SetPenWidth(line_size);
        SetPenColor(clWhite);
        MoveTo(i ,j);
        LineTo(i + cell_size,j);
        
          if ((GetPixel(i - line_size, j) = GetPixel(1,2)) 
         or (GetPixel(i + line_size, j) = GetPixel(1,2))
         or (GetPixel(i, j + line_size) = GetPixel(1,2))
         or (GetPixel(i, j - line_size) = GetPixel(1,2)))
        then
        begin
          MoveTo(i - 1, j);
          SetPenColor(active);
          LineTo(i + 1,j);
          
          MoveTo(i - 1, j - 1);
          SetPenColor(active);
          LineTo(i + 1, j - 1);
          
          MoveTo(i - 1, j + 1);
          SetPenColor(active);
          LineTo(i + 1, j + 1);
          
        end;
        
        MoveTo(i,j);
      end;
      if (GetPixel(i,j+line_size) = GetPixel(1,1))
      then
      begin
        SetPenWidth(line_size);
        SetPenColor(clWhite);
        MoveTo(i, j);
        LineTo(i,j + cell_size);
        
        if ((GetPixel(i - line_size, j) = GetPixel(1,2)) 
       or (GetPixel(i + line_size, j) = GetPixel(1,2))
       or (GetPixel(i, j + line_size) = GetPixel(1,2))
       or (GetPixel(i, j - line_size) = GetPixel(1,2)))
      then
      begin
        MoveTo(i, j - 1);
        SetPenColor(active);
        LineTo(i, j + 1);
        
        MoveTo(i - 1, j - 1);
        SetPenColor(active);
        LineTo(i - 1, j + 1);
        
        MoveTo(i + 1, j - 1);
        SetPenColor(active);
        LineTo(i + 1, j + 1);
        
      end;
        MoveTo(i,j);
        
      end;
      
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
  
   
  
  DrawBorderWalls();
  DrawFinish();
  
end;

Procedure InputKeyDown(key: integer);

begin
  
  if (key = VK_F5)
  then
  begin
    RemoveUnactive;
    SaveWindow('MyMaze');
  end;
  
end;

Procedure StartInput();
begin
  
  DrawUnactiveWalls();
  DrawBorderWalls;
  DrawFinish();
  OnMouseDown:= InputMouseDown;
  OnKeyDown:= InputKeyDown;
  
end;

begin
end.