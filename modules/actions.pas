Unit actions;

Uses
  GraphABC;
Uses
  generator;
Uses 
  optimal_solver;
Uses 
  common;
// Uses input_maze;

Const
  active = maze_color;
  unactive = clLightGray;

Var
  counter: integer;
  str_inp: string;
  check: boolean;
  check_menu: byte;
  in_game: boolean;
  score: integer;
  action: integer;
  input_menu: boolean;
  random_maze: boolean;
  
// Draws menu buttons
Procedure DrawButtons();
var
  current_size: integer;
  current_color: Color;
  
begin
  current_size:= FontSize;
  current_color:= FontColor;
  
  SetBrushColor(clWhite);
  FillRectangle(width+line_size, 1, width + 200, height);
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(width + 30, round((1/24*height)), 'MENU');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '     Start');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, ' New maze');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, 'How to play');
                    
  MakeSpecialButton(button_x1, button4_y1, 
                    button_x2, button4_y2, 'High scores');
                    
  MakeSpecialButton(button_x1, button5_y1, 
                    button_x2, button5_y2, '      Exit');
  
  SetFontSize(current_size);
  SetFontColor(current_color);
  
end;

Procedure DrawGameButtons();
var
  current_size: integer;
  current_color: Color;
  
begin
  current_size:= FontSize;
  current_color:= FontColor;
  
  SetBrushColor(clWhite);
  FillRectangle(width+line_size, 1, width + 200, height);
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(width + 30, round((1/24*height)), 'MENU');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '   Restart');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '   Solution');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, '      Exit');
  
  SetFontSize(current_size);
  SetFontColor(current_color);
  
end;

Procedure DrawConfirmButtons();
var
  current_size: integer;
  current_color: Color;
  
begin
  current_size:= FontSize;
  current_color:= FontColor;
  
  check_menu:= 4; // confirm
  
  SetBrushColor(clWhite);
  FillRectangle(width+line_size, 1, width + 200, height);
  
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(width + 25, round((1/24*height)), 'SURE?');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '      Yes');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '       No');
  
  
  SetFontSize(current_size);
  SetFontColor(current_color);
  
end;

// 'MAZE' and creator name
Procedure StartScreen();
begin
  check_menu:= 2; // others
  in_game:= false;
  SetBrushColor(clWhite);
  SetFontColor(clGray);
  SetFontSize(100);
  TextOut(round(width/3), round(height/3), 'MAZE');
  SetFontSize(20);
  TextOut(round(width/3)+3, round(height/3) + 140, 'Created by Alexey Anastasyev');
  DrawButtons();
  
end;

// Make right move
Procedure MoveRight(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x+cell_size,y);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x+cell_size,y);
    SetPlayer(x+cell_size, y);
    counter:= counter + 1;
  end;
    
end; // MoveRight

// Make left move
Procedure MoveLeft(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x-cell_size,y);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x-cell_size,y);
    SetPlayer(x-cell_size, y);
    counter:= counter + 1;
  end;
    
end; // MoveLeft

// Make up move
Procedure MoveUp(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x,y-cell_size);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x,y-cell_size);
    SetPlayer(x, y-cell_size);
    counter:= counter + 1;
  end;
  
end; // MoveUp

// Make down move
Procedure MoveDown(x: integer; y: integer);
var
  check_move: boolean; // Variable for check if the move is possible
  
Begin
  
  check_move:= CheckMove(x,y, x,y+cell_size);
  
  // Move if possible
  if (check_move=true)
  then
  begin
    DeletePlayer(x,y);
    DrawTrack(x,y, x,y+cell_size);
    SetPlayer(x, y+cell_size);
    counter:= counter + 1;
  end;
  
end; // MoveDown

// get name
procedure InputName(Key: integer);
var
  i: integer;
  str_help: string;
  
begin
  if (check)
  then
  case key of
    48..57, 65..90, 97..122: // Char keys
    begin
       if (length(str_inp)) < 16 then
       begin
         str_inp:= str_inp + chr(key);
         TextOut(round(width/3) + 180, round(height/3) + 200, str_inp); 
       end;
    end;
    8: // backspace
      begin
        str_help:= '';
        for i:= 1 to (length(str_inp)-1) do
          str_help:= str_help + str_inp[i];
        str_inp:= str_help;
        FillRectangle(round(width/3) + 180, round(height/3) + 200, width - 2*indent, round(height/3) + 230);
        TextOut(round(width/3) + 180, round(height/3) + 200, str_inp); 
      end;
  end;
 
end;

// get maze name
procedure InputMaze(Key: integer);
var
  i: integer;
  str_help: string;
  
begin
  SetFontColor(clBlack);
  SetFontSize(14);
  if (check)
  then
  case key of
    48..57, 65..90, 97..122: // Char keys
    begin
       if (length(str_inp)) < 16 then
       begin
         str_inp:= str_inp + chr(key);
         TextOut(button_x1, button_ok_y1 + 20, str_inp); 
       end;
        DrawBorderWalls();
        DrawFinish();
        SetBrushColor(clWhite);
        FillRectangle(button_x1, button5_y1, button_x2, button5_y2);
    end;
    8: // backspace
      begin
        str_help:= '';
        for i:= 1 to (length(str_inp)-1) do
          str_help:= str_help + str_inp[i];
        str_inp:= str_help;
        FillRectangle(button_x1, button_ok_y1 + 20, width + 200, button_ok_y2);
        TextOut(button_x1, button_ok_y1 + 20, str_inp); 
        
        DrawBorderWalls();
        DrawFinish();
        SetBrushColor(clWhite);
        FillRectangle(button_x1, button5_y1, button_x2, button5_y2);
      end;
  end;
 
end;

// After-game screen
Procedure Win();
Type
  player = record
    name: String;
    score: integer;
  end;
  
Var
  str: string;
  players: array[1..10] of player;
  helper: player;
  i: integer;
  v: integer;
  temps: string;
  tempint: integer;
  f,g: text;

Begin
  
  check_menu:= 2; // others
  in_game:= false;
  
  ClearWindow;
  SetFontColor(clGray);
  SetBrushColor(clWhite);
  SetFontSize(100);
  TextOut(round(width/3), round(height/3), 'WIN !!!');
  DrawButtons();
  SetFontSize(20);

  if (counter > 100000)
  then
  begin
    SetBrushColor(clWhite);
    FillRectangle(round(width/3), round(height/3), width, height);
    str:= 'You didn`t solve the maze by yourself';
    TextOut(round(width/3)-20, round(height/3) + 60, str);
  end

  else
  begin
    check_menu:= 9; // input name
    str:= '   Your score: ' + score;
    TextOut(round(width/3)+80, round(height/3) + 140, str);
    
    if (random_maze)
    then
    begin
    
      assign(f, 'src/highscores.txt');
      reset(f);
  
      for i:= 1 to 10 do
      begin
        readln(f, players[i].name);
        readln(f, players[i].score);
      end;
    
      close(f);
      
      repeat
  
        v:= 0;
        for i:= 1 to 9 do
        begin
          
          if (players[i].score < players[i+1].score)
          then
          begin
            helper.name:= players[i].name;
            helper.score:= players[i].score;
            
            players[i].name:= players[i+1].name;
            players[i].score:= players[i+1].score;
            
            players[i+1].name:= helper.name;
            players[i+1].score:= helper.score;
            
            v:= v + 1;
          end;
        
        end;
      until (v = 0);
    
    rewrite(f);
    for i:= 1 to 10 do  
    begin
      
      writeln(f, players[i].name);
      writeln(f, players[i].score);
      
    end;
    
    close(f);
  
    if (players[10].score < (score))
    then
    begin
      
      SetBrushColor(clWhite);
      FillRectangle(button_x1 - 2, button_menu_y1, width + 200, button5_y2 + 2);
      MakeSpecialButton(button_x1, button_ok_y1, button_x2, button_ok_y2, '  Confirm');
      
      
      //readln(name);
      TextOut(round(width/3) + 80, round(height/3) + 200, 'Name: ');
      check:= true;
      OnKeyDown:= InputName;
      assign(f, 'src/highscores.txt');
      reset(f);  
      assign(g, 'temp.txt');
      rewrite(g);
      
      for i:= 1 to 9 do
      begin
        
        readln(f, temps);
        writeln(g, temps);
        readln(f, tempint);
        writeln(g, tempint);
        
      end;
      close(g);
      close(f);
      
      str_inp:= '';
      
         
    end
    else
    begin
      TextOut(round(width/3) + 60, round(height/3) + 230, 'You don`t enter top-10');
      check_menu:= 2; // others
    end;
    end
    else
    begin
      TextOut(round(width/3) - 100, round(height/3) + 230, 'Only random maze score can be putted in highscores');
      check_menu:= 2; // others
    end;
  end; // else
  
  
  
  
end;

// Actions on tapping keys while playing
procedure GameKeyDown(key: integer);  
begin
    if not (win_checker)
    then
    begin
       case key of
         
         VK_Left: // Move left
            MoveLeft(PenX, PenY);
           
         VK_Right: // Move right
            MoveRight(PenX, PenY);
           
         VK_Up: // Move up
            MoveUp(PenX, PenY);
           
         VK_Down: // Move down
            MoveDown(PenX, PenY);
       
          
       end;
       
       SetFontSize(22);
       SetBrushColor(clWhite);
       SetPenColor(clBlack);
       if (counter < 100000)
       then
       begin
         SetFontColor(clBlack);
         SetFontSize(12);
         TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
        
         SetBrushColor(clWhite);
         SetFontSize(22);
         TextOut(width + 10, round((17/24)*height), 'MOVES: ');
         TextOut(width + 130, round((17/24)*height), IntToStr(counter))
       end
       else
       begin
         SetFontColor(clBlack);
         SetFontSize(12);
         TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
        
         SetBrushColor(clWhite);
         SetFontSize(22);
         TextOut(width + 10, round((17/24)*height), 'MOVES: ');
         TextOut(width + 130, round((17/24)*height), '-');
       end;
     
     // Check for win
    if ((PenX = finish_x) and (PenY = finish_y))
    then
    begin
       check_menu:= 8; // after game
       win_checker:= true;
       SetBrushColor(clWhite);
       FillRectangle(width + 10, round((17/24)*height), width + 200, height);
       
       SetFontSize(12);
       SetBrushColor(clWhite);
       SetPenColor(clBlack);
       if (counter < 100000)
       then
       begin
         SetFontColor(clBlack);
        
         SetBrushColor(clWhite);
         
         FillRectangle(button_x1 - 2, button_menu_y1, width + 200, button4_y2);
         
         SetFontSize(12);
                  
         FindPath(PenX, PenY);
         
         TextOut(width + 10, round((17/24)*height), 'YOUR MOVES: ');
         TextOut(width + 130, round((17/24)*height), IntToStr(counter - 1));
         
         TextOut(width + 10, round((18/24)*height), 'OPTIMAL MOVES: ');
         TextOut(width + 150, round((18/24)*height), IntToStr(optimal_solution_moves));
         
         score:= round((optimal_solution_moves/(counter - 1))*1000);
         
         TextOut(width + 10, round((19/24)*height), 'SCORE: ');
         TextOut(width + 90, round((19/24)*height), IntToStr(score));
         
       end
       else
       begin
         SetFontColor(clBlack);
        
         SetBrushColor(clWhite);
         SetFontSize(12);
         TextOut(width + 10, round((18/24)*height), 'OPTIMAL MOVES: ');
         TextOut(width + 150, round((18/24)*height), IntToStr(optimal_solution_moves));
       end;
     
     MakeSpecialButton(button_x1, button_ok_y1, button_x2, button_ok_y2, '       Ok');
       
      // Win();
    end;
  end; 
end; // GameKeyDown
  
// Main playing procedure
procedure PlayGame();
begin
  ClearWindow;
  
  SetBrushColor(clWhite);
  
  DrawGameButtons();
  in_game:= true;
  check_menu:= 1; // game
  GenerateMaze();
  counter:= 0;
  win_checker:= false;
  
  SetFontColor(clBlack);
  SetFontSize(12);
  TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
  
  SetBrushColor(clWhite);
  SetFontSize(22);
  TextOut(width + 10, round((17/24)*height), 'MOVES: ');
  TextOut(width + 130, round((17/24)*height), '0');

  
  // Set start position
  MoveTo(2*indent, 2*indent);
  SetPlayer(PenX, PenY);

  // Catch key tapping
  OnKeyDown:= GameKeyDown;
  
end;  // PlayGame

// Desribes the rules of the game
procedure Rules();
begin
  
  ClearWindow;
  
  in_game:= false;
  check_menu:= 2; // others
  
  SetFontSize(20);
  SetFontColor(clRed);
  TextOut(1, 0, 'About the game');
  SetFontSize(14);
  SetFontColor(clBlack);
  TextOut(1, 50, 'Your aim is to find the way out of maze. You can`t cross blue lines which are walls of the maze.');
  TextOut(1, 75, 'You always start from the top left cell.  Finish is always in the bottom right cell.');
  
  SetFontSize(20);
  SetFontColor(clRed);
  TextOut(1, 125, 'How to play');
  SetFontSize(14);
  SetFontColor(clBlack);
  TextOut(1, 175, 'You play as a red square. You can control it with arrows buttons to move right, left, up or down.');
  TextOut(1, 200, 'While playing you can tap "Solution" button to see the best way of solving the maze.');
  
  SetFontSize(20);
  SetFontColor(clRed);
  TextOut(1, 250, 'Score');
  SetFontSize(14);
  SetFontColor(clBlack);
  TextOut(1, 300, 'Every relocation increments your moves by 1. Try to solve the maze in as few moves as possible.');
  TextOut(1, 325, 'Score is counted as [ ( (optimal solution moves) / (your solution moves) ) * 1000 ]');
  TextOut(1, 350, 'If you managed to enter the top ten players, game will ask you to input your name and place it in ');
  TextOut(1, 375, 'high scores. You can view the high scores table in "High scores" section.');
  
  
  DrawButtons();
  
end;

// Highscores table
Procedure HighScores();
Type
  player = record
    name: String;
    score: integer;
  end;
  
Var
  f: text;
  s: string;
  pos: integer;
  sc: integer;
  i, j: integer;
  size: integer;
  v: integer;
  
  players: array[1..10] of player;
  helper: player;
  
Begin
  check_menu:= 2; // others
  in_game:= false;
  
  SetFontSize(30);
  SetFontColor(clRed);
  TextOut(round(width/2) - 100, 1, 'High scores');
  SetFontSize(26);
  SetFontColor(clBlue);
  TextOut(1, round(height*(2/24)), 'Position');
  TextOut(round(width/2) - 100, round(height*(2/24)), 'Name');
  TextOut(width - 200, round(height*(2/24)), 'Score');
  DrawButtons();
  
  assign(f, 'src/highscores.txt');
  
  reset(f);
  
  SetFontSize(20);
  SetFontColor(clBlack);
  for i:= 1 to 10 do
  begin
    readln(f, players[i].name);
    readln(f, players[i].score);
  end;
  
  close(f);
  

  repeat
  begin
    v:= 0;
    for i:= 1 to 9 do
    begin
      
      if (players[i].score < players[i+1].score)
      then
      begin
        helper.name:= players[i].name;
        helper.score:= players[i].score;
        
        players[i].name:= players[i+1].name;
        players[i].score:= players[i+1].score;
        
        players[i+1].name:= helper.name;
        players[i+1].score:= helper.score;
        
        v:= v + 1;
      end;
    
    end;
  end;
  until (v = 0);
  
  for i:= 1 to 10 do
    begin
      TextOut(1, round(height*((2*i+2)/24)), IntToStr(i));
      TextOut(round(width/2) - 100, round(height*((2*i+2)/24)), players[i].name);
      TextOut(width - 200, round(height*((2*i+2)/24)), IntToStr(players[i].score));
    end;
  
end;

// Action for button1
Procedure Action1();
Begin
  
  ClearWindow;
  PlayGame();
  
end;

// Action for button2
Procedure Action2();
Begin
  
  ClearWindow;
  Rules();
  
end;

// Action for button3
Procedure Action3();
Begin
  
  ClearWindow;
  HighScores();
  
end;

// Action for button4
Procedure Action4();
begin
  
  DrawConfirmButtons();
 // CloseWindow();  
  
end;

// Actions for 'menu' button
Procedure Action0();
begin
  
  ClearWindow;
  StartScreen();
  
end;

Procedure DrawUnactiveWalls();
var
  i,j: integer;
  
begin
  SetPixel(1,1, active);
  
  i:= indent;
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      

      
      SetPenWidth(line_size);
      SetPenColor(unactive);

      MoveTo(i,j);
      if (GetPixel(i, j + line_size) <> GetPixel(1,1))
      then
        LineTo(i,j+cell_size+1);
      MoveTo(i,j);
      
      SetPenWidth(line_size);
      SetPenColor(unactive);

      MoveTo(i, j);
      if (GetPixel(i + line_size, j) <> GetPixel(1,1))
      then
        LineTo(i+cell_size+1,j);
      MoveTo(i,j);
            
      if ((GetPixel(i - line_size, j) = GetPixel(1,1))
       or (GetPixel(i + line_size, j) = GetPixel(1,1))
       or (GetPixel(i, j - line_size) = GetPixel(1,1))
       or (GetPixel(i, j + line_size) = GetPixel(1,1)))
      then
      begin
        SetBrushColor(active);
        SetPenColor(active);
        SetPixel(i,j,active);
        
        FillRectangle(i - 1, j - 1, i + 2, j + 2);        
      end;
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
  SetBrushColor(clWhite);  
  
end;

Procedure WallAction(x, y: integer; horizontal: boolean);
begin
  
  SetPixel(1,1, active);
  
  if ((horizontal) and (GetPixel(x + 5,y) = GetPixel(1,1)))
  then
    SetPenColor(unactive);
  
  if ((horizontal) and (GetPixel(x + 5,y) <> GetPixel(1,1)))
  then
    SetPenColor(active);
  
  if (not(horizontal) and (GetPixel(x,y + 5) = GetPixel(1,1)))
  then
    SetPenColor(unactive);
  
  if (not(horizontal) and (GetPixel(x,y + 5) <> GetPixel(1,1)))
  then
    SetPenColor(active);
  
  SetPenWidth(line_size);
  MoveTo(x,y);
  
  if (horizontal)
  then
    LineTo(x + cell_size, y)
  else
    LineTo(x, y + cell_size);
  
  DrawBorderWalls();
  DrawFinish();
  SetBrushColor(clWhite);
  FillRectangle(button_x1, button5_y1, button_x2, button5_y2);
  
end;

Procedure RemoveUnactive();
var
  i,j: integer;
  
begin
   
  i:= indent;
  while (i < width - indent) do
  begin
    
    j:= indent;
    
    while (j < height - indent) do
    begin
      SetPixel(1,1, unactive);
      SetPixel(1,2, active);
      if (GetPixel(i + line_size,j) = GetPixel(1,1))
      then
      begin
        SetPenWidth(line_size);
        SetPenColor(clWhite);
        MoveTo(i, j);
        LineTo(i + cell_size, j);       
        MoveTo(i, j);
      end;
      if (GetPixel(i,j+line_size) = GetPixel(1,1))
      then
      begin
        SetPenWidth(line_size);
        SetPenColor(clWhite);
        MoveTo(i, j);
        LineTo(i, j + cell_size);
        MoveTo(i, j);
      end;
      
      if ((GetPixel(i - line_size, j) = GetPixel(1,2))
       or (GetPixel(i + line_size, j) = GetPixel(1,2))
       or (GetPixel(i, j - line_size) = GetPixel(1,2))
       or (GetPixel(i, j + line_size) = GetPixel(1,2)))
      then
      begin
        SetBrushColor(active);
        SetPenColor(active);
        SetPixel(i,j,active);
        
        FillRectangle(i - 1, j - 1, i + 2, j + 2);        
      end;
      
      j:= j + cell_size;
    end;
  
  i:= i + cell_size;
  
  end;
  
   
  
  DrawBorderWalls();
  DrawFinish();
  
  SetBrushColor(clWhite);
  
end;

Procedure DrawInputMenu();
Begin
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(width + 30, round((1/24*height)), 'MENU');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '     Save');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '   Discard');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, '      Exit');
                    
end;

Procedure StartInput();
begin
  
  ClearWindow;
  DrawInputMenu();
  
  SetFontColor(clBlack);
  SetFontSize(14);
  TextOut(button_x1, button_ok_y1, 'Maze name:');
  TextOut(button_x1, button_ok_y1 + 20, str_inp);
  
  action:= 0; // input menu
  
  DrawUnactiveWalls();
  SetPlayer(2*indent, 2*indent);
  DrawBorderWalls;
  DrawFinish();
  
end;

Function IsSolvable(): boolean;
var
  i: integer;
  local_number: integer;
  finish: boolean;
  live: integer;
  to_exit: boolean;
  
begin
  
  number:= 1;
  RemoveUnactive;
  points[1].x := 2*indent;
  points[1].y := 2*indent;
  live:= 1;
  
  finish:= false;
  while not(finish) do
  begin
    
    local_number:= number;
    for i:= (local_number - live + 1) to local_number do
    begin
      PaveWay(points[i].x, points[i].y);

      if (checker[1] = true) // Right
      then 
        begin
          number:= number + 1;
          points[number].x := points[i].x + cell_size;
          points[number].y := points[i].y;
          live:= live + 1;
          checker[1] := false;
        end;
      if (checker[2] = true) // Left
      then
        begin
          number:= number + 1;
          points[number].x := points[i].x - cell_size;
          points[number].y := points[i].y;
          live:= live + 1;
          checker[2] := false;
        end;
      if (checker[3] = true) // Up
      then
        begin
          number:= number + 1;
          points[number].x := points[i].x;
          points[number].y := points[i].y - cell_size;
          live:= live + 1;
          checker[3] := false;
        end;
      if (checker[4] = true) // Down
      then  
        begin
          number:= number + 1;
          points[number].x := points[i].x;
          points[number].y := points[i].y + cell_size;
          live:= live + 1;
          checker[4] := false;
        end;
        
      if ((checker[1] = false) and (checker[2] = false) and (checker[3] = false) and (checker[4] = false))
      then
        live:= live - 1;
      
    end;
    finish:= CheckFinish();
    if (live = 0)
    then
    begin
      IsSolvable:= false;
      to_exit:= true;
      RemoveTrack;
      break;
    end;
  end; 
  
  if not(to_exit)
  then
    IsSolvable:= true;
  RemoveTrack;
  
end;

// Catch mouse down
Procedure MenuMouseDown(x, y, mousebutton: integer);
var
  f, g: text;
  i: integer;
  temps: string;
  tempint: integer;
  str_help: string;
  x_start: integer;
  y_start: integer;
  horizontal: boolean;
  vertical: boolean;
  
  uniq: boolean;
  maze_amount: byte;
  names: array[1..100] of string;
  
begin
  
  if (input_menu)
  then
  begin
  
  SetFontColor(clBlack);
  SetFontSize(14);
  TextOut(button_x1, button_ok_y1, 'Maze name:');
  
  if ((x > button_x1) and (x < button_x2) and (mousebutton = 1))
  then
  begin
    
    case action of
    0: // input menu
      begin
        
        if (y > button1_y1) and (y < button1_y2)
        then
        begin
          
          if (str_inp <> '')
          then
          begin
            uniq:= true;
            assign(f, 'src/mazes/maze_list.txt');
            reset(f);
            
            assign(g, 'src/mazes/maze_amount.txt');
            reset(g);
            readln(g, maze_amount);
            close(g);
            
            i:= 1;
            while (i <= maze_amount) do
            begin
              
              readln(f, names[i]);
              if (names[i] = str_inp)
              then
              begin
                SetFontColor(clRed);
                SetFontSize(12);
                TextOut(button_x1, button5_y1, 'You already have');
                TextOut(button_x1, button5_y1 + 20, 'maze with this name');
                uniq:= false;
                break;
              end;
              
              i:= i + 1;
              
            end;
            
            close(f);
            
            if (uniq)
            then
            begin
              DrawConfirmButtons();
              action:= 1; // save
              SetFontColor(clBlack);
              SetFontSize(14);
              TextOut(button_x1, button_ok_y1, 'Maze name:');
              TextOut(button_x1, button_ok_y1 + 20, str_inp);
            end;
            
          end
          else
          begin
            SetFontColor(clRed);
            SetFontSize(12);
            TextOut(button_x1, button5_y1, 'Input maze name !');
          end;
        end;
              
        if (y > button2_y1) and (y < button2_y2)
        then
        begin
          action:= 2; // discard
          DrawConfirmButtons();
        end;
              
        if (y > button3_y1) and (y < button3_y2)
        then
        begin
          action:= 4; // exit
          DrawConfirmButtons();
        end;
              
        if (y > button_menu_y1) and (y < button_menu_y2)
        then
        begin
          action:= 3; // main menu
          DrawConfirmButtons();
        end;
      end;
    
    1: // confirm save
      begin
                
        if ((y > button1_y1) and (y < button1_y2)) // yes
        then
        begin
          
          RemoveUnactive;
          if (IsSolvable)
          then
          begin
            
            SaveWindow('src/mazes/' + str_inp);
            assign(f, 'src/mazes/maze_list.txt');
            append(f);
            writeln(f, str_inp);
            close(f);
            
            assign(g, 'src/mazes/maze_amount.txt');
            reset(g);
            readln(g, maze_amount);
            close(g);
            rewrite(g);
            writeln(g, maze_amount + 1);
            close(g);
            
            str_inp:= '';
            FillRectangle(width + indent, 0, width + 200, 200);
            DrawInputMenu();
            action:= 0; // input menu
            input_menu:= false;
            Action0;
            
          end
          else
          begin

            SetFontColor(clRed);
            SetFontSize(12);
            TextOut(button_x1, button5_y1, 'The maze isn`t solvable');
            FillRectangle(width + indent, 0, width + 200, 200);
            DrawInputMenu();
            SetFontColor(clBlack);
            SetFontSize(14);
            TextOut(button_x1, button_ok_y1, 'Maze name:');
            TextOut(button_x1, button_ok_y1 + 20, str_inp);
            SetPlayer(2*indent, 2*indent);
            DrawUnactiveWalls;
            DrawBorderWalls;
            DrawFinish;
            action:= 0; // input menu
            input_menu:= true;
            
          end;
                    
        end;
        
        if ((y > button2_y1) and (y < button2_y2)) // no
        then
        begin
          SetBrushColor(clWhite);
          FillRectangle(width + indent, 0, width + 200, 200);
          DrawInputMenu();
          action:= 0; // input menu
        end;
        
      end;
      
    2: // confirm discard
      begin
        
        if ((y > button1_y1) and (y < button1_y2)) // yes
        then
        begin
          ClearWindow;
          DrawInputMenu();
          
          action:= 0; // input menu
          
          DrawUnactiveWalls();
          SetPlayer(2*indent, 2*indent);
          DrawBorderWalls;
          DrawFinish();
        end;
        
        if ((y > button2_y1) and (y < button2_y2)) // no
        then
        begin
          FillRectangle(width + indent, 0, width + 200, 200);
          DrawInputMenu();
          action:= 0; // input menu
        end;
        
      end;
      
    3: // confirm main menu
      begin
        if ((y > button1_y1) and (y < button1_y2)) // yes
        then
        begin
          input_menu:= false;
          Action0;
        end;
        
        if ((y > button2_y1) and (y < button2_y2)) // no
        then
        begin
          FillRectangle(width + indent, 0, width + 200, 200);
          DrawInputMenu();
          action:= 0; // input menu
        end;
      end;
      
    4: // confirm exit
      begin
        
        if ((y > button1_y1) and (y < button1_y2)) // yes
        then
        begin
          CloseWindow;
        end;
        
        if ((y > button2_y1) and (y < button2_y2)) // no
        then
        begin
          FillRectangle(width + indent, 0, width + 200, 200);
          DrawInputMenu();
          action:= 0; // input menu
        end;
        
      end;
        
     end; // case
  end
  
  else
  begin
  
  if (mousebutton = 1)
  then
  begin
    
    x_start:= 0;
    y_start:= 0;
    
    case x of
      
      (indent + line_size + 1)..(indent + cell_size - line_size): // 1
      begin
        x_start:= indent + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + cell_size + 1)..(indent + 2*cell_size - line_size): // 2
      begin
        x_start:= indent + cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 2*cell_size + 1)..(indent + 3*cell_size - line_size): // 3
      begin
        x_start:= indent + 2*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 3*cell_size + 1)..(indent + 4*cell_size - line_size): // 4
      begin
        x_start:= indent + 3*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 4*cell_size + 1)..(indent + 5*cell_size - line_size): // 5
      begin
        x_start:= indent + 4*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 5*cell_size + 1)..(indent + 6*cell_size - line_size): // 6
      begin
        x_start:= indent + 5*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 6*cell_size + 1)..(indent + 7*cell_size - line_size): // 7
      begin
        x_start:= indent + 6*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 7*cell_size + 1)..(indent + 8*cell_size - line_size): // 8
      begin
        x_start:= indent + 7*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 8*cell_size + 1)..(indent + 9*cell_size - line_size): // 9
      begin
        x_start:= indent + 8*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 9*cell_size + 1)..(indent + 10*cell_size - line_size): // 10
      begin
        x_start:= indent + 9*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 10*cell_size + 1)..(indent + 11*cell_size - line_size): // 11
      begin
        x_start:= indent + 10*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 11*cell_size + 1)..(indent + 12*cell_size - line_size): // 12
      begin
        x_start:= indent + 11*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 12*cell_size + 1)..(indent + 13*cell_size - line_size): // 13
      begin
        x_start:= indent + 12*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 13*cell_size + 1)..(indent + 14*cell_size - line_size): // 14
      begin
        x_start:= indent + 13*cell_size + 1;
        horizontal:= true;
      end;
            
      (indent + line_size + 14*cell_size + 1)..(indent + 15*cell_size - line_size): // 15
      begin
        x_start:= indent + 14*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 15*cell_size + 1)..(indent + 16*cell_size - line_size): // 16
      begin
        x_start:= indent + 15*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 16*cell_size + 1)..(indent + 17*cell_size - line_size): // 17
      begin
        x_start:= indent + 16*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 17*cell_size + 1)..(indent + 18*cell_size - line_size): // 18
      begin
        x_start:= indent + 17*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 18*cell_size + 1)..(indent + 19*cell_size - line_size): // 19
      begin
        x_start:= indent + 18*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 19*cell_size + 1)..(indent + 20*cell_size - line_size): // 20
      begin
        x_start:= indent + 19*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 20*cell_size + 1)..(indent + 21*cell_size - line_size): // 21
      begin
        x_start:= indent + 20*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 21*cell_size + 1)..(indent + 22*cell_size - line_size): // 22
      begin
        x_start:= indent + 21*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 22*cell_size + 1)..(indent + 23*cell_size - line_size): // 23
      begin
        x_start:= indent + 22*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 23*cell_size + 1)..(indent + 24*cell_size - line_size): // 24
      begin
        x_start:= indent + 23*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 24*cell_size + 1)..(indent + 25*cell_size - line_size): // 25
      begin
        x_start:= indent + 24*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 25*cell_size + 1)..(indent + 26*cell_size - line_size): // 26
      begin
        x_start:= indent + 25*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 26*cell_size + 1)..(indent + 27*cell_size - line_size): // 27
      begin
        x_start:= indent + 26*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 27*cell_size + 1)..(indent + 28*cell_size - line_size): // 28
      begin
        x_start:= indent + 27*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 28*cell_size + 1)..(indent + 29*cell_size - line_size): // 29
      begin
        x_start:= indent + 28*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 29*cell_size + 1)..(indent + 30*cell_size - line_size): // 30
      begin
        x_start:= indent + 29*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 30*cell_size + 1)..(indent + 31*cell_size - line_size): // 31
      begin
        x_start:= indent + 30*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 31*cell_size + 1)..(indent + 32*cell_size - line_size): // 32
      begin
        x_start:= indent + 31*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 32*cell_size + 1)..(indent + 33*cell_size - line_size): // 33
      begin
        x_start:= indent + 32*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 33*cell_size + 1)..(indent + 34*cell_size - line_size): // 34
      begin
        x_start:= indent + 33*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 34*cell_size + 1)..(indent + 35*cell_size - line_size): // 35
      begin
        x_start:= indent + 34*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 35*cell_size + 1)..(indent + 36*cell_size - line_size): // 36
      begin
        x_start:= indent + 35*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 36*cell_size + 1)..(indent + 37*cell_size - line_size): // 37
      begin
        x_start:= indent + 36*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 37*cell_size + 1)..(indent + 38*cell_size - line_size): // 38
      begin
        x_start:= indent + 37*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 38*cell_size + 1)..(indent + 39*cell_size - line_size): // 39
      begin
        x_start:= indent + 38*cell_size + 1;
        horizontal:= true;
      end;
      
      (indent + line_size + 39*cell_size + 1)..(indent + 40*cell_size - line_size): // 40
      begin
        x_start:= indent + 39*cell_size + 1;
        horizontal:= true;
      end;
      
      //-----------------------------------------------------------------------------------------
      
      (indent + cell_size)..(indent + cell_size + line_size): // 1-2
      begin
        x_start:= indent + cell_size;
        horizontal:= false;
      end;
      
      (indent + 2*cell_size)..(indent + 2*cell_size + line_size): // 2-3
      begin
        x_start:= indent + 2*cell_size;
        horizontal:= false;
      end;
  
      (indent + 3*cell_size)..(indent + 3*cell_size + line_size): // 3-4
      begin
        x_start:= indent + 3*cell_size;
        horizontal:= false;
      end;

      (indent + 4*cell_size)..(indent + 4*cell_size + line_size): // 4-5
      begin
        x_start:= indent + 4*cell_size;
        horizontal:= false;
      end;

      (indent + 5*cell_size)..(indent + 5*cell_size + line_size): // 5-6
      begin
        x_start:= indent + 5*cell_size;
        horizontal:= false;
      end;
      
      (indent + 6*cell_size)..(indent + 6*cell_size + line_size): // 6-7
      begin
        x_start:= indent + 6*cell_size;
        horizontal:= false;
      end;
      
      (indent + 7*cell_size)..(indent + 7*cell_size + line_size): // 7-8
      begin
        x_start:= indent + 7*cell_size;
        horizontal:= false;
      end;
      
      (indent + 8*cell_size)..(indent + 8*cell_size + line_size): // 8-9
      begin
        x_start:= indent + 8*cell_size;
        horizontal:= false;
      end;
      
      (indent + 9*cell_size)..(indent + 9*cell_size + line_size): // 9-10
      begin
        x_start:= indent + 9*cell_size;
        horizontal:= false;
      end;
      
      (indent + 10*cell_size)..(indent + 10*cell_size + line_size): // 10-11
      begin
        x_start:= indent + 10*cell_size;
        horizontal:= false;
      end;
      
      (indent + 11*cell_size)..(indent + 11*cell_size + line_size): // 11-12
      begin
        x_start:= indent + 11*cell_size;
        horizontal:= false;
      end;
      
      (indent + 12*cell_size)..(indent + 12*cell_size + line_size): // 12-13
      begin
        x_start:= indent + 12*cell_size;
        horizontal:= false;
      end;
      
      (indent + 13*cell_size)..(indent + 13*cell_size + line_size): // 13-14
      begin
        x_start:= indent + 13*cell_size;
        horizontal:= false;
      end;
      
      (indent + 14*cell_size)..(indent + 14*cell_size + line_size): // 14-15
      begin
        x_start:= indent + 14*cell_size;
        horizontal:= false;
      end;
      
      (indent + 15*cell_size)..(indent + 15*cell_size + line_size): // 15-16
      begin
        x_start:= indent + 15*cell_size;
        horizontal:= false;
      end;
      
      (indent + 16*cell_size)..(indent + 16*cell_size + line_size): // 16-17
      begin
        x_start:= indent + 16*cell_size;
        horizontal:= false;
      end;
      
      (indent + 17*cell_size)..(indent + 17*cell_size + line_size): // 17-18
      begin
        x_start:= indent + 17*cell_size;
        horizontal:= false;
      end;
      
      (indent + 18*cell_size)..(indent + 18*cell_size + line_size): // 18-19
      begin
        x_start:= indent + 18*cell_size;
        horizontal:= false;
      end;
      
      (indent + 19*cell_size)..(indent + 19*cell_size + line_size): // 19-20
      begin
        x_start:= indent + 19*cell_size;
        horizontal:= false;
      end;
      
      (indent + 20*cell_size)..(indent + 20*cell_size + line_size): // 20-21
      begin
        x_start:= indent + 20*cell_size;
        horizontal:= false;
      end;
      
      (indent + 21*cell_size)..(indent + 21*cell_size + line_size): // 21-22
      begin
        x_start:= indent + 21*cell_size;
        horizontal:= false;
      end;
      
      (indent + 22*cell_size)..(indent + 22*cell_size + line_size): // 22-23
      begin
        x_start:= indent + 22*cell_size;
        horizontal:= false;
      end;
      
      (indent + 23*cell_size)..(indent + 23*cell_size + line_size): // 23-24
      begin
        x_start:= indent + 23*cell_size;
        horizontal:= false;
      end;
      
      (indent + 24*cell_size)..(indent + 24*cell_size + line_size): // 24-25
      begin
        x_start:= indent + 24*cell_size;
        horizontal:= false;
      end;
      
      (indent + 25*cell_size)..(indent + 25*cell_size + line_size): // 25-26
      begin
        x_start:= indent + 25*cell_size;
        horizontal:= false;
      end;
      
      (indent + 26*cell_size)..(indent + 26*cell_size + line_size): // 26-27
      begin
        x_start:= indent + 26*cell_size;
        horizontal:= false;
      end;
      
      (indent + 27*cell_size)..(indent + 27*cell_size + line_size): // 27-28
      begin
        x_start:= indent + 27*cell_size;
        horizontal:= false;
      end;
      
      (indent + 28*cell_size)..(indent + 28*cell_size + line_size): // 28-29
      begin
        x_start:= indent + 28*cell_size;
        horizontal:= false;
      end;
      
      (indent + 29*cell_size)..(indent + 29*cell_size + line_size): // 29-30
      begin
        x_start:= indent + 29*cell_size;
        horizontal:= false;
      end;
      
      (indent + 30*cell_size)..(indent + 30*cell_size + line_size): // 30-31
      begin
        x_start:= indent + 30*cell_size;
        horizontal:= false;
      end;
      
      (indent + 31*cell_size)..(indent + 31*cell_size + line_size): // 31-32
      begin
        x_start:= indent + 31*cell_size;
        horizontal:= false;
      end;
      
      (indent + 32*cell_size)..(indent + 32*cell_size + line_size): // 32-33
      begin
        x_start:= indent + 32*cell_size;
        horizontal:= false;
      end;
      
      (indent + 33*cell_size)..(indent + 33*cell_size + line_size): // 33-34
      begin
        x_start:= indent + 33*cell_size;
        horizontal:= false;
      end;
      
      (indent + 34*cell_size)..(indent + 34*cell_size + line_size): // 34-35
      begin
        x_start:= indent + 34*cell_size;
        horizontal:= false;
      end;
      
      (indent + 35*cell_size)..(indent + 35*cell_size + line_size): // 35-36
      begin
        x_start:= indent + 35*cell_size;
        horizontal:= false;
      end;
      
      (indent + 36*cell_size)..(indent + 36*cell_size + line_size): // 36-37
      begin
        x_start:= indent + 36*cell_size;
        horizontal:= false;
      end;
      
      (indent + 37*cell_size)..(indent + 37*cell_size + line_size): // 37-38
      begin
        x_start:= indent + 37*cell_size;
        horizontal:= false;
      end;
      
      (indent + 38*cell_size)..(indent + 38*cell_size + line_size): // 38-39
      begin
        x_start:= indent + 38*cell_size;
        horizontal:= false;
      end;
      
      (indent + 39*cell_size)..(indent + 39*cell_size + line_size): // 39-40
      begin
        x_start:= indent + 39*cell_size;
        horizontal:= false;
      end;
      
      else
        x_start:= 0;
      
    end;
    
    // -------------------------------------------------------------------------
    
    case y of
      
      (indent + line_size)..(indent + cell_size - line_size): // 1
      begin
        y_start:= indent + 1;
        vertical:= true;
      end;
      
      (indent + line_size + cell_size + 1)..(indent + 2*cell_size - line_size): // 2
      begin
        y_start := indent + cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 2*cell_size + 1)..(indent + 3*cell_size - line_size): // 3
      begin
        y_start := indent + 2*cell_size + 1;
        vertical:= true;
      end;
      
           (indent + line_size + 3*cell_size + 1)..(indent + 4*cell_size - line_size): // 4
      begin
        y_start:= indent + 3*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 4*cell_size + 1)..(indent + 5*cell_size - line_size): // 5
      begin
        y_start:= indent + 4*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 5*cell_size + 1)..(indent + 6*cell_size - line_size): // 6
      begin
        y_start:= indent + 5*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 6*cell_size + 1)..(indent + 7*cell_size - line_size): // 7
      begin
        y_start:= indent + 6*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 7*cell_size + 1)..(indent + 8*cell_size - line_size): // 8
      begin
        y_start:= indent + 7*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 8*cell_size + 1)..(indent + 9*cell_size - line_size): // 9
      begin
        y_start:= indent + 8*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 9*cell_size + 1)..(indent + 10*cell_size - line_size): // 10
      begin
        y_start:= indent + 9*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 10*cell_size + 1)..(indent + 11*cell_size - line_size): // 11
      begin
        y_start:= indent + 10*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 11*cell_size + 1)..(indent + 12*cell_size - line_size): // 12
      begin
        y_start:= indent + 11*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 12*cell_size + 1)..(indent + 13*cell_size - line_size): // 13
      begin
        y_start:= indent + 12*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 13*cell_size + 1)..(indent + 14*cell_size - line_size): // 14
      begin
        y_start:= indent + 13*cell_size + 1;
        vertical:= true;
      end;
            
      (indent + line_size + 14*cell_size + 1)..(indent + 15*cell_size - line_size): // 15
      begin
        y_start:= indent + 14*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 15*cell_size + 1)..(indent + 16*cell_size - line_size): // 16
      begin
        y_start:= indent + 15*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 16*cell_size + 1)..(indent + 17*cell_size - line_size): // 17
      begin
        y_start:= indent + 16*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 17*cell_size + 1)..(indent + 18*cell_size - line_size): // 18
      begin
        y_start:= indent + 17*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 18*cell_size + 1)..(indent + 19*cell_size - line_size): // 19
      begin
        y_start:= indent + 18*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 19*cell_size + 1)..(indent + 20*cell_size - line_size): // 20
      begin
        y_start:= indent + 19*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 20*cell_size + 1)..(indent + 21*cell_size - line_size): // 21
      begin
        y_start:= indent + 20*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 21*cell_size + 1)..(indent + 22*cell_size - line_size): // 22
      begin
        y_start:= indent + 21*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 22*cell_size + 1)..(indent + 23*cell_size - line_size): // 23
      begin
        y_start:= indent + 22*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 23*cell_size + 1)..(indent + 24*cell_size - line_size): // 24
      begin
        y_start:= indent + 23*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 24*cell_size + 1)..(indent + 25*cell_size - line_size): // 25
      begin
        y_start:= indent + 24*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 25*cell_size + 1)..(indent + 26*cell_size - line_size): // 26
      begin
        y_start:= indent + 25*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 26*cell_size + 1)..(indent + 27*cell_size - line_size): // 27
      begin
        y_start:= indent + 26*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 27*cell_size + 1)..(indent + 28*cell_size - line_size): // 28
      begin
        y_start:= indent + 27*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 28*cell_size + 1)..(indent + 29*cell_size - line_size): // 29
      begin
        y_start:= indent + 28*cell_size + 1;
        vertical:= true;
      end;
      
      (indent + line_size + 29*cell_size + 1)..(indent + 30*cell_size - line_size): // 30
      begin
        y_start:= indent + 29*cell_size + 1;
        vertical:= true;
      end;

      
      //----------------------------------------------------------------------
      
      
      (indent + cell_size)..(indent + cell_size + line_size): // 1-2
      begin
        y_start:= indent + cell_size;
        vertical:= false;
      end;
             
      (indent + 2*cell_size)..(indent + 2*cell_size + line_size): // 2-3
      begin
        y_start:= indent + 2*cell_size;
        vertical:= false;
      end;
   
      (indent + 3*cell_size)..(indent + 3*cell_size + line_size): // 3-4
      begin
        y_start:= indent + 3*cell_size;
        vertical:= false;
      end;
      
           (indent + 4*cell_size)..(indent + 4*cell_size + line_size): // 4-5
      begin
        y_start:= indent + 4*cell_size;
        vertical:= false;
      end;

      (indent + 5*cell_size)..(indent + 5*cell_size + line_size): // 5-6
      begin
        y_start:= indent + 5*cell_size;
        vertical:= false;
      end;
      
      (indent + 6*cell_size)..(indent + 6*cell_size + line_size): // 6-7
      begin
        y_start:= indent + 6*cell_size;
        vertical:= false;
      end;
      
      (indent + 7*cell_size)..(indent + 7*cell_size + line_size): // 7-8
      begin
        y_start:= indent + 7*cell_size;
        vertical:= false;
      end;
      
      (indent + 8*cell_size)..(indent + 8*cell_size + line_size): // 8-9
      begin
        y_start:= indent + 8*cell_size;
        vertical:= false;
      end;
      
      (indent + 9*cell_size)..(indent + 9*cell_size + line_size): // 9-10
      begin
        y_start:= indent + 9*cell_size;
        vertical:= false;
      end;
      
      (indent + 10*cell_size)..(indent + 10*cell_size + line_size): // 10-11
      begin
        y_start:= indent + 10*cell_size;
        vertical:= false;
      end;
      
      (indent + 11*cell_size)..(indent + 11*cell_size + line_size): // 11-12
      begin
        y_start:= indent + 11*cell_size;
        vertical:= false;
      end;
      
      (indent + 12*cell_size)..(indent + 12*cell_size + line_size): // 12-13
      begin
        y_start:= indent + 12*cell_size;
        vertical:= false;
      end;
      
      (indent + 13*cell_size)..(indent + 13*cell_size + line_size): // 13-14
      begin
        y_start:= indent + 13*cell_size;
        vertical:= false;
      end;
      
      (indent + 14*cell_size)..(indent + 14*cell_size + line_size): // 14-15
      begin
        y_start:= indent + 14*cell_size;
        vertical:= false;
      end;
      
      (indent + 15*cell_size)..(indent + 15*cell_size + line_size): // 15-16
      begin
        y_start:= indent + 15*cell_size;
        vertical:= false;
      end;
      
      (indent + 16*cell_size)..(indent + 16*cell_size + line_size): // 16-17
      begin
        y_start:= indent + 16*cell_size;
        vertical:= false;
      end;
      
      (indent + 17*cell_size)..(indent + 17*cell_size + line_size): // 17-18
      begin
        y_start:= indent + 17*cell_size;
        vertical:= false;
      end;
      
      (indent + 18*cell_size)..(indent + 18*cell_size + line_size): // 18-19
      begin
        y_start:= indent + 18*cell_size;
        vertical:= false;
      end;
      
      (indent + 19*cell_size)..(indent + 19*cell_size + line_size): // 19-20
      begin
        y_start:= indent + 19*cell_size;
        vertical:= false;
      end;
      
      (indent + 20*cell_size)..(indent + 20*cell_size + line_size): // 20-21
      begin
        y_start:= indent + 20*cell_size;
        vertical:= false;
      end;
      
      (indent + 21*cell_size)..(indent + 21*cell_size + line_size): // 21-22
      begin
        y_start:= indent + 21*cell_size;
        vertical:= false;
      end;
      
      (indent + 22*cell_size)..(indent + 22*cell_size + line_size): // 22-23
      begin
        y_start:= indent + 22*cell_size;
        vertical:= false;
      end;
      
      (indent + 23*cell_size)..(indent + 23*cell_size + line_size): // 23-24
      begin
        y_start:= indent + 23*cell_size;
        vertical:= false;
      end;
      
      (indent + 24*cell_size)..(indent + 24*cell_size + line_size): // 24-25
      begin
        y_start:= indent + 24*cell_size;
        vertical:= false;
      end;
      
      (indent + 25*cell_size)..(indent + 25*cell_size + line_size): // 25-26
      begin
        y_start:= indent + 25*cell_size;
        vertical:= false;
      end;
      
      (indent + 26*cell_size)..(indent + 26*cell_size + line_size): // 26-27
      begin
        y_start:= indent + 26*cell_size;
        vertical:= false;
      end;
      
      (indent + 27*cell_size)..(indent + 27*cell_size + line_size): // 27-28
      begin
        y_start:= indent + 27*cell_size;
        vertical:= false;
      end;
      
      (indent + 28*cell_size)..(indent + 28*cell_size + line_size): // 28-29
      begin
        y_start:= indent + 28*cell_size;
        vertical:= false;
      end;
      
      (indent + 29*cell_size)..(indent + 29*cell_size + line_size): // 29-30
      begin
        y_start:= indent + 29*cell_size;
        vertical:= false;
      end;

      
      else
        y_start:= 0;
      
    end;
    
    if ((x_start <> 0) and (y_start <> 0) and not(horizontal and vertical) and (horizontal or vertical))
    then
      WallAction(x_start, y_start, horizontal);
  end;
  end;
  end
  
  else
  begin
  
  case check_menu of
  2: // others  
    begin
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2)) 
        then
        begin
          
          if ((y > button1_y1) and (y < button1_y2)) // Start
          then
          begin
            check_menu:= 10; // choose mode
            
            SetBrushColor(clWhite);
            FillRectangle(width+line_size, 1, width + 200, height);
            
            SetFontSize(30);
            SetFontColor(clLightGreen);
            TextOut(width + 30, round((1/24*height)), 'MENU');
            
            
            MakeSpecialButton(button_x1, button1_y1, 
                              button_x2, button1_y2, '   Random');
                              
            MakeSpecialButton(button_x1, button2_y1, 
                              button_x2, button2_y2, ' Load maze');
          end;
          
          if ((y > button2_y1) and (y < button2_y2)) // Create maze
          then
          begin
            input_menu:= true;
            str_inp:= '';
            OnKeyDown:= InputMaze;
            check:= true;
            StartInput();
          end;
          
          if ((y > button3_y1) and (y < button3_y2)) // How to play
          then
            Action2();
          
          if ((y > button4_y1) and (y < button4_y2)) // High scores
          then
            Action3();
          
          if ((y > button5_y1) and (y < button5_y2)) // Exit
          then
            Action4();
          
          if ((y > button_menu_y1) and (y < button_menu_y2)) // Menu
          then
            Action0();
          
        end;
    end;
  1: // game  
    begin
      
      // mousedown in game
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2)) 
        then
        begin
          
          if ((y > button1_y1) and (y < button1_y2)) // Retart
          then
          begin
            DrawConfirmButtons();
            check_menu:= 5; // restart
          end;
          
          if ((y > button2_y1) and (y < button2_y2)) // Find solution
          then
          begin
            DrawConfirmButtons();
            check_menu:= 6; // solution
              
          end;
          
          if ((y > button3_y1) and (y < button3_y2)) // Exit
          then
            Action4();
          
          if ((y > button_menu_y1) and (y < button_menu_y2)) // Menu
          then
          begin
            DrawConfirmButtons();
            check_menu:= 7; // confirm menu
              
          end;
          
        end;
    end;
    
  
  4: // confirm exit
    if (mousebutton = 1)
      then
        begin
          if ((x > button_x1) and (x < button_x2))
          then
          begin
            
             if ((y > button1_y1) and (y < button1_y2)) // Yes
             then
                CloseWindow;
            
            if ((y > button2_y1) and (y < button2_y2)) // No
            then
            begin
              check_menu:= 2; // others
              if (in_game)
              then
              begin
                check_menu:= 1; // game
                DrawGameButtons();
                if (counter < 100000)
                 then
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), IntToStr(counter))
                 end
                 else
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), '0');
                 end;
              end
              else
                DrawButtons();

            end;
          end;
        end;
    5: // confirm restart
      begin
        if (mousebutton = 1)
        then
        begin
          if ((x > button_x1) and (x < button_x2))
          then
          begin
            
             if ((y > button1_y1) and (y < button1_y2)) // Yes
             then
               if (random_maze)
               then
                 Action1
               else
               begin
                 DeletePlayer(PenX, PenY);
                 RemoveTrack;
                 SetPlayer(2*indent, 2*indent);
                 counter:= 0;
                 DrawGameButtons;
                 SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), '0');
               end;
            
            if ((y > button2_y1) and (y < button2_y2)) // No
            then
            begin
                check_menu:= 1; // game
                DrawGameButtons();
                if (counter < 100000)
                 then
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), IntToStr(counter))
                 end
                 else
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), '0');
                 end;
              end;

            
          end;
        end;
      end;
    6: // confirm solution
      begin
        if (mousebutton = 1)
        then
        begin
          if ((x > button_x1) and (x < button_x2))
          then
          begin
            
             if ((y > button1_y1) and (y < button1_y2)) // Yes
             then
             begin
              check_menu:= 8; // after game
              FillRectangle(button_x1 - 2, button_menu_y1, width + 200, button4_y2);
              
              FindPath(PenX, PenY);
              counter:=counter + 100002;
              MakeSpecialButton(button_x1, button_ok_y1, button_x2, button_ok_y2, '       Ok');
             end;
             
            if ((y > button2_y1) and (y < button2_y2)) // No
            then
            begin
                check_menu:= 1; // game
                DrawGameButtons();
                if (counter < 100000)
                 then
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), IntToStr(counter))
                 end
                 else
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), '0');
                 end;
              end;

            
          end;
        end;      
      end;
    7: // confirm menu
      begin
        if (mousebutton = 1)
        then
        begin
          if ((x > button_x1) and (x < button_x2))
          then
          begin
            
             if ((y > button1_y1) and (y < button1_y2)) // Yes
             then
                Action0();
            
            if ((y > button2_y1) and (y < button2_y2)) // No
            then
            begin
                check_menu:= 1; // game
                DrawGameButtons();
                if (counter < 100000)
                 then
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), IntToStr(counter))
                 end
                 else
                 begin
                   SetFontColor(clBlack);
                   SetFontSize(12);
                   TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
                  
                   SetBrushColor(clWhite);
                   SetFontSize(22);
                   TextOut(width + 10, round((17/24)*height), 'MOVES: ');
                   TextOut(width + 130, round((17/24)*height), '0');
                 end;
              end;

            
          end;
        end;
     end;
   
   8: // after game  
    begin
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2) and (y > button_ok_y1) and (y < button_ok_y2)) 
        then
          Win();
    end;
    
   9: // input  
    begin
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2) and (y > button_ok_y1) and (y < button_ok_y2)) 
        then
        begin
          if (str_inp = '')
      then
        begin
        SetFontColor(clRed);
        SetFontSize(14);
        TextOut(width, round(height/3) + 280, 'At first input your name! ');
        
        SetFontSize(22);
        SetFontColor(clGray);
      end
      else
      begin
        FillRectangle(2*indent, round(height/3) + 200, width - 2*indent, round(height/3) + 400);
        assign(g, 'temp.txt');
        append(g);
        writeln(g, str_inp);
        writeln(g, score);
        close(g);
        
        reset(g);
        
        assign(f, 'src/highscores.txt');
        rewrite(f);
        
        for i:= 1 to 10 do
        begin
          
          readln(g, temps);
          writeln(f, temps);
          readln(g, tempint);
          writeln(f, tempint);
          
        end;
        
        close(g);
        erase(g);
        close(f);
        
        TextOut(round(width/3) + 80, round(height/3) + 200, 'Saved successfully'); 
        check:= false;
        
        FillRectangle(width, button_ok_y1 - 10, width + 200, height);
        DrawButtons();
        
        check_menu:= 2; // others
      end;
        end;
    end;
  
  10: // choose mode
    begin
      
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2))
        then
        begin
          
          if ((y > button_menu_y1) and (y < button_menu_y2)) // Menu
          then
            Action0;

          if ((y > button1_y1) and (y < button1_y2))  // Random
          then
          begin
            random_maze:= true;
            Action1;
          end;
          
          if ((y > button2_y1) and (y < button2_y2)) // Load maze
          then
          begin
            ClearWindow;
  
            SetBrushColor(clWhite);
            
            LoadWindow('src/mazes/my_maze');
            
            random_maze:= false;
            
            DrawGameButtons();
            in_game:= true;
            check_menu:= 1; // game
            counter:= 0;
            win_checker:= false;
            
            SetFontColor(clBlack);
            SetFontSize(12);
            TextOut(width + 10, round((19/24)*height), 'Use arrows to play');
            
            SetBrushColor(clWhite);
            SetFontSize(22);
            TextOut(width + 10, round((17/24)*height), 'MOVES: ');
            TextOut(width + 130, round((17/24)*height), '0');
          
            
            // Set start position
            MoveTo(2*indent, 2*indent);
            SetPlayer(PenX, PenY);
          
            // Catch key tapping
            OnKeyDown:= GameKeyDown;
                      
          end;
          
        end;
      
    end;
  
  end;
  end;
end; // MenuMouseDown

// Displays menu
Procedure MainMenu();
begin
  
  ClearWindow;
  check_menu:= 2; // others
  SetBrushColor(clWhite);
  StartScreen();  
  OnMouseDown:= MenuMouseDown;
  
end;

begin
end.