Program main;

Uses
  GraphABC;
Uses
  actions;
Uses
  common;

Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width+200);
  CenterWindow;  
  SetWindowIsFixedSize(true); 
  SetWindowTitle('MAZE');
  
  MainMenu();
  
end.