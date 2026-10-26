import 'package:flutter/material.dart';
import '../models.dart';
import '../progress_store.dart';
import '../widgets.dart';
import 'level_player_screen.dart';

class LevelsScreen extends StatelessWidget {
  final World world;
  const LevelsScreen({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(world.name), backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24),
            itemCount: world.levels.length,
            itemBuilder: (context, i) {
              final stars = store.starsFor(world.id, i);
              final unlocked = store.isUnlocked(world, i);
              return Align(
                // zig-zag path
                alignment: Alignment(i.isEven ? -0.5 : 0.5, 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: _LevelNode(
                    number: i + 1,
                    title: world.levels[i].title,
                    color: world.color,
                    unlocked: unlocked,
                    stars: stars,
                    onTap: () {
                      if (!unlocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('أنهِ المستوى السابق أولاً')));
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LevelPlayerScreen(world: world, levelIndex: i),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  final int number;
  final String title;
  final Color color;
  final bool unlocked;
  final int stars;
  final VoidCallback onTap;
  const _LevelNode({
    required this.number,
    required this.title,
    required this.color,
    required this.unlocked,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final done = stars > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked ? color : Colors.grey.shade400,
              border: Border.all(color: Colors.white, width: 5),
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: !unlocked
                ? const Icon(Icons.lock_rounded, color: Colors.white, size: 36)
                : done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 44)
                    : Text('$number',
                        style: const TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        StarRow(stars: stars, size: 22),
      ],
    );
  }
}
