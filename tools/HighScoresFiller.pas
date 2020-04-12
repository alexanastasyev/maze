Program writer;
Var
  f:text;
Begin
  assign(f, '../src/highscores.txt');
  rewrite(f);
  
  writeln(f, 'ALEX');
  writeln(f, 100);
  
  writeln(f, 'ANDREW');
  writeln(f, 200);
  
  writeln(f, 'FRED');
  writeln(f, 300);
  
  writeln(f, 'HELEN');
  writeln(f, 400);
  
  writeln(f, 'JOE');
  writeln(f, 500);
  
  writeln(f, 'NICK');
  writeln(f, 600);
  
  writeln(f, 'MARY');
  writeln(f, 700);
  
  writeln(f, 'BILL');
  writeln(f, 800);
  
  writeln(f, 'DAVID');
  writeln(f, 900);
  
  writeln(f, 'ALINA');
  writeln(f, 1000);
  
  close(f);
end.