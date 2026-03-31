import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData easyLevel2 = LevelData(
  id: 'easy_2',
  difficulty: 'Easy',
  grid: [
    [1, 1, 1, 1, 1, 1, 1], // r0
    [0, 0, 0, 1, 0, 0, 0], // r1
    [1, 0, 1, 1, 1, 0, 1], // r2
    [1, 1, 1, 0, 1, 1, 1], // r3
    [1, 0, 1, 1, 1, 0, 1], // r4
    [0, 0, 0, 1, 0, 0, 0], // r5
    [1, 1, 1, 1, 1, 1, 1], // r6
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'MARRIED',
      hint: 'Having a Husband or a Wife',
    ),
    Clue(
      number: 4, direction: 'A',
      start: CellPosition(2, 2),
      answer: 'ADD',
      hint: 'Put together numbers',
    ),
    Clue(
      number: 7, direction: 'A',
      start: CellPosition(3, 0),
      answer: 'GPS',
      hint: 'Technology that keeps you from getting lost',
    ),
    Clue(
      number: 8, direction: 'A',
      start: CellPosition(3, 4),
      answer: 'AIR',
      hint: 'Mostly made of nitrogen',
    ),
    Clue(
      number: 9, direction: 'A',
      start: CellPosition(4, 2),
      answer: 'KID',
      hint: 'A young person of either sex',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(6, 0),
      answer: 'SCIENCE',
      hint: 'Subject such as physics, chemistry, or biology',
    ),
    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 3),
      answer: 'RID',
      hint: 'To free oneself from, with "of" ',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(2, 0),
      answer: 'EGG',
      hint: 'It has a yolk and a white',
    ),
    Clue(
      number: 5, direction: 'D',
      start: CellPosition(2, 4),
      answer: 'DAD',
      hint: 'Father',
    ),
    Clue(
      number: 6, direction: 'D',
      start: CellPosition(2, 6),
      answer: 'ARM',
      hint: 'Upper limb of the human body',
    ),
    Clue(
      number: 10, direction: 'D',
      start: CellPosition(4, 3),
      answer: 'ICE',
      hint: 'Frozen water',
    ),
  ],
);  