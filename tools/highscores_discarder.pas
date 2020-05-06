Unit highscores_discarder;

Procedure DiscardHighScores();
Var
  f:text;
  
Begin
  assign(f, 'src/highscores.txt');
  rewrite(f);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  writeln(f, '-');
  writeln(f, 0);
  
  close(f);
end;

Begin
end.