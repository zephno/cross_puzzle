import 'package:crosspuzzle/models/level_data.dart';
 
const LevelData hardLevel3 = LevelData(
  id: 'hard_3',
  difficulty: 'hard',
  grid: [
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1], // r0
    [1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1], // r1
    [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1], // r2
    [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], // r3
    [1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1], // r4
    [0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1], // r5
    [1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1], // r6
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0], //r7
    [1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1], //r8
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1], //r9
    [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1], //r10
    [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1], //r11
    [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1], //r12
  ],
  clues: [
    // ── ACROSS ────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'A',
      start: CellPosition(0, 0),
      answer: 'CASCADE',
      hint: 'Waterfall or series of stages',
    ),
    Clue(
      number: 7, direction: 'A',
      start: CellPosition(1, 6),
      answer: 'UTILISE',
      hint: 'Make practical use of something',
    ),
    Clue(
      number: 8, direction: 'A',
      start: CellPosition(2, 2),
      answer: 'RIVER',
      hint: 'Flowing body of water',
    ),
    Clue(
      number: 10, direction: 'A',
      start: CellPosition(3, 6),
      answer: 'EGGHEAD',
      hint: 'Slang for intellectual person',
    ),
    Clue(
      number: 11, direction: 'A',
      start: CellPosition(4, 0),
      answer: 'DAILY',
      hint: 'Every 24 hours',
    ),
    Clue(
      number: 12, direction: 'A',
      start: CellPosition(5, 4),
      answer: 'AVALANCHE',
      hint: 'Landslide of snow and ice',
    ),
    Clue(
      number: 16, direction: 'A',
      start: CellPosition(7, 0),
      answer: 'HARVESTER',
      hint: 'Machine for gathering crops',
    ),
    Clue(
      number: 18, direction: 'A',
      start: CellPosition(8, 8),
      answer: 'BRING',
      hint: 'Take along with one',
    ),
    Clue(
      number: 20, direction: 'A',
      start: CellPosition(9, 0),
      answer: 'NAMIBIA',
      hint: 'Capital: Windhoek',
    ),
    Clue(
      number: 23, direction: 'A',
      start: CellPosition(10, 6),
      answer: 'MIGHT',
      hint: 'Power, Strength',
    ),
    Clue(
      number: 24, direction: 'A',
      start: CellPosition(11, 0),
      answer: 'STORAGE',
      hint: 'Word for keeping items, data, etc.',
    ),
    Clue(
        number: 25, direction: 'A',
        start: CellPosition(12, 6),
        answer: 'SERPENT',
        hint: 'A snake, especially a large one',
      ),
    // ── DOWN ──────────────────────────────────────────────────────
    Clue(
      number: 1, direction: 'D',
      start: CellPosition(0, 0),
      answer: 'CROWD',
      hint: 'Large group of people',
    ),
    Clue(
      number: 2, direction: 'D',
      start: CellPosition(0, 2),
      answer: 'SURVIVOR',
      hint: 'Person who managed to escape a dangerous situation',
    ),
    Clue(
      number: 3, direction: 'D',
      start: CellPosition(0, 6),
      answer: 'EUREKA',
      hint: 'Exclamation upon realizing something',
    ),
    Clue(
      number: 4, direction: 'D',
      start: CellPosition(0, 8),
      answer: 'SING',
      hint: 'Vocalize',
    ),
    Clue(
      number: 5, direction: 'D',
      start: CellPosition(0, 10),
      answer: 'FIRE',
      hint: 'Dismissal from a job',
    ),
    Clue(
      number: 6, direction: 'D',
      start: CellPosition(0, 12),
      answer: 'HEADSET',
      hint: 'Output device for listening to audio',
    ),
    Clue(
      number: 9, direction: 'D',
      start: CellPosition(2, 4),
      answer: 'VOYAGE',
      hint: 'A long, often adventurous journey, typically taken by sea or in space',
    ),
    Clue(
      number: 13, direction: 'D',
      start: CellPosition(5, 8),
      answer: 'AIRBAG',
      hint: 'Safety device in vehicles',
    ),
    Clue(
      number: 14, direction: 'D',
      start: CellPosition(5, 10),
      answer: 'CHRISTIE',
      hint: 'AGATHA ________, famous mystery writer',
    ),
    Clue(
      number: 15, direction: 'D',
      start: CellPosition(6, 0),
      answer: 'SHYNESS',
      hint: 'Lack of confidence or timidity',
    ),
    Clue(
      number: 17, direction: 'D',
      start: CellPosition(7, 6),
      answer: 'THAMES',
      hint: 'Large river in England',
    ),
    Clue(
      number: 19, direction: 'D',
      start: CellPosition(8, 12),
      answer: 'GHOST',
      hint: 'Large river in England',
    ),
    Clue(
      number: 21, direction: 'D',
      start: CellPosition(9, 2),
      answer: 'MOON',
      hint: 'Satellite of Earth',
    ),
    Clue(
      number: 22, direction: 'D',
      start: CellPosition(9, 4),
      answer: 'BEAR',
      hint: 'Ursine animal',
    ),
  ],
);
