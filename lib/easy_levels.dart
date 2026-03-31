import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'screens/game_screen.dart';
import 'data/easy/easylevel1.dart';
import 'data/easy/easylevel2.dart';
import 'data/easy/easylevel3.dart';
import 'data/easy/easylevel4.dart';

class EasyLevelsPage extends StatelessWidget {
  const EasyLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LevelSelectionPage(
      title: "Easy",
      levels: [
        LevelCardData(
          levelId: "1",
          levelDataId: easyLevel1.id,
          totalClues: easyLevel1.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: easyLevel1)),
          ),
        ),
        LevelCardData(
          levelId: "2",
          levelDataId: easyLevel2.id,
          totalClues: easyLevel2.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: easyLevel2)),
          ),
        ),
        LevelCardData(
          levelId: "3",
          levelDataId: easyLevel3.id,
          totalClues: easyLevel3.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: easyLevel3)),
          ),
        ),
        LevelCardData(
          levelId: "4",
          levelDataId: easyLevel4.id,
          totalClues: easyLevel4.clues.length,
          navigate: (ctx) => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => GameScreen(level: easyLevel4)),
          ),
        ),
      ],
    );
  }
}