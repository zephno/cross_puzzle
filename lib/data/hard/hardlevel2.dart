import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData hardLevel2 = LevelData(
  id: 'hard_2',
  difficulty: 'Hard',
  grid: [
    [1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0], // r0
    [1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1], // r1
    [1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0], // r2
    [1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1], // r3
    [1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0], // r4
    [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1], // r5
    [0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
    [0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1],
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
    [0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1], 
    [0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1],
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'SUDDEN',
      hint: 'Unexpectedly quick',
    ),
    Clue(
      number: 7, direction: 'A',
      start: CellPosition(1, 5),
      answer: 'IMMATURE',
      hint: 'Not fully developed, juvenile',
    ),
    Clue(
      number: 8, direction: 'A',
      start: CellPosition(2, 0),
      answer: 'MAN',
      hint: 'Adult male person',
    ),
    Clue(
      number: 9, direction: 'A',
      start: CellPosition(3, 2),
      answer: 'GATHER',
      hint: 'Assemble',
    ),
    Clue(
      number: 10, direction: 'A',
      start: CellPosition(3, 9),
      answer: 'LUCK',
      hint: 'Chance, fortune',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(5, 0),
      answer: 'TORSO',
      hint: 'Body trunk',
    ),
    Clue(
      number: 13, direction: 'A',
      start: CellPosition(5, 6),
      answer: 'ECLIPSE',
      hint: 'One celestial body obscures another',
    ),
    Clue(
      number: 15, direction: 'A',
      start: CellPosition(7, 0),
      answer: 'MEADOW',
      hint: 'A field which has grass and flowers growing',
    ),
    Clue(
      number: 17, direction: 'A',
      start: CellPosition(7, 8),
      answer: 'UNCLE',
      hint: 'Brother of your father',
    ),
    Clue(
      number: 21, direction: 'A',
      start: CellPosition(9, 0),
      answer: 'PASS',
      hint: 'Succeed in an examination',
    ),
    Clue(
      number: 22, direction: 'A',
      start: CellPosition(9, 5),
      answer: 'SALUTE',
      hint: ' Military greeting',
    ),
    Clue(
      number: 23, direction: 'A',
      start: CellPosition(10, 10),
      answer: 'EEL',
      hint: 'Snake-like fish',
    ),
    Clue(
      number: 24, direction: 'A',
      start: CellPosition(11, 0),
      answer: 'REMEMBER',
      hint: 'Keep information in the mind',
    ),
    Clue(
      number: 25, direction: 'A',
      start: CellPosition(12, 7),
      answer: 'MUSEUM',
      hint: 'Depository for displaying objects of historical interest',
    ),

    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'D',
      start: CellPosition(0, 0),
      answer: 'SUMMIT',
      hint: 'Apex',
    ),
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 2),
      answer: 'DANGER',
      hint: 'Hazard',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(0, 5),
      answer: 'NICHE',
      hint: 'Wall recess',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 7),
      answer: 'EMBRACE',
      hint: 'Clasp another person in the arms',
    ),
    Clue(
      number: 5, direction: 'D',
      start: CellPosition(0, 9),
      answer: 'STALLION',
      hint: 'Adult male horse',
    ),
    Clue(
      number: 6, direction: 'D',
      start: CellPosition(0, 11),
      answer: 'TRACKS',
      hint: 'What a police bloodhound does',
    ),
    Clue(
      number: 12, direction: 'D',
      start: CellPosition(5, 3),
      answer: 'SIDESTEP',
      hint: 'A physical motion to avoid or dodge something',
    ),
    Clue(
      number: 16, direction: 'D',
      start: CellPosition(7, 1),
      answer: 'ENAMEL',
      hint: 'Substance covering the crown of a tooth',
    ),
    Clue(
      number: 17, direction: 'D',
      start: CellPosition(7, 5),
      answer: 'WASABI',
      hint: 'Sushi condement',
    ),
    Clue(
      number: 18, direction: 'D',
      start: CellPosition(7, 10),
      answer: 'CHEESE',
      hint: 'Dairy product',
    ),
    Clue(
      number: 19, direction: 'D',
      start: CellPosition(7, 12),
      answer: 'EMBLEM',
      hint: 'Insignia',
    ),
    Clue(
      number: 20, direction: 'D',
      start: CellPosition(8, 7),
      answer: 'ALARM',
      hint: 'Clock that wakes a sleeper at a preset time',
    ),


    
    
  ],
);
