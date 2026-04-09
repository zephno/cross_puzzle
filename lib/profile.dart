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

  // Bio
  bool _isEditingBio = false;
  final TextEditingController _bioController = TextEditingController();

  // Stats
  int _soloGamesPlayed = 0;
  int _soloLevelsCompleted = 0;
  int _multiplayerCount = 0;
  int _dailyStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    // ── Login status ──────────────────────────────────────────────
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final name = prefs.getString('username') ?? '';

    // ── Bio ───────────────────────────────────────────────────────
    final savedBio = prefs.getString('bio') ??
        '"A puzzle is not a test of what you already know, but an invitation to see how different parts find their purpose in the whole."';

    // ── Solo stats ────────────────────────────────────────────────
    int played = 0;
    int completed = 0;

    for (final id in _allLevelIds) {
      final entries = prefs.getString('entries_$id') ?? '';
      if (entries.isNotEmpty) played++;

      final correctCount = prefs.getInt('progress_$id') ?? 0;
      final totalClues = _levelClueCounts[id] ?? 0;
      if (totalClues > 0 && correctCount >= totalClues) completed++;
    }

    // ── Daily / multiplayer stats ─────────────────────────────────
    final multi = prefs.getInt('stat_multiplayer_count') ?? 0;
    final streak = prefs.getInt('daily_streak') ?? 0;

    setState(() {
      isLoggedIn = loggedIn;
      username = name;
      _bioController.text = savedBio;
      _soloGamesPlayed = played;
      _soloLevelsCompleted = completed;
      _multiplayerCount = multi;
      _dailyStreak = streak;
    });
  }

  Future<void> _saveBio(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bio', value);
    setState(() => _isEditingBio = false);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      isLoggedIn = false;
      username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Color.fromARGB(255, 56, 132, 138),
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
                      // ── Welcome ─────────────────────────────────
                      Text(
                        'Welcome, $username!',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // ── Avatar ──────────────────────────────────
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(255, 205, 204, 204),
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 12),

                      // ── Logout ──────────────────────────────────
                      FilledButton(
                        onPressed: _logout,
                        style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 56, 132, 138),
                        ),
                        child: const Text('Logout'),
                      ),
                      const SizedBox(height: 20),

                      // ── Bio card ────────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'BIO',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_isEditingBio) {
                                      _saveBio(_bioController.text);
                                    } else {
                                      setState(() => _isEditingBio = true);
                                    }
                                  },
                                  child: Text(
                                    _isEditingBio ? 'Save' : 'Edit',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 56, 132, 138),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _isEditingBio
                                ? TextField(
                                    controller: _bioController,
                                    maxLines: null,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          'Write something about yourself...',
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  )
                                : Text(
                                    _bioController.text.isNotEmpty
                                        ? _bioController.text
                                        : 'Write something about yourself...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _bioController.text.isNotEmpty
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Stats grid ──────────────────────────────
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStatCard('Daily Puzzle Streak', '$_dailyStreak'),
                          _buildStatCard('Multiplayer Game Count', '$_multiplayerCount'),
                          _buildStatCard('Solo Levels Played', '$_soloGamesPlayed'),
                          _buildStatCard('Solo Levels Completed', '$_soloLevelsCompleted'),
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
                color: Color.fromARGB(255, 56, 132, 138),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
