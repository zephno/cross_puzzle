import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData easyLevel3 = LevelData(
  id: 'easy_3',
  difficulty: 'Easy',
  grid: [
    [1, 0, 1, 1, 1, 0, 1], // r0
    [1, 1, 1, 0, 1, 1, 1], // r1
    [1, 0, 1, 0, 1, 0, 1], // r2
    [0, 1, 1, 1, 1, 1, 0], // r3
    [1, 0, 1, 0, 1, 0, 1], // r4
    [1, 1, 1, 0, 1, 1, 1], // r5
    [1, 0, 1, 1, 1, 0, 1], // r6
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 6, direction: 'A',
      start: CellPosition(1, 4),
      answer: 'OLD',
      hint: 'Showing some age',
    ),
    Clue(
      number: 10, direction: 'A',
      start: CellPosition(5, 0),
      answer: 'AGO',
      hint: 'Earlier',
    ),
    Clue(
      number: 2, direction: 'A',
      start: CellPosition(0, 2),
      answer: 'SIT',
      hint: 'Take a chair ',
    ),
    Clue(
      number: 5, direction: 'A',
      start: CellPosition(1, 0),
      answer: 'HOT',
      hint: 'Not cold',
    ),
    Clue(
      number: 7, direction: 'A',
      start: CellPosition(3, 1),
      answer: 'STARE',
      hint: 'A fixef look with eyes wide open',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(5, 4),
      answer: 'SPA',
      hint: 'A health resort near a spring or at the seaside',
    ),
    Clue(
        number: 12, direction: 'A',
        start: CellPosition(6, 2),
        answer: 'NOT',
        hint: 'False!',
    ),
    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 9, direction: 'D',
      start: CellPosition(4, 6),
      answer: 'BAD',
      hint: 'Not good',
    ),
    Clue(
      number: 8, direction: 'D',
      start: CellPosition(4, 0),
      answer: 'CAT',
      hint: 'Purring pet',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 6),
      answer: 'ODD',
      hint: 'Bizarre',
    ),
    Clue(
      number: 1, direction: 'D',
      start: CellPosition(0, 0),
      answer: 'SHY',
      hint: 'Lacking self-confidence in a social situation',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(0, 4),
      answer: 'TOURIST',
      hint: 'Someone who travles for pleasure',
    ),
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 2),
      answer: 'STATION',
      hint: 'A place where trains stop',
    ),
  ],
);  