import 'package:flutter/material.dart';

class RoundResultScreen extends StatelessWidget {
  final int round;
  final int totalRounds;
  final String winnerUsername;
  final String myUsername;
  final String opponentUsername;
  final int myWins;
  final int opponentWins;
  final bool isMatchOver;
  final String roomId;

  const RoundResultScreen({
    super.key,
    required this.round,
    required this.totalRounds,
    required this.winnerUsername,
    required this.myUsername,
    required this.opponentUsername,
    required this.myWins,
    required this.opponentWins,
    required this.isMatchOver,
    required this.roomId,
  });

  bool get _iWonRound => winnerUsername == myUsername;
  bool get _iWonMatch => myWins > opponentWins;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button from bypassing this screen
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: _iWonRound
            ? const Color(0xFF1B5E20)
            : const Color(0xFF7F0000),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Round badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isMatchOver ? 'MATCH OVER' : 'ROUND $round COMPLETE',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 1.2),
                  ),
                ),

                const SizedBox(height: 32),

                // Win/Loss icon
                Icon(
                  _iWonRound ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                  size: 80,
                  color: _iWonRound
                      ? const Color(0xFFFFD700)
                      : Colors.white54,
                ),

                const SizedBox(height: 16),

                // Result text
                Text(
                  _iWonRound ? 'You Won!' : '$winnerUsername Won!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _iWonRound
                      ? 'You solved the puzzle first!'
                      : 'Your opponent was faster this round.',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Score card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildScoreColumn(myUsername, myWins, isMe: true),
                          const Text(
                            '—',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 28),
                          ),
                          _buildScoreColumn(
                              opponentUsername, opponentWins,
                              isMe: false),
                        ],
                      ),
                      if (isMatchOver) ...[
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 12),
                        Text(
                          _iWonMatch
                              ? '🏆 You won the match!'
                              : myWins == opponentWins
                                  ? "It's a draw!"
                                  : '$opponentUsername wins the match!',
                          style: TextStyle(
                            color: _iWonMatch
                                ? const Color(0xFFFFD700)
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Continue / Back button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _iWonRound
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFF7F0000),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isMatchOver ? 'Back to Menu' : 'Next Round',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreColumn(String name, int wins, {required bool isMe}) {
    return Column(
      children: [
        Text(
          isMe ? 'You' : name,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          '$wins',
          style: TextStyle(
            color: isMe ? const Color(0xFFFFD700) : Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          wins == 1 ? 'win' : 'wins',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}