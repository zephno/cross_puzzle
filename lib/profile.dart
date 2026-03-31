import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'create_account.dart';

// All level IDs across every difficulty — add new ones here as you create them
const _allLevelIds = [
  'easy_1', 'easy_2', 'easy_3', 'easy_4',
  'medium_1', 'medium_2', 'medium_3', 'medium_4',
  'hard_1', 'hard_2', 'hard_3', 'hard_4',
];

// Clue counts per level — must match the actual clue list lengths in each
// level data file so the "completed" check works correctly.
const _levelClueCounts = {
  'easy_1': 16, 'easy_2': 11, 'easy_3': 14, 'easy_4': 11,
  'medium_1': 16, 'medium_2': 16, 'medium_3': 15, 'medium_4': 17,
  'hard_1': 21, 'hard_2': 20, 'hard_3': 22, 'hard_4': 23,
};

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;
  String username = '';

  // Stats
  int _soloGamesPlayed = 0;      // levels where the player has typed anything
  int _soloLevelsCompleted = 0;  // levels where every clue is marked correct
  int _multiplayerCount = 0;     // placeholder — wire up when multiplayer ships
  int _dailyPuzzleCount = 0;     // placeholder — wire up when daily puzzle ships
  int _dailyStreak = 0;          // placeholder — wire up when daily puzzle ships

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    // ── Login status ──────────────────────────────────────────────
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final name     = prefs.getString('username') ?? '';

    // ── Solo stats ────────────────────────────────────────────────
    int played    = 0;
    int completed = 0;

    for (final id in _allLevelIds) {
      // A level is "played" if an entries string exists for it
      final entries = prefs.getString('entries_$id') ?? '';
      if (entries.isNotEmpty) played++;

      // A level is "completed" if the number of correct clues equals the
      // total clue count for that level
      final correctCount = prefs.getInt('progress_$id') ?? 0;
      final totalClues   = _levelClueCounts[id] ?? 0;
      if (totalClues > 0 && correctCount >= totalClues) completed++;
    }

    // ── Multiplayer / Daily (placeholders) ────────────────────────
    final multi  = prefs.getInt('stat_multiplayer_count') ?? 0;
    final daily  = prefs.getInt('stat_daily_count')       ?? 0;
    final streak = prefs.getInt('stat_daily_streak')      ?? 0;

    setState(() {
      isLoggedIn           = loggedIn;
      username             = name;
      _soloGamesPlayed     = played;
      _soloLevelsCompleted = completed;
      _multiplayerCount    = multi;
      _dailyPuzzleCount    = daily;
      _dailyStreak         = streak;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      isLoggedIn = false;
      username   = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: isLoggedIn
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome, $username!',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 12),

                      FilledButton(
                        onPressed: _logout,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade600,
                        ),
                        child: const Text('Logout'),
                      ),

                      const SizedBox(height: 20),

                      // BIO card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'BIO',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '"A puzzle is not a test of what you already know, but an invitation to see how different parts find their purpose in the whole."',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStatCard('Daily Puzzle Streak',    '$_dailyStreak'),
                          _buildStatCard('Multiplayer Game Count', '$_multiplayerCount'),
                          _buildStatCard('Solo Levels Played',     '$_soloGamesPlayed'),
                          _buildStatCard('Solo Levels Completed',  '$_soloLevelsCompleted'),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You are not logged in",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAccountPage()),
                      );
                      if (result == true) _loadAll();
                    },
                    child: const Text("Create Account"),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      if (result == true) _loadAll();
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}