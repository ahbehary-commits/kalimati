import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class ProgressStore extends ChangeNotifier {
  final SharedPreferences _prefs;
  ProgressStore(this._prefs);

  bool get onboardingDone => _prefs.getBool('onboarding_done') ?? false;
  String get childName => _prefs.getString('child_name') ?? 'صديقي';

  // TODO: replace with real purchase state (in_app_purchase + server check).
  bool get isSubscribed => _prefs.getBool('subscribed') ?? false;

  Future<void> finishOnboarding(String name) async {
    await _prefs.setString('child_name', name);
    await _prefs.setBool('onboarding_done', true);
    notifyListeners();
  }

  Future<void> setSubscribed(bool v) async {
    await _prefs.setBool('subscribed', v);
    notifyListeners();
  }

  int starsFor(String worldId, int levelIndex) =>
      _prefs.getInt('stars_${worldId}_$levelIndex') ?? 0;

  bool isUnlocked(World w, int levelIndex) =>
      levelIndex == 0 || starsFor(w.id, levelIndex - 1) > 0;

  bool isWorldLocked(World w) => w.subscriberOnly && !isSubscribed;

  int worldStars(World w) {
    var sum = 0;
    for (var i = 0; i < w.levels.length; i++) {
      sum += starsFor(w.id, i);
    }
    return sum;
  }

  int totalStars(List<World> worlds) =>
      worlds.fold(0, (s, w) => s + worldStars(w));

  Future<void> saveResult(String worldId, int levelIndex, int stars) async {
    final old = starsFor(worldId, levelIndex);
    if (stars > old) {
      await _prefs.setInt('stars_${worldId}_$levelIndex', stars);
    }
    notifyListeners();
  }
}

class ProgressScope extends InheritedNotifier<ProgressStore> {
  const ProgressScope({
    super.key,
    required ProgressStore store,
    required super.child,
  }) : super(notifier: store);

  /// Use inside build(): rebuilds when progress changes.
  static ProgressStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProgressScope>()!.notifier!;

  /// Use inside callbacks: no rebuild subscription.
  static ProgressStore read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ProgressScope>()!.notifier!;
}
