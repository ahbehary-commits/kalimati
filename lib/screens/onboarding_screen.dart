import 'package:flutter/material.dart';
import '../progress_store.dart';
import '../widgets.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  final _name = TextEditingController();
  int _page = 0;

  static const _intro = [
    ('👨‍👩‍👧', 'أهلاً بكم!', 'تطبيق يساعد طفلك على تعلّم الكلام والنطق بالتدريج واللعب.'),
    ('🎮', 'نلعب ونتعلّم', 'أنشطة قصيرة: اختيار صور، ترتيب كلمات، وتكرار الكلمات بصوت الطفل.'),
  ];

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_page < _intro.length) {
      await _pages.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      return;
    }
    final store = ProgressScope.read(context);
    final name = _name.text.trim().isEmpty ? 'صديقي' : _name.text.trim();
    await store.finishOnboarding(name);
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final total = _intro.length + 1;
    final isLast = _page == total - 1;
    return Scaffold(
      body: SkyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pages,
                    onPageChanged: (i) => setState(() => _page = i),
                    children: [
                      for (final p in _intro) _InfoPage(emoji: p.$1, title: p.$2, text: p.$3),
                      _NamePage(controller: _name),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    total,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(4),
                      width: i == _page ? 24 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: i == _page ? const Color(0xFFFF9800) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BigButton(label: isLast ? 'ابدأ' : 'التالي', onPressed: _next),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPage extends StatelessWidget {
  final String emoji, title, text;
  const _InfoPage({required this.emoji, required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 120)),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
        ],
      );
}

class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  const _NamePage({required this.controller});
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Mascot(message: 'ما اسمك يا بطل؟'),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
            decoration: InputDecoration(
              hintText: 'اسم الطفل',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
}
