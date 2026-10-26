import 'package:flutter/material.dart';

enum ActivityType { chooseImage, ordering, record }

class Choice {
  final String label;
  final String emoji; // placeholder art: replace with your own images later
  final bool correct;
  const Choice(this.label, this.emoji, {this.correct = false});
}

class Activity {
  final ActivityType type;
  final String prompt;
  final String? word;
  final List<Choice> choices;
  final List<String> orderItems; // in the CORRECT order

  const Activity.choose(this.prompt, this.choices)
      : type = ActivityType.chooseImage,
        word = null,
        orderItems = const [];

  const Activity.order(this.prompt, this.orderItems)
      : type = ActivityType.ordering,
        word = null,
        choices = const [];

  const Activity.record(this.prompt, this.word)
      : type = ActivityType.record,
        choices = const [],
        orderItems = const [];
}

class Level {
  final String title;
  final List<Activity> activities;
  const Level(this.title, this.activities);
}

class World {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final bool subscriberOnly;
  final List<Level> levels;
  const World({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.levels,
    this.subscriberOnly = false,
  });
}
