import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData hardLevel4 = LevelData(
  id: 'hard_4',
  difficulty: 'Hard',
  grid: [
    [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1], // r0
    [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1], // r1
    [0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1], // r2
    [0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1], // r3
    [1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1], // r4
    [0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1], // r5
    [1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1],
    [1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0],
    [1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1],
    [1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0],
    [1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0],
    [1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0], 
    [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1],
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'EMPLOY',
      hint: 'Hire for work',
    ),
    Clue(
      number: 5, direction: 'A',
      start: CellPosition(0, 7),
      answer: 'SILENT',
      hint: 'Making no sound',
    ),
    Clue(
      number: 8, direction: 'A',
      start: CellPosition(2, 1),
      answer: 'SEA',
      hint: 'Huge body of salt water',
    ),
    Clue(
      number: 9, direction: 'A',
      start: CellPosition(2, 7),
      answer: 'NUMBER',
      hint: 'An arithmetical value',
    ),
    Clue(
      number: 10, direction: 'A',
      start: CellPosition(3, 3),
      answer: 'VIRUS',
      hint: 'Bodily or computer infection',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(4, 0),
      answer: 'SAVE',
      hint: 'Opposite of spend',
    ),
    Clue(
      number: 12, direction: 'A',
      start: CellPosition(4, 9),
      answer: 'TAXI',
      hint: 'Vehicle for hire',
    ),
    Clue(
      number: 13, direction: 'A',
      start: CellPosition(5, 4),
      answer: 'ACTIVE',
      hint: 'Not passive',
    ),
    Clue(
      number: 15, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'HERS',
      hint: 'Feminine posseisve pronoun used to indicate ownership of something',
    ),
    Clue(
      number: 17, direction: 'A',
      start: CellPosition(6, 9),
      answer: 'DRAG',
      hint: 'Pull along',
    ),
    Clue(
      number: 19, direction: 'A',
      start: CellPosition(7, 3),
      answer: 'TURKEY',
      hint: 'Istanbul is the largest city in ___ (old name)',
    ),
    Clue(
      number: 20, direction: 'A',
      start: CellPosition(8, 0),
      answer: 'IDEA',
      hint: 'Creative thought',
    ),
    Clue(
      number: 21, direction: 'A',
      start: CellPosition(8, 9),
      answer: 'BEER',
      hint: 'Meat from cattle',
    ),
    Clue(
      number: 22, direction: 'A',
      start: CellPosition(9, 5),
      answer: 'LATER',
      hint: 'Not earlier',
    ),
    Clue(
      number: 24, direction: 'A',
      start: CellPosition(10, 0),
      answer: 'CHOICE',
      hint: 'Selection',
    ),
    Clue(
      number: 25, direction: 'A',
      start: CellPosition(10, 9),
      answer: 'AHA',
      hint: 'Eureka!',
    ),
    Clue(
      number: 26, direction: 'A',
      start: CellPosition(12, 0),
      answer: 'TENNIS',
      hint: 'Sport played with a small rubber ball and rackets',
    ),
    Clue(
      number: 27, direction: 'A',
      start: CellPosition(12, 7),
      answer: 'Tunnel',
      hint: 'Underground passage',
    ),
    

    

    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 1),
      answer: 'MISTAKE',
      hint: 'Error',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(0, 3),
      answer: 'LEAVE',
      hint: 'Opposite of stay',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 5),
      answer: 'YEAR',
      hint: 'Calendar duration',
    ),
    Clue(
      number: 5, direction: 'D',
      start: CellPosition(0, 7),
      answer: 'SUNSHINE',
      hint: 'Light of the nearest star',
    ),
    Clue(
      number: 6, direction: 'D',
      start: CellPosition(0, 9),
      answer: 'LIMITED',
      hint: 'Restricted, confined',
    ),
    Clue(
      number: 7, direction: 'D',
      start: CellPosition(0, 12),
      answer: 'TURNING',
      hint: 'Changing direction',
    ),
    Clue(
      number: 14, direction: 'D',
      start: CellPosition(5, 5),
      answer: 'CARELESS',
      hint: 'Not giving much attention or consideration about something',
    ),
    Clue(
      number: 15, direction: 'D',
      start: CellPosition(6, 0),
      answer: 'HAIRCUT',
      hint: 'Salon service',
    ),
    Clue(
      number: 16, direction: 'D',
      start: CellPosition(6, 3),
      answer: 'STATION',
      hint: 'TV or radio channel',
    ),
    Clue(
      number: 18, direction: 'D',
      start: CellPosition(6, 11),
      answer: 'AVERAGE',
      hint: 'Mean, medium',
    ),
    Clue(
      number: 21, direction: 'D',
      start: CellPosition(8, 9),
      answer: 'BRAIN',
      hint: 'Organ in skull',
    ),
    Clue(
      number: 23, direction: 'D',
      start: CellPosition(9, 7),
      answer: 'THAT',
      hint: 'Word used to point out people or things that are distant',
    ),
  ],
);