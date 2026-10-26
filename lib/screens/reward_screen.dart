import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import 'level_player_screen.dart';

class RewardScreen extends StatelessWidget {
  final World world;
  final int levelIndex;
  final int stars;
  const RewardScreen(
      {super.key, required this.world, required this.levelIndex, required this.stars});

  @override
  Widget build(BuildContext context) {
    final hasNext = levelIndex + 1 < world.levels.length;
    final message = stars == 3 ? 'ممتاز! أنت بطل!' : (stars == 2 ? 'أحسنت!' : 'جيد، حاول مرة أخرى!');
    return Scaffold(
      body: SkyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 96)),
                const SizedBox(height: 12),
                Text(message,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: StarRow(stars: stars, size: 72),
                ),
                const SizedBox(height: 48),
                if (hasNext)
                  BigButton(
                    label: 'المستوى التالي',
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LevelPlayerScreen(world: world, levelIndex: levelIndex + 1),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                BigButton(
                  label: 'القائمة',
                  color: const Color(0xFF42A5F5),
                  icon: Icons.map_rounded,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
