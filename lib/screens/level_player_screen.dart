import 'package:flutter/material.dart';
import '../models.dart';
import '../progress_store.dart';
import 'activities.dart';
import 'reward_screen.dart';

class LevelPlayerScreen extends StatefulWidget {
  final World world;
  final int levelIndex;
  const LevelPlayerScreen({super.key, required this.world, required this.levelIndex});

  @override
  State<LevelPlayerScreen> createState() => _LevelPlayerScreenState();
}

class _LevelPlayerScreenState extends State<LevelPlayerScreen> {
  int _index = 0;
  int _mistakes = 0;

  Level get _level => widget.world.levels[widget.levelIndex];

  Future<void> _onActivityDone(int mistakes) async {
    _mistakes += mistakes;
    if (_index + 1 < _level.activities.length) {
      setState(() => _index++);
      return;
    }
    final stars = _mistakes == 0 ? 3 : (_mistakes <= 2 ? 2 : 1);
    final store = ProgressScope.read(context);
    await store.saveResult(widget.world.id, widget.levelIndex, stars);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RewardScreen(
            world: widget.world, levelIndex: widget.levelIndex, stars: stars),
      ),
    );
  }

  Widget _buildActivity(Activity a) {
    switch (a.type) {
      case ActivityType.chooseImage:
        return ChooseImageActivity(activity: a, onDone: _onActivityDone);
      case ActivityType.ordering:
        return OrderingActivity(activity: a, onDone: _onActivityDone);
      case ActivityType.record:
        return RecordActivity(activity: a, onDone: _onActivityDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _level.activities.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(_level.title),
        leading: IconButton(
            icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: _index / total, minHeight: 12),
              ),
            ),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: _buildActivity(_level.activities[_index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
