import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/matchmaking_service.dart';
import 'multiplayer_game_screen.dart';
import '../login.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  String _status = 'Searching for opponent...';
  String _username = '';
  bool _searching = true;
  bool _cancelled = false;
  bool _notLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  Future<void> _startSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    if (username.isEmpty) {
      setState(() {
        _status = 'You must be logged in to play multiplayer.';
        _searching = false;
        _notLoggedIn = true;
      });
      return;
    }

    

    setState(() => _username = username);



    try {
      final roomId = await MatchmakingService.findMatch(username: username);
      if (_cancelled || !mounted) return;

      // Find out who the opponent is
      final roomSnap = await MatchmakingService.roomStream(roomId).first;
      final data = roomSnap.data() as Map<String, dynamic>;
      final player1 = data['player1'] as String;
      final player2 = data['player2'] as String;
      final opponent = player1 == username ? player2 : player1;

      if (!mounted) return;

      // Replace this screen with the game screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MultiplayerGameScreen(
            roomId: roomId,
            username: username,
            opponentUsername: opponent,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = e.toString();
        _searching = false;
      });
    }
  }

 Future<void> _cancel() async {
    _cancelled = true;
    if (_username.isNotEmpty) {
      await MatchmakingService.cancelSearch(_username);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _cancel,
        ),
        title: const Text('Multiplayer',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_searching) ...[
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 5,
                  ),
                ),
                const SizedBox(height: 32),
              ] else ...[
                const Icon(Icons.error_outline, color: Colors.white54, size: 80),
                const SizedBox(height: 32),
              ],

              Text(
                _status,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),

              if (_username.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Playing as: $_username',
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],

              const SizedBox(height: 48),

              if (_searching)
                OutlinedButton(
                  onPressed: _cancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _searching = true;
                      _cancelled = false;
                      _status = 'Searching for opponent...';
                    });
                    _startSearch();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Try Again',
                      style: TextStyle(fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}