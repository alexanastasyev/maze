Program load_maze_test;

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
  
  LoadWindow('MyMaze');
end.