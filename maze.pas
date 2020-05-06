Program main;

Uses
  GraphABC;
Uses
  actions in 'modules/actions.pas';
Uses
  common in 'modules/common.pas';

Begin
  
  deletings:= 0;
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width+200);
  CenterWindow;  
  SetWindowIsFixedSize(true); 
  SetWindowTitle('MAZE');
  
  //Fill everything with white
  SetBrushColor(clWhite);
  FillRectangle(1,1, width + 200, height);
  
  MainMenu();
  
end.