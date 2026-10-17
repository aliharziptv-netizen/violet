import 'package:flutter/material.dart';

class Media {
  final String name;
  final bool isSeries;
  final int year;
  final double rating;
  final Color c1;
  final Color c2;
  const Media({
    required this.name,
    required this.isSeries,
    required this.year,
    required this.rating,
    required this.c1,
    required this.c2,
  });
}

/// واجهة مصدر المحتوى. اربطها لاحقاً بمصدر محتوى مرخّص أو بخادمك الخاص
/// (مثلاً TMDB لمعلومات الأفلام) بدل البيانات التجريبية.
abstract class ContentRepository {
  Future<List<Media>> featured();
  Future<List<Media>> trending();
}

class DemoRepository implements ContentRepository {
  @override
  Future<List<Media>> featured() async => const [
        Media(name: 'ليالي البنفسج', isSeries: true, year: 2026, rating: 7.4, c1: Color(0xFF4C1D95), c2: Color(0xFF0A0A0F)),
        Media(name: 'Midnight Express', isSeries: false, year: 2026, rating: 6.9, c1: Color(0xFF1E3A8A), c2: Color(0xFF0A0A0F)),
        Media(name: 'ظلال الصحراء', isSeries: true, year: 2025, rating: 8.1, c1: Color(0xFF7C2D12), c2: Color(0xFF0A0A0F)),
        Media(name: 'The Last Harbor', isSeries: false, year: 2024, rating: 7.0, c1: Color(0xFF134E4A), c2: Color(0xFF0A0A0F)),
      ];

  @override
  Future<List<Media>> trending() async => const [
        Media(name: 'رحلة النجوم', isSeries: false, year: 2026, rating: 6.7, c1: Color(0xFF6D28D9), c2: Color(0xFF1E1B4B)),
        Media(name: 'Silent Hill Road', isSeries: false, year: 2025, rating: 7.2, c1: Color(0xFF831843), c2: Color(0xFF1F1020)),
        Media(name: 'عائلة المدينة', isSeries: true, year: 2026, rating: 7.8, c1: Color(0xFF0F766E), c2: Color(0xFF042F2E)),
        Media(name: 'Neon Rain', isSeries: true, year: 2025, rating: 8.3, c1: Color(0xFF1D4ED8), c2: Color(0xFF172554)),
        Media(name: 'سر الجبل', isSeries: false, year: 2024, rating: 6.5, c1: Color(0xFFB45309), c2: Color(0xFF3B1D04)),
      ];
}

final ContentRepository repo = DemoRepository();
