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
  
  //Fill everything white
  SetBrushColor(clWhite);
  FillRectangle(1,1, width, height);
  
  MainMenu();
  
end.