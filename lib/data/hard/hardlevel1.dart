import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData hardLevel1 = LevelData(
  id: 'hard_1',
  difficulty: 'hard',
  grid: [
    [1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1], // r0
    [1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1], // r1
    [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1], // r2
    [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], // r3
    [1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1], // r4
    [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1], // r5
    [0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0], // r6
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1], //r7
    [1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1], //r8
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1], //r9
    [1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1], //r10
    [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1], //r11
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1], //r12
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'FAMILIAR',
      hint: 'Well known to someone',
    ),
    Clue(
      number: 5, direction: 'A',
      start: CellPosition(0, 9),
      answer: 'FLAT',
      hint: 'APARTMENT',
    ),
    Clue(
      number: 8, direction: 'A',
      start: CellPosition(2, 0),
      answer: 'RECYCLED',
      hint: 'Use (materials) again',
    ),
    Clue(
      number: 10, direction: 'A',
      start: CellPosition(3, 6),
      answer: 'DIGITAL',
      hint: 'Opposite of Analog',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(4, 0),
      answer: 'START',
      hint: 'Begin',
    ),
    Clue(
      number: 12, direction: 'A',
      start: CellPosition(5, 4),
      answer: 'EFFICIENT',
      hint: 'Effective in doing what is required',
    ),
        
    Clue(
      number: 15, direction: 'A',
      start: CellPosition(7, 0),
      answer: 'ENCOURAGE',
      hint: 'Inspire',
    ),
    Clue(
      number: 18, direction: 'A',
      start: CellPosition(8, 8),
      answer: 'NURSE',
      hint: 'Healthcare worker',
    ),
    Clue(
      number: 19, direction: 'A',
      start: CellPosition(9, 0),
      answer: 'PROBLEM',
      hint: 'Matter to be solved',
    ),
    Clue(
      number: 22, direction: 'A',
      start: CellPosition(10, 5),
      answer: 'REVISION',
      hint: 'Act of rewiriting something, correction',
    ),
    Clue(
      number: 23, direction: 'A',
      start: CellPosition(12, 0),
      answer: 'TURN',
      hint: 'Not go straight, change direction',
    ),
    Clue(
      number: 24, direction: 'A',
      start: CellPosition(12, 5),
      answer: 'INTEREST',
      hint: 'Curiosity about something',
    ),
    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'D',
      start: CellPosition(0, 0),
      answer: 'FOREST',
      hint: 'Trees grow here',
    ),
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 2),
      answer: 'MECHANIC',
      hint: 'Person who repairs machines, especially cars',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(0, 4),
      answer: 'LOCATE',
      hint: 'To track down',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 6),
      answer: 'AGED',
      hint: 'Like good wine',
    ),
    Clue(
      number: 6, direction: 'D',
      start: CellPosition(0, 10),
      answer: 'LOST',
      hint: 'Failed to win',
    ),
    Clue(
      number: 7, direction: 'D',
      start: CellPosition(0, 12),
      answer: 'TABLET',
      hint: 'Slim personal computer that uses a touch screen',
    ),
    Clue(
      number: 9, direction: 'D',
      start: CellPosition(2, 7),
      answer: 'DIVING',
      hint: 'SCUBA ____',
    ),
    Clue(
      number: 13, direction: 'D',
      start: CellPosition(5, 5),
      answer: 'FARMER',
      hint: 'One who works the land',
    ),
    Clue(
      number: 14, direction: 'D',
      start: CellPosition(5, 10),
      answer: 'EXERCISE',
      hint: 'Physical effort to improve fitness',
    ),
    Clue(
      number: 15, direction: 'D',
      start: CellPosition(7, 0),
      answer: 'EXPECT',
      hint: 'Anticipate',
    ),
    Clue(
      number: 16, direction: 'D',
      start: CellPosition(7, 8),
      answer: 'ENGINE',
      hint: 'Powers a car',
    ),
    Clue(
      number: 17, direction: 'D',
      start: CellPosition(7, 12),
      answer: 'PEANUT',
      hint: 'Type of nut, salted or roasted',
    ),
    Clue(
      number: 20, direction: 'D',
      start: CellPosition(9, 2),
      answer: 'OVER',
      hint: 'Finished, done, ended',
    ),
    Clue(
      number: 21, direction: 'D',
      start: CellPosition(9, 6),
      answer: 'MEAN',
      hint: 'Not very nice',
    ),
  ],
);
