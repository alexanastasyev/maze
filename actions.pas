Unit actions;

Uses
  GraphABC;
Uses
  generator;
Uses 
  solver;
Uses 
  common;

Const
 
  //-------buttons` coordinates begin-------//
  
  button_x1 = width + 10;
  button_x2 = width + 180;
  
  
  button1_y1 = round((4/24)*height);
  button1_y2 = round((6/24)*height);
  
  button2_y1 = round((7/24)*height);
  button2_y2 = round((9/24)*height);
  
  button3_y1 = round((10/24)*height);
  button3_y2 = round((12/24)*height);
  
  button4_y1 = round((13/24)*height);
  button4_y2 = round((15/24)*height);
  
  button_menu_y1 = round((1/24)*height);
  button_menu_y2 = round((3/24)*height);

  //-------buttons` coordinates end-------//

Var
  counter: integer;
  str_inp: string;
  check: boolean;
  check_menu: byte;
  in_game: boolean;
  
// Draws formated button in rectangle with x1,y1-x2,y2 coordinates and text s
Procedure MakeSpecialButton(x1,y1,x2,y2: integer; s: string);
var
  current_pen_color: color;
  current_pen_width: integer;
  current_font_size: integer;
  current_font_color: color;
  
begin
  
  current_pen_color:= PenColor;
  current_pen_width:= PenWidth;
  current_font_size:= FontSize;
  current_font_color:= FontColor;
  
  SetPenWidth(3);
  SetPenColor(clLightBlue);
  SetFontSize(22);
  SetFontColor(clLightBlue);
  
  Rectangle(x1, y1, x2, y2);
  TextOut(x1+2*indent, y1+2*indent, s);
  
  SetPenWidth(current_pen_width);
  SetPenColor(current_pen_color);
  SetFontSize(current_font_size);
  SetFontColor(current_font_color);
  
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
  TextOut(width + 30, round((1/24*height)), 'MENU');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, '     Start');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, 'How to play');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, 'High scores');
                    
  MakeSpecialButton(button_x1, button4_y1, 
                    button_x2, button4_y2, '      Exit');
  
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
procedure Input(Key: integer);
var
  f, g: text;
  i: integer;
  temps: string;
  tempint: integer;
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
    13: // enter
      begin
        FillRectangle(2*indent, round(height/3) + 200, width - 2*indent, round(height/3) + 400);
        assign(g, 'temp.txt');
        append(g);
        writeln(g, str_inp);
        writeln(g, counter - 1);
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
        check_menu:= 2; // others
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
    str:= 'You didn`t solve the maze by yourself';
    TextOut(round(width/3)-20, round(height/3) + 140, str);
  end

  else
  begin
    check_menu:= 3; // input name
    str:= '   You solved the maze in ' + IntToStr(counter - 1) + ' moves';
    TextOut(round(width/3)-20, round(height/3) + 140, str);
    
    
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
        
        if (players[i].score > players[i+1].score)
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

  if (players[10].score > (counter - 1))
  then
  begin
    //readln(name);
    TextOut(round(width/3) + 80, round(height/3) + 200, 'Name: ');
    check:= true;
    OnKeyDown:= Input;
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
    TextOut(round(width/3) + 60, round(height/3) + 200, 'You don`t enter top-10');
    check_menu:= 2; // others
  end;
  end; // else
  
  
  
  
end;

// Actions on tapping keys while playing
procedure GameKeyDown(key: integer);    
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
       TextOut(width + 130, round((17/24)*height), '0');
     end;
   
   // Check for win
  if ((PenX = finish_x) and (PenY = finish_y))
  then
    Win();
   
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
  TextOut(1, 200, 'While playing you can tap F5 button to see one of the possible solutions.');
  
  SetFontSize(20);
  SetFontColor(clRed);
  TextOut(1, 250, 'Score');
  SetFontSize(14);
  SetFontColor(clBlack);
  TextOut(1, 300, 'Every relocation increments your score by 1. Try to solve the maze in as few moves as possible.');
  TextOut(1, 325, 'If you managed to enter the top ten players, game will ask you to input your name and place it in ');
  TextOut(1, 350, 'high scores. You can view the high scores table in "High scores" section.');
  
  
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
  TextOut(width - 200, round(height*(2/24)), 'Moves');
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
      
      if (players[i].score > players[i+1].score)
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

// Catch mouse down
Procedure MenuMouseDown(x, y, mousebutton: integer);
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
            Action1();
          
          if ((y > button2_y1) and (y < button2_y2)) // How to play
          then
            Action2();
          
          if ((y > button3_y1) and (y < button3_y2)) // High scores
          then
            Action3();
          
          if ((y > button4_y1) and (y < button4_y2)) // Exit
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
    
  3: // input
    if (mousebutton = 1)
      then
      begin
        SetFontColor(clRed);
        TextOut(round(width/3) + 50, round(height/3) + 250, 'At first input your name! ');
        TextOut(round(width/3) + 50, round(height/3) + 300, '     (And tap Enter) ');

        SetFontColor(clGray);
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
                Action1();
            
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
              check_menu:= 1; // game
              DrawGameButtons();
              
              SetFontColor(clBlack);
              SetFontSize(12);
              TextOut(width + 10, round((19/24)*height), 'Use arrows to play');

              SetBrushColor(clWhite);
              SetFontSize(22);
              TextOut(width + 10, round((17/24)*height), 'MOVES: ');
              TextOut(width + 130, round((17/24)*height), '0');
              FindPath(PenX, PenY);
              counter:=counter + 100000;
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