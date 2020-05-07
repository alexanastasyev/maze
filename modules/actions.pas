Unit actions;

Uses
  GraphABC;
Uses
  generator;
Uses 
  optimal_solver;
Uses 
  common;

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
  current_maze: string;
  current_maze_i: byte;
  in_change: boolean;

Procedure DiscardHighScores();
Var
  f:text;
  i: byte;
  
Begin
  assign(f, 'src/highscores.txt');
  rewrite(f);
  
  for i:= 1 to 10 do
  begin
    writeln(f, '-');
    writeln(f, 0);
  end;
  
  close(f);
end;

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
  TextOut(width + 30, round((1/24*height)), ' Menu');
  
  SetPenColor(clLightGreen);
  SetPenWidth(3);
  DrawRectangle(button_x1, button_menu_y1, 
                    button_x2, button_menu_y2);
  
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
  TextOut(width + 30, round((1/24*height)), ' Menu');
  
  SetPenColor(clLightGreen);
  SetPenWidth(3);
  
  DrawRectangle(button_x1, button_menu_y1, 
                    button_x2, button_menu_y2);
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '   Restart');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '   Solution');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, '      Exit');
  
  SetFontSize(current_size);
  SetFontColor(current_color);
  
end;

Procedure DrawHighScoreButtons();
begin
  DrawButtons();
  
  MakeDangerButton(button_x1, button_ok_y1, 
                   button_x2, button_ok_y2, '   Discard');
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

Procedure DrawDangerConfirmButtons();
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
  TextOut(width + 25, round((1/24*height)), 'SURE?');
  
  
  MakeDangerButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '      Yes');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '       No');
  
  
  SetFontSize(current_size);
  SetFontColor(current_color);
  
end;

Procedure DrawLoadButtons();
begin
  
  SetBrushColor(clWhite);
  FillRectangle(width+line_size, 1, width + 200, height);
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(width + 30, round((1/24*height)), ' Menu');
  
  SetPenColor(clLightGreen);
  SetPenWidth(3);
  
  DrawRectangle(button_x1, button_menu_y1, 
                    button_x2, button_menu_y2);
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '     Load');
  
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, '     Edit');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, '     Exit');
  
  MakeDangerButton(button_x1, button_ok_y1, 
                    button_x2, button_ok_y2, '    Delete');
  
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
    48..57, 65..90, 97..122, 32: // Char keys
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
    48..57, 65..90, 97..122, 32: // Char keys
    begin
       if (length(str_inp)) < 12 then
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
  
  SetFontSize(20);
  SetFontColor(clRed);
  TextOut(1, 425, 'Create mazes');
  SetFontSize(14);
  SetFontColor(clBlack);
  TextOut(1, 475, 'You can create and save your own mazes in "New maze" section. Then you can');
  TextOut(1, 500, 'load and play them from "Start -> Load" section. Also you can edit or delete them from there.');
  TextOut(1, 525, 'Created mazes must have a solution and a unique name');
  
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
  check_menu:= 13; // highscores
  in_game:= false;
  
  SetFontSize(30);
  SetFontColor(clRed);
  TextOut(round(width/2) - 100, 1, 'High scores');
  SetFontSize(26);
  SetFontColor(clBlue);
  TextOut(1, round(height*(2/24)), 'Position');
  TextOut(round(width/2) - 100, round(height*(2/24)), 'Name');
  TextOut(width - 200, round(height*(2/24)), 'Score');
  DrawHighScoreButtons();
  
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
  TextOut(width + 30, round((1/24*height)), ' Menu');
  
  SetPenColor(clLightGreen);
  SetPenWidth(3);
  
  DrawRectangle(button_x1, button_menu_y1, 
                    button_x2, button_menu_y2);
  
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
  k: file;
  i: integer;
  temps: string;
  tempint: integer;
  str_help: string;
  x_start: integer;
  y_start: integer;
  horizontal: boolean;
  vertical: boolean;
  name_width: integer;
  name_height: integer;
  uniq: boolean;
  maze_amount: byte;
  names: array[1..100] of string;
  x_highlight: integer;
  y_highlight: integer;
  current_highlight_x: integer;
  current_highlight_y: integer;
  highlight: integer;
  m1, m2: integer;
  
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
                  if (not(in_change) or (names[i] <> current_maze))
                  then
                  begin
                    SetFontColor(clRed);
                    SetFontSize(12);
                    TextOut(button_x1, button5_y1, 'You already have');
                    TextOut(button_x1, button5_y1 + 20, 'maze with this name');
                    uniq:= false;
                    break;
                  end;
          
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
          DrawDangerConfirmButtons();
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
            
            if not(in_change)
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
              
              Sort;
              
              str_inp:= '';
              FillRectangle(width + indent, 0, width + 200, 200);
              DrawInputMenu();
              action:= 0; // input menu
              input_menu:= false;
              Action0;
            end
            else // in_change
            begin
              
              assign(f, 'src/mazes/' + current_maze);
              erase(f);
              
              SaveWindow('src/mazes/' + str_inp);
                     
               assign(f, 'src/mazes/maze_amount.txt');
               reset(f);
               readln(f, maze_amount);
               close(f);
               
               assign(f, 'src/mazes/maze_list.txt');
               reset(f);               
               for i:= 1 to maze_amount do
                  readln(f, names[i]);
               close(f);
               
               for i:= current_maze_i to (maze_amount - 1) do
               begin
                 names[i] := names[i+1];
               end;
                              
               maze_amount:= maze_amount - 1;
               
               assign(f, 'src/mazes/maze_amount.txt');
               rewrite(f);
               writeln(f, maze_amount);
               close(f);
               
               assign(f, 'src/mazes/maze_list.txt');
               rewrite(f);
                            
               for i:= 1 to maze_amount do
                 writeln(f, names[i]);

               close(f);
              
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
              
              Sort;
              
              str_inp:= '';
              FillRectangle(width + indent, 0, width + 200, 200);
              DrawInputMenu();
              action:= 0; // input menu
              input_menu:= false;
              Action0;
            end;
            
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
          
          str_inp:= '';
          
          SetFontColor(clBlack);
          SetFontSize(14);
          
          TextOut(button_x1, button_ok_y1, 'Maze name:');
          TextOut(button_x1, button_ok_y1 + 20, str_inp);
  
        end;
        
        if ((y > button2_y1) and (y < button2_y2)) // no
        then
        begin
          FillRectangle(width + indent, 0, width + 200, 200);
          DrawInputMenu();
          SetFontColor(clBlack);
          SetFontSize(14);
          TextOut(button_x1, button_ok_y1, 'Maze name:');
          TextOut(button_x1, button_ok_y1 + 20, str_inp);
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
    
    for i:= 1 to 40 do
    begin
      
      if ((x >= (indent + line_size + (i-1)*cell_size + 1)) and (x <= (indent - line_size + i*cell_size)))
      then
      begin
        x_start:= indent + (i-1)*cell_size + 1;
        horizontal:= true;
        break;
      end;
      
      if ((x >= (indent + i*cell_size)) and ( x <= (indent + i*cell_size + line_size)))
      then
      begin
        x_start:= indent + i*cell_size;
        horizontal:= false;
        break;
      end;
      
    end;
    
    for i:= 1 to 30 do
    begin
      
      if ((y >= (indent + line_size + (i-1)*cell_size + 1)) and (y <= (indent - line_size + i*cell_size)))
      then
      begin
        y_start:= indent + (i-1)*cell_size + 1;
        vertical:= true;   
        break;
      end;
      
      if ((y >= (indent + i*cell_size)) and ( y <= (indent + i*cell_size + line_size)))
      then
      begin
        y_start:= indent + i*cell_size;
        vertical:= false;
        break;
      end;
      
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
            TextOut(width + 30, round((1/24*height)), ' Menu');
  
            SetPenColor(clLightGreen);
            SetPenWidth(3);
            
            DrawRectangle(button_x1, button_menu_y1, 
                    button_x2, button_menu_y2);
            
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
            in_change:= false;
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
             begin
                CloseWindow;
             end;
            
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
            
            current_maze:= '';
            current_maze_i:= 0;
            
            for i:=1 to 100 do
              names[i]:= '';
            
            ClearWindow;
            check_menu:= 11;
            DrawLoadButtons;
            
            SetFontSize(30);
            SetFontColor(clRed);
            TextOut(round(width/2) - 140, 1, 'Choose maze:');
            
            assign(f, 'src/mazes/maze_amount.txt');
            reset(f);
            readln(f, maze_amount);
            close(f);
            
            assign(f, 'src/mazes/maze_list.txt');
            reset(f);
                      
            for i:= 1 to maze_amount do
            begin
              readln(f, names[i]);
            end;
            
            close(f);

            if (names[1] = '')
            then
            begin
              
              SetFontColor(clBlack);
              SetFontSize(14);
              TextOut(50, 100, 'There`re no saved mazes. Use "New maze" section to create your mazes.');
              check_menu:= 2; // others;
              DrawButtons;
              
            end
            else
            begin
              SetFontColor(clBlack);
              SetFontSize(40);
              SetFontColor(clGray);
              
              SetPenColor(clBlue);
              SetPenWidth(line_size);
              
              DrawRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
              TextOut(round(width/2) - 200, round(height/2) - 60, names[1]);
              
              MoveTo(round(width/2) - 265, round(height/2) - 80);
              LineTo(round(width/2) - 265, round(height/2) + 20);
              LineTo(round(width/2) - 315, round(height/2) - 30);
              LineTo(round(width/2) - 265, round(height/2) - 80);
              
              MoveTo(round(width/2) + 265, round(height/2) - 80);
              LineTo(round(width/2) + 265, round(height/2) + 20);
              LineTo(round(width/2) + 315, round(height/2) - 30);
              LineTo(round(width/2) + 265, round(height/2) - 80);
              
              current_maze:= names[1];
              current_maze_i:= 1;
            end;         
          end;
          
        end;
      
    end;
  
  11: // Load maze
    begin
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2))
        then
        begin
          
          if ((y > button_menu_y1) and (y < button_menu_y2)) // Menu
          then
            Action0;

          if ((y > button1_y1) and (y < button1_y2))  // Load
          then
          begin
            ClearWindow;
  
            SetBrushColor(clWhite);
            
            LoadWindow('src/mazes/' + current_maze);
            
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
          
          if ((y > button2_y1) and (y < button2_y2)) // Change
          then
          begin
            ClearWindow;
            LoadWindow('src/mazes/' + current_maze);
            DrawUnactiveWalls;
            DrawBorderWalls;
            DrawFinish;
            SetBrushColor(clWhite);
            FillRectangle(width + indent, 1, width + 200, button4_y1);
            DrawInputMenu;
            
            input_menu:= true;
            str_inp:= current_maze;
            in_change:= true;
            OnKeyDown:= InputMaze;
            action:= 0;
            check:= true;
            SetPlayer(2*indent, 2*indent);
            
          end;
          
          if ((y > button3_y1) and (y < button3_y2)) // exit
          then
          begin
            SetBrushColor(clWhite);
            FillRectangle(width + indent, 1, width + 200, height);
            DrawConfirmButtons;
            check_menu:= 15;
          end;
          
          if ((y > button_ok_y1) and (y < button_ok_y2))  // Delete
          then
          begin
            
            
            DrawDangerConfirmButtons;
            check_menu:= 12; // confirm delete
                       
          end;
          
       end;
       
       m1:= round(width/2) + 265;
       m2:= round(height/2) - 30;
       
       if ((x > m1) and (y < (-x + m2 + m1 + 50)) and (y > (x + m2 - m1 - 50))) // Right
       then
       begin
         
         maze_amount:= 0;
         assign(f, 'src/mazes/maze_amount.txt');
         reset(f);
         readln(f, maze_amount);
         close(f);
         
         assign(f, 'src/mazes/maze_list.txt');
         reset(f);
         for i:= 1 to maze_amount do
           readln(f, names[i]);
         
         close(f);
         
         SetBrushColor(clWhite);
         FillRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
         if (current_maze_i = maze_amount)
         then
         begin
           current_maze_i:= 1;
           current_maze:= names[1];
         end
         else
         begin
           current_maze_i:= current_maze_i + 1;
           current_maze:= names[current_maze_i];
         end;
         DrawRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
         SetFontColor(clGray);
         SetFontSize(40);
         TextOut(round(width/2) - 200, round(height/2) - 60, current_maze);
         
         
       end;
       
       
       m1:= round(width/2) - 265;
       m2:= round(height/2) - 30;
       
       if ((x < m1) and (y < (x + m2 - m1 + 50)) and (y > (-x + m2 + m1 - 50))) // Left
       then
       begin
         
         maze_amount:= 0;
         assign(f, 'src/mazes/maze_amount.txt');
         reset(f);
         readln(f, maze_amount);
         close(f);
         
         assign(f, 'src/mazes/maze_list.txt');
         reset(f);
         for i:= 1 to maze_amount do
           readln(f, names[i]);
         
         close(f);
         
         SetBrushColor(clWhite);
         FillRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
         if (current_maze_i = 1)
         then
         begin
           current_maze_i:= maze_amount;
           current_maze:= names[maze_amount];
         end
         else
         begin
           current_maze_i:= current_maze_i - 1;
           current_maze:= names[current_maze_i];
         end;
         DrawRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
         SetFontColor(clGray);
         TextOut(round(width/2) - 200, round(height/2) - 60, current_maze);
         
       end;
       
    end;
    
  12: // confirm delete
  
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
               
               assign(f, 'src/mazes/' + current_maze);
               erase(f);
       
               assign(f, 'src/mazes/maze_amount.txt');
               reset(f);
               readln(f, maze_amount);
               close(f);
               
               assign(f, 'src/mazes/maze_list.txt');
               reset(f);               
               for i:= 1 to maze_amount do
                  readln(f, names[i]);
               close(f);
               
               for i:= current_maze_i to (maze_amount - 1) do
               begin
                 names[i] := names[i+1];
               end;
                              
               maze_amount:= maze_amount - 1;
               
               assign(f, 'src/mazes/maze_amount.txt');
               rewrite(f);
               writeln(f, maze_amount);
               close(f);
               
               assign(f, 'src/mazes/maze_list.txt');
               rewrite(f);
                            
               for i:= 1 to maze_amount do
                 writeln(f, names[i]);

               close(f);
               
               Sort;
               
               if (maze_amount <> 0)
               then
               begin
                 check_menu:= 11; // load
                 SetBrushColor(clWhite);
                 FillRectangle(width + 10, 1, width + 200, button3_y2);
                 FillRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
                 
                 DrawRectangle(round(width/2) - 250, round(height/2) - 80, round(width/2) + 250, round(height/2) + 20);
                 SetFontColor(clGray);
                 SetFontSize(40);
                 
                 current_maze:= names[1];
                 current_maze_i:= 1;
                 
                 TextOut(round(width/2) - 200, round(height/2) - 60, current_maze);
                 
                 DrawLoadButtons;
               end
               else
               begin
                  ClearWindow;
                  SetFontSize(30);
                  SetFontColor(clRed);
                  TextOut(round(width/2) - 140, 1, 'Choose maze:');
                  SetFontColor(clBlack);
                  SetFontSize(14);
                  TextOut(50, 100, 'There`re no saved mazes. Use "New maze" section to create your mazes.');
                  check_menu:= 2; // others;
                  DrawButtons;
               end;
               
               
               
             end;
            
            if ((y > button2_y1) and (y < button2_y2)) // No
            then
            begin
                check_menu:= 11; // load
                SetBrushColor(clWhite);
                FillRectangle(width + 10, 1, width + 200, button3_y2);
                
                DrawLoadButtons;
            end;
         end;
       end;
    end;
    
  13: // highscores  
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
            TextOut(width + 30, round((1/24*height)), ' Menu');
  
            SetPenColor(clLightGreen);
            SetPenWidth(3);
            DrawRectangle(button_x1, button_menu_y1, button_x2, button_menu_y2);
            
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
            in_change:= false;
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
          
          if ((y > button_ok_y1) and (y < button_ok_y2)) // discard
          then
          begin
            check_menu:= 14; // confirm discard highscores;
            DrawDangerConfirmButtons;
          end;
          
        end;
    end;
  
  14: // confirm discard highscores
    begin
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2))
        then
        begin
          if ((y > button1_y1) and (y < button1_y2)) // Yes
             then
             begin
                DiscardHighScores();
                DrawHighScoreButtons;
                SetBrushColor(clWhite);
                FillRectangle(1, 1, width, height);
                HighScores;
                check_menu:= 13;
             end;
            
          if ((y > button2_y1) and (y < button2_y2)) // No
            then
            begin
              check_menu:= 13; // highscores
              SetBrushColor(clWhite);
              FillRectangle(width + indent, 1, width + 200, button3_y1);
              DrawHighScoreButtons;
              
            end;
        end;    
    end;
  
   15: // confirm exit from load
    begin
      if (mousebutton = 1)
      then
        if ((x > button_x1) and (x < button_x2))
        then
        begin
          
          if ((y > button1_y1) and (y < button1_y2))
          then
            CloseWindow;
          
          if ((y > button2_y1) and (y < button2_y2))
          then
          begin
            SetBrushColor(clWhite);
            FillRectangle(width + indent, 1, width + 200, height);
            DrawLoadButtons;
            check_menu:= 11; // load
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