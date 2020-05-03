Program writer;
Var
  f:text;
Begin
  assign(f, '../src/highscores.txt');
  rewrite(f);
  
  writeln(f, 'ALEX');
  writeln(f, 980);
  
  writeln(f, 'ANDREW');
  writeln(f, 900);
  
  writeln(f, 'FRED');
  writeln(f, 850);
  
  writeln(f, 'HELEN');
  writeln(f, 830);
  
  writeln(f, 'JOE');
  writeln(f, 770);
  
  writeln(f, 'NICK');
  writeln(f, 700);
  
  writeln(f, 'MARY');
  writeln(f, 650);
  
  writeln(f, 'BILL');
  writeln(f, 600);
  
  writeln(f, 'DAVID');
  writeln(f, 540);
  
  writeln(f, 'ALINA');
  writeln(f, 500);
  
  close(f);
end.