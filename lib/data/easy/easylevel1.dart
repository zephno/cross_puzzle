import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData easyLevel1 = LevelData(
  id: 'easy_1',
  difficulty: 'Easy',
  grid: [
    [1, 1, 1, 0, 1, 1, 1], // r0
    [1, 0, 1, 1, 1, 0, 1], // r1
    [1, 1, 1, 0, 1, 1, 1], // r2
    [0, 0, 1, 0, 1, 0, 0], // r3
    [1, 1, 1, 0, 1, 1, 1], // r4
    [1, 0, 1, 1, 1, 0, 1], // r5
    [1, 1, 1, 0, 1, 1, 1], // r6
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'HIS',
      hint: 'Masculine possessive pronoun',
    ),
    Clue(
      number: 3, direction: 'A',
      start: CellPosition(0, 4),
      answer: 'TOP',
      hint: 'The highest point',
    ),
    Clue(
      number: 5, direction: 'A',
      start: CellPosition(1, 2),
      answer: 'TOO',
      hint: 'In addition',
    ),
    Clue(
      number: 6, direction: 'A',
      start: CellPosition(2, 0),
      answer: 'WAR',
      hint: 'An active struggle between competing entities',
    ),
    Clue(
      number: 7, direction: 'A',
      start: CellPosition(2, 4),
      answer: 'USE',
      hint: 'To employ or utilise',
    ),
    Clue(
      number: 8, direction: 'A',
      start: CellPosition(4, 0),
      answer: 'WIN',
      hint: 'To be victorious',
    ),
    Clue(
      number: 9, direction: 'A',
      start: CellPosition(4, 4),
      answer: 'INK',
      hint: 'Fluid for pen',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(5, 2),
      answer: 'GAS',
      hint: 'Neither solid nor liquid',
    ),
    Clue(
      number: 12, direction: 'A',
      start: CellPosition(6, 0),
      answer: 'SHE',
      hint: 'Female pronoun',
    ),
    Clue(
      number: 13, direction: 'A',
      start: CellPosition(6, 4),
      answer: 'MAY',
      hint: 'Fifth month of the year',
    ),
 
    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'D',
      start: CellPosition(0, 0),
      answer: 'HOW',
      hint: 'Interrogative adverb used to ask questions about the way an action occurs',
    ),
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 2),
      answer: 'STRANGE',
      hint: 'Unusual or bizarre',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(0, 4),
      answer: 'TOURISM',
      hint: 'Travel industry',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 6),
      answer: 'PIE',
      hint: 'Baked pastry dish',
    ),
    Clue(
      number: 8, direction: 'D',
      start: CellPosition(4, 0),
      answer: 'WAS',
      hint: 'Past tense of "is"',
    ),
    Clue(
      number: 10, direction: 'D',
      start: CellPosition(4, 6),
      answer: 'KEY',
      hint: 'Lock opener',
    ),
  ],
);