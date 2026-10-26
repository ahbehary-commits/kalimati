import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../progress_store.dart';
import '../widgets.dart';
import 'levels_screen.dart';

class WorldsScreen extends StatelessWidget {
  const WorldsScreen({super.key});

  void _showLocked(BuildContext context, ProgressStore store) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('عالم للمشتركين 🔒'),
        content: const Text('اشترك لفتح هذا العالم وكل المستويات الإضافية.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لاحقاً')),
          FilledButton(
            // TODO: replace with the real purchase flow (in_app_purchase).
            onPressed: () {
              store.setSubscribed(true);
              Navigator.pop(ctx);
            },
            child: const Text('تفعيل تجريبي'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('اختر عالمك'), backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: kWorlds.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final w = kWorlds[i];
              final locked = store.isWorldLocked(w);
              return _WorldCard(
                world: w,
                locked: locked,
                collected: store.worldStars(w),
                onTap: () {
                  if (locked) {
                    _showLocked(context, store);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LevelsScreen(world: w)));
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WorldCard extends StatelessWidget {
  final World world;
  final bool locked;
  final int collected;
  final VoidCallback onTap;
  const _WorldCard(
      {required this.world, required this.locked, required this.collected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final maxStars = world.levels.length * 3;
    return Material(
      color: locked ? Colors.grey.shade400 : world.color,
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(world.emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(world.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.star_rounded, color: Colors.white),
                      const SizedBox(width: 4),
                      Text('$collected / $maxStars',
                          style: const TextStyle(fontSize: 18, color: Colors.white)),
                    ]),
                  ],
                ),
              ),
              if (locked) const Icon(Icons.lock_rounded, size: 36, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
