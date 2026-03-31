import '../models/level_data.dart';
import 'easy/easylevel1.dart';
import 'easy/easylevel2.dart';
import 'easy/easylevel3.dart';
import 'easy/easylevel4.dart';
import 'medium/mediumlevel1.dart';
import 'medium/mediumlevel2.dart';
import 'medium/mediumlevel3.dart';
import 'medium/mediumlevel4.dart';

/// All puzzles available for the daily rotation.
/// They cycle in order: easy 1–4, then medium 1–4, then repeats.
const List<LevelData> kDailyPuzzles = [
  easyLevel1,
  easyLevel2,
  easyLevel3,
  easyLevel4,
  mediumLevel1,
  mediumLevel2,
  mediumLevel3,
  mediumLevel4,
];

/// Returns today's puzzle using a date-based index (timezone-safe).
LevelData getTodaysPuzzle() {
  final now = DateTime.now();
  // yyyyMMdd integer — unique per calendar day, timezone-safe
  final dateInt = now.year * 10000 + now.month * 100 + now.day;
  return kDailyPuzzles[dateInt % kDailyPuzzles.length];
}

/// Returns today's date as a string key, e.g. "20260330".
String todayKey() {
  final now = DateTime.now();
  return '${now.year}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}';
}