import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'screens/game_screen.dart';
import 'data/medium/mediumlevel1.dart';
import 'data/medium/mediumlevel2.dart';
import 'data/medium/mediumlevel3.dart';
import 'data/medium/mediumlevel4.dart';

class MediumLevelsPage extends StatelessWidget {
  const MediumLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LevelSelectionPage(
      title: "Medium",
      levels: [
        LevelCardData(
          levelId: "1",
          levelDataId: mediumLevel1.id,
          totalClues: mediumLevel1.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: mediumLevel1)),
          ),
        ),
        LevelCardData(
          levelId: "2",
          levelDataId: mediumLevel2.id,
          totalClues: mediumLevel2.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: mediumLevel2)),
          ),
        ),
        LevelCardData(
          levelId: "3",
          levelDataId: mediumLevel3.id,
          totalClues: mediumLevel3.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: mediumLevel3)),
          ),
        ),
        LevelCardData(
          levelId: "4",
          levelDataId: mediumLevel4.id,
          totalClues: mediumLevel4.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: mediumLevel4)),
          ),
        ),
      ],
    );
  }
}
