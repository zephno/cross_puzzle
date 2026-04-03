import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level_data.dart';

class GameScreen extends StatefulWidget {
  final LevelData level;
  final bool isDailyMode;
  final VoidCallback? onDailyCompleted;

  const GameScreen({
    super.key,
    required this.level,
    this.isDailyMode = false,
    this.onDailyCompleted,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // user's entered letters: key = "row,col"
  final Map<String, String> _entries = {};

  // currently selected clue
  Clue? _selectedClue;

  // currently focused cell within the selected clue
  int _focusedLetterIndex = 0;

  // text controllers per letter index of selected clue
  final List<FocusNode> _focusNodes = [];

  // track correct/incorrect state per clue after checking
  final Map<String, bool?> _clueResults = {};

  bool _hasChecked = false;

  // Cached prefs instance — obtained once in _loadState
  SharedPreferences? _prefs;

  LevelData get level => widget.level;

  // ── SharedPreferences keys ─────────────────────────────────────
  // In daily mode, keys are date-scoped so they don't clash with
  // normal level progress and reset automatically the next day.
  String get _entriesKey =>
      widget.isDailyMode ? 'entries_daily_${_todayKey()}' : 'entries_${level.id}';
  String get _progressKey =>
      widget.isDailyMode ? 'progress_daily_${_todayKey()}' : 'progress_${level.id}';
  String get _clueResultsKey =>
      widget.isDailyMode ? 'clue_results_daily_${_todayKey()}' : 'clue_results_${level.id}';

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // ── Derive theme color from difficulty / mode ─────────────────
  Color get _themeColor {
    if (widget.isDailyMode) return const Color(0xFF6A1B9A); // purple for daily
    if (level.id.startsWith('easy')) return Colors.green;
    if (level.id.startsWith('medium')) return const Color(0xFF1565C0);
    return Colors.red; // hard
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  // ── Persistence: load entries + clue results together ──────────

  Future<void> _loadState() async {
    // Obtain and cache the prefs instance once
    _prefs = await SharedPreferences.getInstance();

    // Load entries
    final savedEntries = _prefs!.getString(_entriesKey);
    final Map<String, String> loadedEntries = {};
    if (savedEntries != null && savedEntries.isNotEmpty) {
      for (final part in savedEntries.split(';')) {
        final eq = part.indexOf('=');
        if (eq == -1) continue;
        final key = part.substring(0, eq);
        final value = part.substring(eq + 1);
        // Store ALL entries including empty strings — empty means the user
        // backspaced that cell and it should stay blank after a restart.
        loadedEntries[key] = value;
      }
    }

    // Load clue results — stored as "clueId:t" or "clueId:f", joined by ";"
    final savedResults = _prefs!.getString(_clueResultsKey);
    final Map<String, bool?> loadedResults = {};
    if (savedResults != null && savedResults.isNotEmpty) {
      for (final part in savedResults.split(';')) {
        final colon = part.indexOf(':');
        if (colon == -1) continue;
        final clueId = part.substring(0, colon);
        final value = part.substring(colon + 1);
        loadedResults[clueId] = value == 't';
      }
    }

    setState(() {
      _entries.addAll(loadedEntries);
      _clueResults.addAll(loadedResults);
      // If any clue results were loaded, mark _hasChecked so the colours show
      if (_clueResults.isNotEmpty) _hasChecked = true;
    });
  }

  // ── Persistence: save entries ──────────────────────────────────

  Future<void> _saveEntries() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();

    // Save ALL entries including empty strings so backspaced cells
    // round-trip correctly after a restart.
    final allEntries = _entries.entries.toList();

    if (allEntries.isEmpty) {
      await prefs.remove(_entriesKey);
      return;
    }

    // Encode as "row,col=LETTER" pairs joined by ";".
    // Empty-value entries encode as "row,col=" which decodes correctly.
    final encoded = allEntries.map((e) => '${e.key}=${e.value}').join(';');
    await prefs.setString(_entriesKey, encoded);
  }

  // ── Persistence: save clue results ────────────────────────────

  Future<void> _saveClueResults() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();

    if (_clueResults.isEmpty) {
      await prefs.remove(_clueResultsKey);
      return;
    }
    final encoded = _clueResults.entries
        .map((e) => '${e.key}:${e.value == true ? 't' : 'f'}')
        .join(';');
    await prefs.setString(_clueResultsKey, encoded);
  }

  // ── Persistence: progress (correct clue count) ─────────────────

  Future<void> _saveProgress() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final correctCount = _clueResults.values.where((v) => v == true).length;
    await prefs.setInt(_progressKey, correctCount);
  }

  // ── Convenience: save everything in one shot ───────────────────

  Future<void> _saveAll() async {
    await _saveEntries();
    await _saveClueResults();
    await _saveProgress();
  }

  // ── State helpers ──────────────────────────────────────────────

  @override
  void dispose() {
    for (final fn in _focusNodes) fn.dispose();
    super.dispose();
  }

  void _selectClue(Clue clue, {int letterIndex = 0}) {
    setState(() {
      _selectedClue = clue;
      _focusedLetterIndex = letterIndex.clamp(0, clue.length - 1);
      _hasChecked = false;
    });
  }

  void _onCellTap(int row, int col) {
    final cluesHere = level.cluesForCell(row, col);
    if (cluesHere.isEmpty) return;

    if (_selectedClue != null && cluesHere.contains(_selectedClue!)) {
      final idx = level.letterIndex(_selectedClue!, row, col);
      setState(() => _focusedLetterIndex = idx);
      return;
    }

    final clue = cluesHere.firstWhere(
      (c) => c.direction == 'A',
      orElse: () => cluesHere.first,
    );
    _selectClue(clue, letterIndex: level.letterIndex(clue, row, col));
  }

  void _onKeyTap(String key) {
    if (_selectedClue == null) return;
    final clue = _selectedClue!;
    final cellKey = _cellKey(clue, _focusedLetterIndex);

    setState(() {
      if (key == '⌫') {
        if ((_entries[cellKey] ?? '').isNotEmpty) {
          _entries[cellKey] = '';
        } else if (_focusedLetterIndex > 0) {
          _focusedLetterIndex--;
          final prevKey = _cellKey(clue, _focusedLetterIndex);
          _entries[prevKey] = '';
        }
      } else {
        _entries[cellKey] = key;
        if (_focusedLetterIndex < clue.length - 1) _focusedLetterIndex++;
      }
      _hasChecked = false;
      _clueResults.remove(clue.id);
    });

    // Auto-mark all clues green if puzzle is complete after this keystroke
    if (_isPuzzleComplete) {
      setState(() {
        for (final c in level.clues) {
          _clueResults[c.id] = true;
        }
      });
    }

    _saveAll();
  }

  String _cellKey(Clue clue, int index) {
    final row =
        clue.direction == 'A' ? clue.start.row : clue.start.row + index;
    final col =
        clue.direction == 'A' ? clue.start.col + index : clue.start.col;
    return '$row,$col';
  }

  String _entryAt(int row, int col) => _entries['$row,$col'] ?? '';

  void _checkAnswer() {
    if (_selectedClue == null) return;
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
      _hasChecked = true;
    });

    // Auto-mark all clues green if puzzle is complete after this check
    if (_isPuzzleComplete) {
      setState(() {
        for (final c in level.clues) {
          _clueResults[c.id] = true;
        }
      });
    }

    _saveAll();
  }

  void _clearLevel() {
    setState(() {
      _entries.clear();
      _clueResults.clear();
      _selectedClue = null;
      _hasChecked = false;
    });
    _saveAll();
  }

  bool get _isPuzzleComplete {
    for (final clue in level.clues) {
      for (int i = 0; i < clue.length; i++) {
        final entered = (_entries[_cellKey(clue, i)] ?? '').toUpperCase();
        if (entered != clue.answer[i]) return false;
      }
    }
    return true;
  }

  Color _cellColor(int row, int col) {
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

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      appBar: AppBar(
        backgroundColor: _themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isDailyMode
              ? 'Daily Puzzle'
              : level.id
                  .replaceFirst('easy_', '')
                  .replaceFirst('medium_', '')
                  .replaceFirst('hard_', ''),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 107, 178, 216),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                SizedBox(width: 4),
                Text('26',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
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

  Widget _buildGrid() {
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
                            fontSize: 8,
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
                        color: Color.fromARGB(221, 49, 49, 49),
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  int? _clueNumberAt(int row, int col) {
    for (final clue in level.clues) {
      if (clue.start.row == row && clue.start.col == col) return clue.number;
    }
    return null;
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
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 11)),
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

  void _nextClue() {
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
    final all = level.clues;
    if (all.isEmpty) return;
    if (_selectedClue == null) {
      _selectClue(all.last);
      return;
    }
    final idx = all.indexOf(_selectedClue!);
    _selectClue(all[(idx - 1 + all.length) % all.length]);
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
                      color: Colors.white,
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
                            color: Colors.black87,
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
              onPressed: _clearLevel,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Clear level',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isPuzzleComplete
                  ? () => _showCompleteDialog()
                  : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                _isPuzzleComplete ? 'Finish' : 'Check',
                style: const TextStyle(
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

  // ── Completion dialog ──────────────────────────────────────────
  // In daily mode: calls onDailyCompleted() which hands off to
  // DailyPuzzleScreen for streak saving + countdown dialog.
  // In normal mode: pops back to the level select screen.

  void _showCompleteDialog() {
    // Mark all clues green on completion and persist
    setState(() {
      for (final c in level.clues) {
        _clueResults[c.id] = true;
      }
    });
    _saveAll();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Puzzle Complete! 🎉'),
        content: const Text('You solved the crossword!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              if (widget.isDailyMode && widget.onDailyCompleted != null) {
                widget.onDailyCompleted!(); // hand off to DailyPuzzleScreen
              } else {
                Navigator.pop(context); // normal: back to levels
              }
            },
            child: Text(widget.isDailyMode ? 'Finish' : 'Back to Levels'),
          ),
        ],
      ),
    );
  }
}
