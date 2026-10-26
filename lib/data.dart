import 'package:flutter/material.dart';
import 'models.dart';

// Sample content only. Replace with your own words, images and recordings,
// ideally reviewed by a speech-language pathologist.
const List<World> kWorlds = [
  World(
    id: 'fruits',
    name: 'عالم الفواكه',
    emoji: '🍎',
    color: Color(0xFF66BB6A),
    levels: [
      Level('تفاحة', [
        Activity.choose('اختر التفاحة', [
          Choice('تفاحة', '🍎', correct: true),
          Choice('موزة', '🍌'),
          Choice('عنب', '🍇'),
          Choice('برتقالة', '🍊'),
        ]),
        Activity.record('قل الكلمة بصوتك', 'تفاحة'),
      ]),
      Level('موز', [
        Activity.choose('أين الموزة؟', [
          Choice('فراولة', '🍓'),
          Choice('موزة', '🍌', correct: true),
          Choice('بطيخ', '🍉'),
          Choice('تفاحة', '🍎'),
        ]),
        Activity.order('رتّب الكلمات لتكوّن جملة', ['أنا', 'أحب', 'الموز']),
        Activity.record('قل الكلمة بصوتك', 'موزة'),
      ]),
      Level('عنب', [
        Activity.choose('اختر العنب', [
          Choice('عنب', '🍇', correct: true),
          Choice('كرز', '🍒'),
          Choice('ليمون', '🍋'),
          Choice('خوخ', '🍑'),
        ]),
        Activity.order('رتّب الجملة', ['هذا', 'عنب', 'لذيذ']),
        Activity.record('قل الكلمة بصوتك', 'عنب'),
      ]),
    ],
  ),
  World(
    id: 'animals',
    name: 'عالم الحيوانات',
    emoji: '🐘',
    color: Color(0xFF42A5F5),
    subscriberOnly: true,
    levels: [
      Level('قطة', [
        Activity.choose('أين القطة؟', [
          Choice('كلب', '🐶'),
          Choice('قطة', '🐱', correct: true),
          Choice('أسد', '🦁'),
          Choice('أرنب', '🐰'),
        ]),
        Activity.record('قل الكلمة بصوتك', 'قطة'),
      ]),
      Level('فيل', [
        Activity.choose('اختر الفيل', [
          Choice('فيل', '🐘', correct: true),
          Choice('حصان', '🐴'),
          Choice('بقرة', '🐮'),
          Choice('بطة', '🦆'),
        ]),
        Activity.order('رتّب الجملة', ['الفيل', 'كبير', 'جداً']),
        Activity.record('قل الكلمة بصوتك', 'فيل'),
      ]),
    ],
  ),
];
