import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, List<List<int>>> levelLayouts = {
  "1": [[1,1,1,1,1,0],[1,0,1,0,1,0],[1,1,1,1,1,1],[1,0,1,0,0,1],[0,1,1,1,1,1]],
  "2": [[0,1,1,1,0],[1,1,0,1,1],[1,1,1,1,1],[1,1,0,1,1],[0,1,1,1,0]],
  "3": [[1,0,1,1,1],[1,1,1,0,1],[1,0,1,1,1],[1,1,1,0,1],[0,0,1,1,1]],
  "4": [[1,1,1,1,1],[1,0,1,0,1],[1,1,1,1,1],[0,1,0,1,0],[1,1,1,1,1]],
};

class GenericLevelSelection extends StatefulWidget {
  final String title;
  final List<_LevelCardConfig> cardConfigs;

  const GenericLevelSelection({
    super.key,
    required this.title,
    required this.cardConfigs,
  });

  @override
  State<GenericLevelSelection> createState() => _GenericLevelSelectionState();
}

class _GenericLevelSelectionState extends State<GenericLevelSelection> {
  int _refreshKey = 0;

  void _refresh() => setState(() => _refreshKey++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 243, 243),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Cross Puzzle', style: TextStyle(color: Colors.black45)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(widget.title, style: const TextStyle(fontSize: 36)),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              childAspectRatio: 0.82,
              children: widget.cardConfigs.map((cfg) {
                return LevelCard(
                  key: ValueKey('${cfg.levelDataId}_$_refreshKey'),
                  levelId: cfg.levelId,
                  levelDataId: cfg.levelDataId,
                  totalClues: cfg.totalClues,
                  onTap: () async {
                    await cfg.navigate(context);
                    _refresh();
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCardConfig {
  final String levelId;       
  final String levelDataId;   
  final int totalClues;
  final Future<void> Function(BuildContext context) navigate;

  const _LevelCardConfig({
    required this.levelId,
    required this.levelDataId,
    required this.totalClues,
    required this.navigate,
  });
}

class LevelSelectionPage extends StatelessWidget {
  final String title;
  final List<LevelCardData> levels;

  const LevelSelectionPage({
    super.key,
    required this.title,
    required this.levels,
  });

  @override
  Widget build(BuildContext context) {
    return GenericLevelSelection(
      title: title,
      cardConfigs: levels
          .map((l) => _LevelCardConfig(
                levelId: l.levelId,
                levelDataId: l.levelDataId,
                totalClues: l.totalClues,
                navigate: l.navigate,
              ))
          .toList(),
    );
  }
}

class LevelCardData {
  final String levelId;
  final String levelDataId;
  final int totalClues;
  final Future<void> Function(BuildContext context) navigate;

  const LevelCardData({
    required this.levelId,
    required this.levelDataId,
    required this.totalClues,
    required this.navigate,
  });
}

class LevelCard extends StatefulWidget {
  final String levelId;
  final String levelDataId;
  final int totalClues;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.levelId,
    required this.levelDataId,
    required this.totalClues,
    this.onTap,
  });

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('progress_${widget.levelDataId}') ?? 0;
    if (mounted) setState(() => _correctCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final progress = '$_correctCount/${widget.totalClues}';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black87, width: 1.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CrosswordGrid(levelId: widget.levelId),
              ),
            ),
            Container(
              height: 38,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black87, width: 1.2)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.levelId,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text(progress,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CrosswordGrid extends StatelessWidget {
  final String levelId;
  const CrosswordGrid({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    final layout = levelLayouts[levelId] ?? levelLayouts["1"]!;
    return Column(
      children: layout.map((row) => Expanded(
        child: Row(
          children: row.map((cell) => Expanded(
            child: Container(
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: cell == 1 ? const Color(0xFFDCDCDC) : const Color(0xFF636363),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          )).toList(),
        ),
      )).toList(),
    );
  }
}