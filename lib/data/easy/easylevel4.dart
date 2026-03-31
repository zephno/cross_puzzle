import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData easyLevel4 = LevelData(
  id: 'easy_4',
  difficulty: 'Easy',
  grid: [
    [1, 1, 1, 0, 1, 1, 1], // r0
    [0, 1, 0, 1, 0, 1, 0], // r1
    [0, 1, 1, 1, 1, 1, 1], // r2
    [0, 0, 0, 1, 0, 0, 0], // r3
    [1, 1, 1, 1, 1, 1, 0], // r4
    [0, 1, 0, 1, 0, 1, 0], // r5
    [1, 1, 1, 0, 1, 1, 1], // r6
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'OFF',
      hint: 'Not working',
    ),
    Clue(
      number: 3, direction: 'A',
      start: CellPosition(0, 4),
      answer: 'OWE',
      hint: 'Be in debt',
    ),
    Clue(
      number: 6, direction: 'A',
      start: CellPosition(2, 1),
      answer: 'TATTOO',
      hint: 'Skin decoration',
    ),
    Clue(
      number: 7, direction: 'A',
      start: CellPosition(4, 0),
      answer: 'VIOLET',
      hint: 'Red-Blue Color',
    ),
    Clue(
      number: 10, direction: 'A',
      start: CellPosition(6, 0),
      answer: 'AND',
      hint: 'Connecting sign',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(6, 4),
      answer: 'HER',
      hint: 'Feminine possesive pronoun',
    ),
    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 1),
      answer: 'FIT',
      hint: 'In Good Shape',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 5),
      answer: 'WHO',
      hint: 'One of the five W\'s',
    ),
    Clue(
      number: 5, direction: 'D',
      start: CellPosition(1, 3),
      answer: 'ITALY',
      hint: 'Country where can eat pizza in Pisa',
    ),
    Clue(
      number: 8, direction: 'D',
      start: CellPosition(4, 1),
      answer: 'INN',
      hint: 'A place to stay when traveling',
    ),
    Clue(
      number: 9, direction: 'D',
      start: CellPosition(4, 5),
      answer: 'TOE',
      hint: 'One of the five digits on a foot',
    ),
  ],
);  