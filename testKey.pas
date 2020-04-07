{
  Here OnKeyDown works inside OnMouseDown
}

Program TestKey;

Uses
  GraphABC;

Procedure MakeMove(key: integer);
begin

  writeln('KeyDown body');  
  setpencolor(clBlue);
  setbrushcolor(clBlue);
  circle(200,200,100);
  
end;

Procedure PlayGame(x: integer);
begin
  
  writeln('MouseDown body');
  OnKeyDown:= MakeMove;
  
end;

Begin
  
  writeln('It`s main body');
  OnKeyDown:= PlayGame;
  
end.