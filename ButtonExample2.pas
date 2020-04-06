uses graphABC;
var x1,y1,x2,y2:integer;
procedure MouseDown(x,y,mousebutton: integer);
begin
if(x in [x1..x2])and(y in [y1..y2]) then
 begin
  setpencolor(clBlue);
  setbrushcolor(clBlue);
  circle(200,200,100);
 end;
end; 
begin
x1:=10;
y1:=440;
x2:=120;
y2:=470;
setpencolor(clGreen);
setbrushcolor(clGreen); 
rectangle(x1,y1,x2,y2);
onmousedown:=MouseDown;
end.