Program main;

Uses
  GraphABC;
Uses
  funcs;

Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width+200);
  CenterWindow;  
  SetWindowIsFixedSize(true); 
  SetWindowTitle('MAZE');
  
  MainMenu();
  
end.