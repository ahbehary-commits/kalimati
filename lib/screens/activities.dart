import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services.dart';
import '../widgets.dart';

typedef ActivityDone = Future<void> Function(int mistakes);

// ───────────────────────── Choose the right picture ─────────────────────────
class ChooseImageActivity extends StatefulWidget {
  final Activity activity;
  final ActivityDone onDone;
  const ChooseImageActivity({super.key, required this.activity, required this.onDone});
  @override
  State<ChooseImageActivity> createState() => _ChooseImageActivityState();
}

class _ChooseImageActivityState extends State<ChooseImageActivity> {
  int _mistakes = 0;
  int? _wrong;
  int? _right;
  bool _locked = false;

  Future<void> _tap(int i) async {
    if (_locked) return;
    if (widget.activity.choices[i].correct) {
      setState(() {
        _right = i;
        _locked = true;
      });
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) await widget.onDone(_mistakes);
    } else {
      setState(() {
        _mistakes++;
        _wrong = i;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _wrong = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: Mascot(message: a.prompt)),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: () => PromptPlayer.speak(a.prompt),
            ),
          ]),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                for (var i = 0; i < a.choices.length; i++)
                  GestureDetector(
                    onTap: () => _tap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _right == i
                            ? const Color(0xFFA5D6A7)
                            : _wrong == i
                                ? const Color(0xFFEF9A9A)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          width: 4,
                          color: _right == i
                              ? const Color(0xFF43A047)
                              : _wrong == i
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFFE0E0E0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(a.choices[i].emoji, style: const TextStyle(fontSize: 72)),
                          const SizedBox(height: 4),
                          Text(a.choices[i].label,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Order the words ─────────────────────────
class OrderingActivity extends StatefulWidget {
  final Activity activity;
  final ActivityDone onDone;
  const OrderingActivity({super.key, required this.activity, required this.onDone});
  @override
  State<OrderingActivity> createState() => _OrderingActivityState();
}

class _OrderingActivityState extends State<OrderingActivity> {
  late List<String> _pool;
  final List<String> _answer = [];
  int _mistakes = 0;
  bool _done = false;
  bool _wrong = false;

  @override
  void initState() {
    super.initState();
    _pool = List.of(widget.activity.orderItems);
    if (_pool.length > 1) {
      do {
        _pool.shuffle();
      } while (listEquals(_pool, widget.activity.orderItems));
    }
  }

  Future<void> _pick(String item) async {
    if (_done || _wrong) return;
    setState(() {
      _pool.remove(item);
      _answer.add(item);
    });
    if (_answer.length != widget.activity.orderItems.length) return;

    if (listEquals(_answer, widget.activity.orderItems)) {
      setState(() => _done = true);
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) await widget.onDone(_mistakes);
    } else {
      setState(() {
        _mistakes++;
        _wrong = true;
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        _pool.addAll(_answer);
        _answer.clear();
        _wrong = false;
      });
    }
  }

  void _undo() {
    if (_done || _wrong || _answer.isEmpty) return;
    setState(() => _pool.add(_answer.removeLast()));
  }

  Widget _chip(String t, {VoidCallback? onTap, Color? color}) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBDBDBD), width: 2),
          ),
          child: Text(t, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final answerColor = _done
        ? const Color(0xFFA5D6A7)
        : _wrong
            ? const Color(0xFFEF9A9A)
            : const Color(0xFFFFF59D);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Mascot(message: widget.activity.prompt),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 3),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [for (final t in _answer) _chip(t, color: answerColor)],
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [for (final t in _pool) _chip(t, onTap: () => _pick(t))],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _undo,
            icon: const Icon(Icons.undo_rounded),
            label: const Text('تراجع', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Say the word (record) ─────────────────────────
enum _RecState { idle, recording, recorded }

class RecordActivity extends StatefulWidget {
  final Activity activity;
  final ActivityDone onDone;
  const RecordActivity({super.key, required this.activity, required this.onDone});
  @override
  State<RecordActivity> createState() => _RecordActivityState();
}

class _RecordActivityState extends State<RecordActivity> {
  final SpeechRecorder _recorder = StubRecorder(); // swap for a real recorder
  _RecState _state = _RecState.idle;

  Future<void> _toggle() async {
    if (_state == _RecState.recording) {
      await _recorder.stop();
      if (mounted) setState(() => _state = _RecState.recorded);
    } else {
      final ok = await _recorder.start();
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('نحتاج إذن الميكروفون للتسجيل')));
        }
        return;
      }
      if (mounted) setState(() => _state = _RecState.recording);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rec = _state == _RecState.recording;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Mascot(message: widget.activity.prompt),
          const Spacer(),
          Text(widget.activity.word ?? '',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          IconButton(
            iconSize: 44,
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => PromptPlayer.speak(widget.activity.word ?? ''),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _state == _RecState.recorded ? null : _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: rec ? 130 : 110,
              height: rec ? 130 : 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rec ? const Color(0xFFE53935) : const Color(0xFFFF9800),
                boxShadow: [
                  BoxShadow(
                    color: (rec ? Colors.red : Colors.orange).withOpacity(0.4),
                    blurRadius: rec ? 24 : 10,
                    spreadRadius: rec ? 8 : 0,
                  ),
                ],
              ),
              child: Icon(rec ? Icons.stop_rounded : Icons.mic_rounded,
                  size: 56, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            switch (_state) {
              _RecState.idle => 'اضغط وقل الكلمة',
              _RecState.recording => 'أسمعك... اضغط للإيقاف',
              _RecState.recorded => 'أحسنت! 🎉',
            },
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          if (_state == _RecState.recorded)
            BigButton(label: 'التالي', onPressed: () => widget.onDone(0)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
