uses graphABC,ABCButtons;
procedure Draw;
begin
setpencolor(clBlue);
setbrushcolor(clBlue);
circle(200,200,100);
end;
begin
var b:=new ButtonABC(20,400,100,50,'Кнопка 1',clRed); 
b.OnClick:=Draw;
end.