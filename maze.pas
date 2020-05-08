Program main;

Uses
  GraphABC;
Uses
  actions in 'modules/actions.pas';
Uses
  common in 'modules/common.pas';

Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width+200);
  CenterWindow;  
  SetWindowIsFixedSize(true); 
  SetWindowTitle('MAZE');
  
  ClearWindow;
  
  MainMenu();
  
end.