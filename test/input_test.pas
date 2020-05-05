Program test_input;

Uses
  input_maze;
Uses
  GraphABC;
Uses
  common in '../modules/common.pas';
  
Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width+200);
  CenterWindow;  
  SetWindowIsFixedSize(true); 
  SetWindowTitle('MAZE');
  
  //Fill everything with white
  SetBrushColor(clWhite);
  FillRectangle(1,1, width + 200, height);
  
  StartInput();
  
end.