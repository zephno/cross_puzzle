import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/daily_puzzles.dart';
import 'game_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SharedPreferences keys
//   daily_completed_YYYYMMDD  → bool   (was today's puzzle finished?)
//   daily_last_date           → String (last date a puzzle was completed)
//   daily_streak              → int    (current streak count)
// ─────────────────────────────────────────────────────────────────────────────

class DailyPuzzleScreen extends StatefulWidget {
  const DailyPuzzleScreen({super.key});

  @override
  State<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends State<DailyPuzzleScreen> {
  bool _loading = true;
  bool _alreadyCompleted = false;
  int _streak = 0;
  Duration _timeUntilMidnight = Duration.zero;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _loadDailyState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── Load / update streak ──────────────────────────────────────────────────

  Future<void> _loadDailyState() async {
    final prefs = await SharedPreferences.getInstance();
    final today = todayKey();

    final completed = prefs.getBool('daily_completed_$today') ?? false;
    final streak = prefs.getInt('daily_streak') ?? 0;

    setState(() {
      _alreadyCompleted = completed;
      _streak = streak;
      _loading = false;
    });

    if (completed) _startCountdown();
  }

  Future<void> _markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final today = todayKey();

    // Streak logic
    final lastDate = prefs.getString('daily_last_date') ?? '';
    final yesterday = _yesterdayKey();
    int newStreak;
    if (lastDate == yesterday) {
      newStreak = (prefs.getInt('daily_streak') ?? 0) + 1;
    } else if (lastDate == today) {
      // Already counted today — shouldn't normally reach here
      newStreak = prefs.getInt('daily_streak') ?? 1;
    } else {
      newStreak = 1; // streak broken
    }

    await prefs.setBool('daily_completed_$today', true);
    await prefs.setString('daily_last_date', today);
    await prefs.setInt('daily_streak', newStreak);

    setState(() {
      _alreadyCompleted = true;
      _streak = newStreak;
    });

    _startCountdown();
    _showCompletionDialog(newStreak);
  }

  // ── Countdown to midnight ─────────────────────────────────────────────────

  void _startCountdown() {
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final midnight =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    setState(() {
      _timeUntilMidnight = midnight.difference(now);
    });
  }

  String get _countdownText {
    final h = _timeUntilMidnight.inHours.toString().padLeft(2, '0');
    final m = (_timeUntilMidnight.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_timeUntilMidnight.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _yesterdayKey() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}'
        '${yesterday.month.toString().padLeft(2, '0')}'
        '${yesterday.day.toString().padLeft(2, '0')}';
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showCompletionDialog(int streak) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '🎉 Puzzle Complete!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You solved today\'s crossword!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _StreakBadge(streak: streak),
            const SizedBox(height: 16),
            const Text(
              'Next puzzle in',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 4),
            StatefulBuilder(
              builder: (ctx, setS) {
                // Refresh countdown inside the dialog every second
                Future.delayed(const Duration(seconds: 1), () {
                  if (ctx.mounted) setS(() {});
                });
                return Text(
                  _countdownText,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                    letterSpacing: 2,
                  ),
                );
              },
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to home
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_alreadyCompleted) {
      return _AlreadyCompletedView(
        streak: _streak,
        countdown: _countdownText,
      );
    }

    // Not yet completed — launch GameScreen with a completion callback
    return _DailyGameWrapper(onCompleted: _markCompleted);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wraps GameScreen and intercepts the completion event
// ─────────────────────────────────────────────────────────────────────────────

class _DailyGameWrapper extends StatelessWidget {
  final VoidCallback onCompleted;
  const _DailyGameWrapper({required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    final puzzle = getTodaysPuzzle();
    return GameScreen(
      level: puzzle,
      isDailyMode: true,
      onDailyCompleted: onCompleted,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen shown when the daily puzzle is already done
// ─────────────────────────────────────────────────────────────────────────────

class _AlreadyCompletedView extends StatelessWidget {
  final int streak;
  final String countdown;

  const _AlreadyCompletedView({
    required this.streak,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daily Puzzle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 80, color: Color(0xFF1565C0)),
              const SizedBox(height: 16),
              const Text(
                "You've already completed\ntoday's puzzle!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _StreakBadge(streak: streak),
              const SizedBox(height: 32),
              const Text(
                'Next puzzle in',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                countdown,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 40),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable streak badge widget
// ─────────────────────────────────────────────────────────────────────────────

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            '$streak day streak',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE65100),
            ),
          ),
        ],
      ),
    );
  }
}