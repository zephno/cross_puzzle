import 'package:crosspuzzle/models/level_data.dart';

const LevelData mediumLevel2 = LevelData(
  id: 'medium_2',
  difficulty: 'Medium',
  grid: [
    [1,1,1,1,0,0,1,1,1,1,0],
    [1,0,1,0,0,0,0,0,1,0,0],
    [1,0,1,0,0,0,0,0,1,0,1],
    [1,1,1,1,0,0,0,1,1,1,1],
    [0,0,0,1,0,0,0,0,0,0,1],
    [1,1,1,1,0,0,0,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,0,0,0,0,1,1,1,1],
    [1,0,1,0,1,1,1,1,0,0,1],
    [0,1,1,1,1,0,0,1,1,1,1],
    [0,0,1,0,1,0,0,1,0,0,1],
  ],

  clues: [

    // ===== ACROSS =====

    Clue(
      number: 1,
      direction: 'A',
      start: CellPosition(0,0),
      answer: 'AREA',
      hint: 'A region or space',
    ),

    Clue(
      number: 3,
      direction: 'A',
      start: CellPosition(0,6),
      answer: 'STAR',
      hint: 'Celestial body',
    ),

    Clue(
      number: 6,
      direction: 'A',
      start: CellPosition(3,0),
      answer: 'EPEE',
      hint: 'Fencing sword',
    ),

    Clue(
      number: 8,
      direction: 'A',
      start: CellPosition(3,7),
      answer: 'TSAR',
      hint: 'Russian emperor',
    ),

    Clue(
      number: 9,
      direction: 'A',
      start: CellPosition(5,0),
      answer: 'ONCE',
      hint: 'One time only',
    ),

    Clue(
      number: 10,
      direction: 'A',
      start: CellPosition(5,7),
      answer: 'IDOL',
      hint: 'Worshipped image',
    ),

    Clue(
      number: 12,
      direction: 'A',
      start: CellPosition(7,0),
      answer: 'ELI',
      hint: 'Biblical priest',
    ),

    Clue(
      number: 14,
      direction: 'A',
      start: CellPosition(7,7),
      answer: 'ASEA',
      hint: 'On the ocean',
    ),

    Clue(
      number: 16,
      direction: 'A',
      start: CellPosition(8,4),
      answer: 'OMEN',
      hint: 'Sign of future events',
    ),

    Clue(
      number: 17,
      direction: 'A',
      start: CellPosition(9,1),
      answer: 'NEON',
      hint: 'Bright gas',
    ),

    Clue(
      number: 18,
      direction: 'A',
      start: CellPosition(9,7),
      answer: 'ODOR',
      hint: 'A distinctive smell',
    ),

    // ===== DOWN =====

    Clue(
      number: 1,
      direction: 'D',
      start: CellPosition(0,0),
      answer: 'ALOE',
      hint: 'Soothing plant',
    ),

    Clue(
      number: 2,
      direction: 'D',
      start: CellPosition(0,2),
      answer: 'EASE',
      hint: 'Freedom from difficulty',
    ),

    Clue(
      number: 4,
      direction: 'D',
      start: CellPosition(0,8),
      answer: 'ALAS',
      hint: 'Expression of sorrow',
    ),

    Clue(
      number: 5,
      direction: 'D',
      start: CellPosition(2,10),
      answer: 'ORAL',
      hint: 'Spoken, not written',
    ),

    Clue(
      number: 7,
      direction: 'D',
      start: CellPosition(3,3),
      answer: 'ERE',
      hint: 'Before, in poetry',
    ),

    Clue(
      number: 9,
      direction: 'D',
      start: CellPosition(5,0),
      answer: 'OLEO',
      hint: 'Butter substitute',
    ),

    

    Clue(
      number: 13,
      direction: 'D',
      start: CellPosition(7,2),
      answer: 'IDEA',
      hint: 'A thought or concept',
    ),

    Clue(
      number: 14,
      direction: 'D',
      start: CellPosition(7,7),
      answer: 'ANON',
      hint: 'Soon, old style',
    ),

    Clue(
      number: 15,
      direction: 'D',
      start: CellPosition(7,10),
      answer: 'ACRE',
      hint: 'Land measure',
    ),

    Clue(
      number: 16,
      direction: 'D',
      start: CellPosition(8,4),
      answer: 'ONE',
      hint: 'Single unit',
    ),

  ],
);
