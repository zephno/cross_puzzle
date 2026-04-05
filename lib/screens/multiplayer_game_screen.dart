import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/level_data.dart';
import '../services/matchmaking_service.dart';
import 'round_result_screen.dart';
import '../data/easy/easylevel1.dart';
import '../data/easy/easylevel2.dart';
import '../data/easy/easylevel3.dart';
import '../data/easy/easylevel4.dart';
import '../data/medium/mediumlevel1.dart';
import '../data/medium/mediumlevel2.dart';
import '../data/medium/mediumlevel3.dart';
import '../data/medium/mediumlevel4.dart';
import '../data/hard/hardlevel1.dart';
import '../data/hard/hardlevel2.dart';
import '../data/hard/hardlevel3.dart';
import '../data/hard/hardlevel4.dart';

final Map<String, LevelData> _allLevels = {
  'easy_1': easyLevel1, 'easy_2': easyLevel2,
  'easy_3': easyLevel3, 'easy_4': easyLevel4,
  'medium_1': mediumLevel1, 'medium_2': mediumLevel2,
  'medium_3': mediumLevel3, 'medium_4': mediumLevel4,
  'hard_1': hardLevel1, 'hard_2': hardLevel2,
  'hard_3': hardLevel3, 'hard_4': hardLevel4,
};

class MultiplayerGameScreen extends StatefulWidget {
  final String roomId;
  final String username;
  final String opponentUsername;

  const MultiplayerGameScreen({
    super.key,
    required this.roomId,
    required this.username,
    required this.opponentUsername,
  });

  @override
  State<MultiplayerGameScreen> createState() => _MultiplayerGameScreenState();
}

class _MultiplayerGameScreenState extends State<MultiplayerGameScreen> {
  final Map<String, String> _entries = {};
  Clue? _selectedClue;
  int _focusedLetterIndex = 0;
  final Map<String, bool?> _clueResults = {};

  LevelData? _level;
  int _currentRound = 1;
  bool _roundEnded = false;

  // Opponent progress (0–100%)
  int _opponentCorrect = 0;
  int _opponentTotal = 1;

  StreamSubscription? _roomSub;
  StreamSubscription? _opponentSub;

  @override
  void initState() {
    super.initState();
    _listenToRoom();
  }

  @override
  void dispose() {
    _roomSub?.cancel();
    _opponentSub?.cancel();
    super.dispose();
  }

  // ── Listen to the room doc ─────────────────────────────────────
  void _listenToRoom() {
    _roomSub = MatchmakingService.roomStream(widget.roomId).listen((snap) {
      if (!snap.exists || !mounted) return;
      final data = snap.data() as Map<String, dynamic>;

      final round = data['currentRound'] as int? ?? 1;
      final levels = List<String>.from(data['roundLevels'] ?? []);
      final winners = List<String>.from(data['roundWinners'] ?? ['', '', '']);
      final status = data['status'] as String? ?? 'playing';

      // If round changed externally, load new puzzle
      if (round != _currentRound || _level == null) {
        _loadRound(round, levels);
      }

      // Check if this round just got a winner
      if (round <= 3 && winners[round - 1].isNotEmpty && !_roundEnded) {
        setState(() {
          _roundEnded = true;
        });
        _navigateToRoundResult(winners, round, status);
      }

      setState(() {});
    });

    _listenToOpponent();
  }

  // ── Listen to opponent's progress ─────────────────────────────
  void _listenToOpponent() {
    _opponentSub = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('players')
        .doc(widget.opponentUsername)
        .snapshots()
        .listen((snap) {
      if (!snap.exists || !mounted || _level == null) return;
      final data = snap.data() as Map<String, dynamic>;
      final encoded =
          data['round_${_currentRound}_entries'] as String? ?? '';
      int correct = 0;
      if (encoded.isNotEmpty) {
        final opponentEntries = <String, String>{};
        for (final part in encoded.split(';')) {
          final eq = part.indexOf('=');
          if (eq == -1) continue;
          opponentEntries[part.substring(0, eq)] = part.substring(eq + 1);
        }
        for (final clue in _level!.clues) {
          bool clueCorrect = true;
          bool hasAnyLetter = false;
          for (int i = 0; i < clue.length; i++) {
            final entered =
                (opponentEntries[_cellKeyFromClue(clue, i)] ?? '').toUpperCase();
            if (entered.isNotEmpty) hasAnyLetter = true;
            if (entered != clue.answer[i]) {
              clueCorrect = false;
              break;
            }
          }
          if (clueCorrect && hasAnyLetter) correct++;
        }
      }
      setState(() {
        _opponentCorrect = correct;
        _opponentTotal = _level!.clues.length;
      });
    });
  }

  // ── Load a round's puzzle ──────────────────────────────────────
  void _loadRound(int round, List<String> levels) {
    if (levels.isEmpty) return;
    final levelId = levels[round - 1];
    final level = _allLevels[levelId];
    if (level == null) return;
    setState(() {
      _currentRound = round;
      _level = level;
      _entries.clear();
      _clueResults.clear();
      _selectedClue = null;
      _focusedLetterIndex = 0;
      _roundEnded = false;
      _opponentCorrect = 0;
      _opponentTotal = level.clues.length;
    });
    _opponentSub?.cancel();
    _listenToOpponent();
  }

  // ── Navigate to round result screen ───────────────────────────
  void _navigateToRoundResult(
      List<String> winners, int round, String status) async {
    final myWins = winners.where((w) => w == widget.username).length;
    final theirWins =
        winners.where((w) => w == widget.opponentUsername).length;

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoundResultScreen(
          round: round,
          totalRounds: 3,
          winnerUsername: winners[round - 1],
          myUsername: widget.username,
          opponentUsername: widget.opponentUsername,
          myWins: myWins,
          opponentWins: theirWins,
          isMatchOver: status == 'finished' || round == 3,
          roomId: widget.roomId,
        ),
      ),
    );

    if (status == 'finished' || round == 3) {
      await MatchmakingService.incrementMultiplayerCount();
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } else {
      if (mounted) {
        setState(() {
          _roundEnded = false;
        });
      }
    }
  }

  // ── Cell key helpers ───────────────────────────────────────────
  String _cellKeyFromClue(Clue clue, int index) {
    final row =
        clue.direction == 'A' ? clue.start.row : clue.start.row + index;
    final col =
        clue.direction == 'A' ? clue.start.col + index : clue.start.col;
    return '$row,$col';
  }

  String _cellKey(Clue clue, int index) => _cellKeyFromClue(clue, index);
  String _entryAt(int row, int col) => _entries['$row,$col'] ?? '';

  // ── My live correct clue count (no Check press needed) ────────
  int _myCorrectCount() {
    if (_level == null) return 0;
    int correct = 0;
    for (final clue in _level!.clues) {
      bool clueCorrect = true;
      bool hasAnyLetter = false;
      for (int i = 0; i < clue.length; i++) {
        final entered =
            (_entries[_cellKey(clue, i)] ?? '').toUpperCase();
        if (entered.isNotEmpty) hasAnyLetter = true;
        if (entered != clue.answer[i]) {
          clueCorrect = false;
          break;
        }
      }
      if (clueCorrect && hasAnyLetter) correct++;
    }
    return correct;
  }

  // ── Input handling ─────────────────────────────────────────────
  void _selectClue(Clue clue, {int letterIndex = 0}) {
    setState(() {
      _selectedClue = clue;
      _focusedLetterIndex = letterIndex.clamp(0, clue.length - 1);
    });
  }

  void _onCellTap(int row, int col) {
    final level = _level;
    if (level == null) return;
    final cluesHere = level.cluesForCell(row, col);
    if (cluesHere.isEmpty) return;

    if (_selectedClue != null && cluesHere.contains(_selectedClue!)) {
      setState(() =>
          _focusedLetterIndex = level.letterIndex(_selectedClue!, row, col));
      return;
    }

    final clue = cluesHere.firstWhere(
      (c) => c.direction == 'A',
      orElse: () => cluesHere.first,
    );
    _selectClue(clue, letterIndex: level.letterIndex(clue, row, col));
  }

  void _onKeyTap(String key) {
    if (_selectedClue == null || _level == null || _roundEnded) return;
    final clue = _selectedClue!;
    final cellKey = _cellKey(clue, _focusedLetterIndex);

    setState(() {
      if (key == '⌫') {
        if ((_entries[cellKey] ?? '').isNotEmpty) {
          _entries[cellKey] = '';
        } else if (_focusedLetterIndex > 0) {
          _focusedLetterIndex--;
          _entries[_cellKey(clue, _focusedLetterIndex)] = '';
        }
      } else {
        _entries[cellKey] = key;
        if (_focusedLetterIndex < clue.length - 1) _focusedLetterIndex++;
      }
      _clueResults.remove(clue.id);
    });

    MatchmakingService.saveEntries(
      roomId: widget.roomId,
      username: widget.username,
      round: _currentRound,
      entries: _entries,
    );

    if (_isPuzzleComplete && !_roundEnded) {
      _onPuzzleComplete();
    }
  }

  // ── Check selected clue ────────────────────────────────────────
  void _checkAnswer() {
    if (_selectedClue == null || _level == null) return;
    final clue = _selectedClue!;
    bool correct = true;
    for (int i = 0; i < clue.length; i++) {
      final entered = (_entries[_cellKey(clue, i)] ?? '').toUpperCase();
      if (entered != clue.answer[i]) {
        correct = false;
        break;
      }
    }
    setState(() {
      _clueResults[clue.id] = correct;
    });

    if (_isPuzzleComplete && !_roundEnded) {
      _onPuzzleComplete();
    }
  }

  // ── Clear all entries ──────────────────────────────────────────
  void _clearEntries() {
    setState(() {
      _entries.clear();
      _clueResults.clear();
      _selectedClue = null;
    });
    MatchmakingService.saveEntries(
      roomId: widget.roomId,
      username: widget.username,
      round: _currentRound,
      entries: _entries,
    );
  }

  bool get _isPuzzleComplete {
    final level = _level;
    if (level == null) return false;
    for (final clue in level.clues) {
      for (int i = 0; i < clue.length; i++) {
        final entered = (_entries[_cellKey(clue, i)] ?? '').toUpperCase();
        if (entered != clue.answer[i]) return false;
      }
    }
    return true;
  }

  void _onPuzzleComplete() {
    setState(() => _roundEnded = true);

    for (final c in _level!.clues) {
      _clueResults[c.id] = true;
    }

    MatchmakingService.markRoundComplete(
      roomId: widget.roomId,
      username: widget.username,
      round: _currentRound,
    ).then((_) {
      if (_currentRound == 3) {
        MatchmakingService.finishMatch(widget.roomId);
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          MatchmakingService.advanceRound(
            roomId: widget.roomId,
            nextRound: _currentRound + 1,
          );
        });
      }
    });
  }

  // ── Cell color ─────────────────────────────────────────────────
  Color _cellColor(int row, int col) {
    final level = _level;
    if (level == null) return const Color(0xFF636363);
    if (level.grid[row][col] == 0) return const Color(0xFF636363);

    final cluesHere = level.cluesForCell(row, col);
    for (final clue in cluesHere) {
      if (_clueResults.containsKey(clue.id)) {
        return _clueResults[clue.id]!
            ? const Color(0xFFD4EDDA)
            : const Color(0xFFF8D7DA);
      }
    }

    if (_selectedClue != null && cluesHere.contains(_selectedClue!)) {
      final idx = level.letterIndex(_selectedClue!, row, col);
      if (idx == _focusedLetterIndex) return const Color(0xFFFFE082);
      return const Color(0xFFBBDEFB);
    }

    return const Color.fromARGB(255, 248, 243, 243);
  }

  // ── Clue navigation ────────────────────────────────────────────
  void _nextClue() {
    final level = _level;
    if (level == null) return;
    final all = level.clues;
    if (all.isEmpty) return;
    if (_selectedClue == null) {
      _selectClue(all.first);
      return;
    }
    final idx = all.indexOf(_selectedClue!);
    _selectClue(all[(idx + 1) % all.length]);
  }

  void _previousClue() {
    final level = _level;
    if (level == null) return;
    final all = level.clues;
    if (all.isEmpty) return;
    if (_selectedClue == null) {
      _selectClue(all.last);
      return;
    }
    final idx = all.indexOf(_selectedClue!);
    _selectClue(all[(idx - 1 + all.length) % all.length]);
  }

  int? _clueNumberAt(int row, int col) {
    if (_level == null) return null;
    for (final clue in _level!.clues) {
      if (clue.start.row == row && clue.start.col == col) return clue.number;
    }
    return null;
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_level == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1565C0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text('Loading puzzle...',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      );
    }

    // FIX: use _myCorrectCount() so the bar updates on every keystroke
    final myProgress = _level!.clues.isEmpty
        ? 0.0
        : _myCorrectCount() / _level!.clues.length;
    final oppProgress =
        _opponentTotal == 0 ? 0.0 : _opponentCorrect / _opponentTotal;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showQuitDialog(),
        ),
        title: Text(
          'Round $_currentRound of 3',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressBar(myProgress, oppProgress),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildGrid(),
              ),
            ),
          ),
          _buildHintBar(),
          _buildKeyboard(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double myProgress, double oppProgress) {
    return Container(
      color: const Color(0xFF1A237E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: myProgress,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF69F0AE)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('VS',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.opponentUsername,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: oppProgress,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF5252)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final level = _level!;
    return AspectRatio(
      aspectRatio: level.cols / level.rows,
      child: Column(
        children: List.generate(level.rows, (r) {
          return Expanded(
            child: Row(
              children: List.generate(level.cols, (c) {
                return Expanded(child: _buildCell(r, c));
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    final level = _level!;
    final isActive = level.grid[row][col] == 1;
    final clueNum = _clueNumberAt(row, col);
    final letter = _entryAt(row, col);
    final color = _cellColor(row, col);

    return GestureDetector(
      onTap: isActive ? () => _onCellTap(row, col) : null,
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1),
        ),
        child: isActive
            ? Stack(
                children: [
                  if (clueNum != null)
                    Positioned(
                      top: 1,
                      left: 2,
                      child: Text(
                        '$clueNum',
                        style: const TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                  Center(
                    child: Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 221, 77, 77),
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildHintBar() {
    final hint = _selectedClue?.hint ?? 'Tap a cell to begin';
    final label = _selectedClue != null
        ? '${_selectedClue!.number} ${_selectedClue!.direction == 'A' ? 'Across' : 'Down'}'
        : '';

    return Container(
      color: const Color(0xFF1565C0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: _previousClue,
          ),
          Expanded(
            child: Column(
              children: [
                if (label.isNotEmpty)
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11)),
                Text(hint,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: _nextClue,
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    const rows = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '⌫'],
    ];

    return Container(
      color: const Color.fromARGB(255, 200, 200, 200),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                final isBackspace = key == '⌫';
                return GestureDetector(
                  onTap: () => _onKeyTap(key),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: isBackspace ? 44 : 32,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _roundEnded ? Colors.grey[300] : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ],
                    ),
                    child: Center(
                      child: Text(key,
                          style: TextStyle(
                            fontSize: isBackspace ? 18 : 14,
                            fontWeight: FontWeight.w600,
                            color: _roundEnded
                                ? Colors.black38
                                : Colors.black87,
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: const Color(0xFF9E9E9E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _roundEnded ? null : _clearEntries,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Clear',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _roundEnded ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text(
                'Check',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quit Match?'),
        content: const Text(
            'Are you sure you want to leave? Your opponent will win by default.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () async {
              await MatchmakingService.finishMatch(widget.roomId);
              if (mounted) {
                Navigator.of(context).popUntil((r) => r.isFirst);
              }
            },
            child: const Text('Quit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
