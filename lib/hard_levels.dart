import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'screens/game_screen.dart';
import 'data/hard/hardlevel1.dart';
import 'data/hard/hardlevel2.dart';
import 'data/hard/hardlevel3.dart';
import 'data/hard/hardlevel4.dart';

class HardLevelsPage extends StatelessWidget {
  const HardLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LevelSelectionPage(
      title: "Hard",
      levels: [
        LevelCardData(
          levelId: "1",
          levelDataId: hardLevel1.id,
          totalClues: hardLevel1.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: hardLevel1)),
          ),
        ),
        LevelCardData(
          levelId: "2",
          levelDataId: hardLevel2.id,
          totalClues: hardLevel2.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: hardLevel2)),
          ),
        ),
        LevelCardData(
          levelId: "3",
          levelDataId: hardLevel3.id,
          totalClues: hardLevel3.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: hardLevel3)),
          ),
        ),
        LevelCardData(
          levelId: "4",
          levelDataId: hardLevel4.id,
          totalClues: hardLevel4.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: hardLevel4)),
          ),
        ),
      ],
    );
  }
}