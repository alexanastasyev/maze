Program menu;

Uses 
  GraphABC;

Const
  width = 810; // width of the window
  height = 610; // height of the window
  indent = 5; // maze borders from window borders | player from cell borders
  
  button_x1 = round((3/7)*width);
  button_x2 = round((4/7)*width);
  
  button1_y1 = round((4/24)*height);
  button1_y2 = round((6/24)*height);
  
  button2_y1 = round((7/24)*height);
  button2_y2 = round((9/24)*height);
  
  button3_y1 = round((10/24)*height);
  button3_y2 = round((12/24)*height);
  
  button_menu_x1 = indent;
  button_menu_x2 = indent+round((1/7)*width);
  button_menu_y1 = round((21/24)*height);
  button_menu_y2 = round((23/24)*height);

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

Procedure Action1();
Begin
  
  ClearWindow;
  writeln('Action1');
  
end;

Procedure Action2();
Begin
  
  ClearWindow;
  writeln('Action2');
  
end;

Procedure Action3();
Begin
  
  ClearWindow;
  writeln('Action3');
  
end;

Procedure MenuMouseDown(x, y, mousebutton: integer);
begin
  
  if ((x > button_x1) and (x < button_x2)) 
  then
  begin
    
    if ((y > button1_y1) and (y < button1_y2))
    then
      Action1();
    
    if ((y > button2_y1) and (y < button2_y2))
    then
      Action2();
    
    if ((y > button3_y1) and (y < button3_y2))
    then
      Action3();
    
  end;
  
end;

Procedure MainMenu();
begin
  
  ClearWindow;
  
  SetFontSize(30);
  SetFontColor(clLightGreen);
  TextOut(round(width/2.325), round((1/24*height)), 'MAZE');
  
  
  MakeSpecialButton(button_x1, button1_y1, 
                    button_x2, button1_y2, 'Action1');
                    
  MakeSpecialButton(button_x1, button2_y1, 
                    button_x2, button2_y2, 'Action2');
  
  MakeSpecialButton(button_x1, button3_y1, 
                    button_x2, button3_y2, 'Action3');
  
  SetFontColor(clRed);
  OnMouseDown:= MenuMouseDown;
  
  
end;


Begin
  
  // Set window
  SetWindowHeight(height);
  SetWindowWidth(width);
  CenterWindow;  
  
  MainMenu();
  
end.