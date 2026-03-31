import 'package:flutter/material.dart';
import 'easy_levels.dart';
import 'medium_levels.dart';
import 'hard_levels.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChooseDifficultyPage(),
    ));

class ChooseDifficultyPage extends StatelessWidget {
  const ChooseDifficultyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cross Puzzle"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Choose Difficulty",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            
            // EASY CARD
            DifficultyCard(
              title: "Easy",
              color: Colors.green[400]!,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EasyLevelsPage())),
            ),
            const SizedBox(height: 20),

            // MEDIUM CARD
            DifficultyCard(
              title: "Medium",
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MediumLevelsPage())),
            ),
            const SizedBox(height: 20),

            // HARD CARD
            DifficultyCard(
              title: "Hard",
              color: Colors.red,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HardLevelsPage())),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Difficulty Card
class DifficultyCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const DifficultyCard({super.key, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}