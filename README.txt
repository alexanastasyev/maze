﻿"Maze" game in Pascal:


- Program is run from the main file "maze.pas"

- Folder "src" stores all the game data:

  - File "highscores.txt" stores information about current highscores
  - File "backgroung.jpg" - main menu background
  - File "maze_ico.ico" - icon for shortcut of compliled application (set manually)

  - Folder "mazes" stores information about saved mazes:
    - The number stored in "maze_amount.txt" is an amount of saved mazes
    - File "maze_list.txt" stores the list of all saved mazes` names
    - Others files are saved mazes themselves

- Folder "modules" stores program modules:

  - "generator.pas" - algorithm of random mazes generation
  - "optimal_solver.pas" and "back_solver.pas" - algorithm of finding the shortest solution of a maze
  - "actions.pas" - procedures for interaction with user (mouse clicks, buttons) and auxiliary procedures for the interaction
  - "common.pas" - constants, variables, procedures and function, used by others modules

-----------------------------------------------------------------------------------------------------------------------------

Игра "Лабиринт" на языке Pascal:


- Программа запускается из главного файла "maze.pas"

- В папке "src" хранится игровая информация:

  - В файле "highscores.txt" хранится информация о текущих рекордах
  - Файл "backgroung.jpg" - обои в главном меню
  - Файл "maze_ico.ico" - значок для ярлыка скомпилированного приложения (устанавливается вручную)

  - В папке "mazes" хранится информация о сохранённых лабиринтах:
    - В файле "maze_amount.txt" хранится число - количество сохранённых лабиринтов
    - В файле "maze_list.txt" хранится список названий сохранённых лабиринтов
    - Остальные файлы - сохранённые лабиринты

- В папке "modules" хранятся программные модули:

  - "generator.pas" - алгоритм генерации случайного лабиринта
  - "optimal_solver.pas" и "back_solver.pas" - алгоритм поиска оптимального пути прохождения лабиринта
  - "actions.pas" - процедуры взаимодействия с пользователем (нажатие мыши, клавиш) и воспомогательные процедуры для взаимодействия
  - "common.pas" - константы, переменные, процедуры и функции, используемые другими модулями
