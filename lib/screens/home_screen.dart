import 'package:flutter/material.dart';
import '../data.dart';
import '../progress_store.dart';
import '../widgets.dart';
import 'worlds_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('قريباً!')));
  }

  @override
  Widget build(BuildContext context) {
    final store = ProgressScope.of(context);
    return Scaffold(
      body: SkyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('أهلاً ${store.childName}!',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Row(children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFFC107)),
                        const SizedBox(width: 4),
                        Text('${store.totalStars(kWorlds)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Mascot(message: 'يلا نلعب ونتعلّم كلمات جديدة!'),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _HomeCard(
                        title: 'عالم الكلمات',
                        emoji: '🌍',
                        color: const Color(0xFFFF9800),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const WorldsScreen())),
                      ),
                      _HomeCard(
                          title: 'المفردات',
                          emoji: '📚',
                          color: const Color(0xFF7E57C2),
                          onTap: () => _soon(context)),
                      _HomeCard(
                          title: 'للأهل',
                          emoji: '👨‍👩‍👧',
                          color: const Color(0xFF26A69A),
                          onTap: () => _soon(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title, emoji;
  final Color color;
  final VoidCallback onTap;
  const _HomeCard(
      {required this.title, required this.emoji, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(28),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      );
}
