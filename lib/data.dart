import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'strings.dart';

class Media {
  final String id;
  final String name;
  final bool isSeries;
  final int year;
  final double rating;
  final String? image;
  final Color c1;
  final Color c2;
  const Media({
    required this.id,
    required this.name,
    required this.isSeries,
    required this.year,
    required this.rating,
    this.image,
    this.c1 = const Color(0xFF4C1D95),
    this.c2 = const Color(0xFF0A0A0F),
  });
}

class Person {
  final String name;
  final String? image;
  const Person(this.name, this.image);
}

class MediaDetail {
  final Media media;
  final String overview;
  final List<String> genres;
  final int runtime;
  final String? backdrop;
  final List<Person> cast;
  final List<Person> crew;
  final List<String> chips;
  final String? streamUrl;
  final String? trailerUrl;
  const MediaDetail({
    required this.media,
    this.overview = '',
    this.genres = const [],
    this.runtime = 0,
    this.backdrop,
    this.cast = const [],
    this.crew = const [],
    this.chips = const [],
    this.streamUrl,
    this.trailerUrl,
  });
  factory MediaDetail.basic(Media m) => MediaDetail(media: m, backdrop: m.image);
}

abstract class ContentRepository {
  Future<List<Media>> featured();
  Future<List<Media>> trending();
  Future<MediaDetail> detail(Media m);
}

/// بيانات تجريبية. رابط التشغيل التجريبي فيلم Big Buck Bunny (Blender Foundation، CC-BY).
class DemoRepository implements ContentRepository {
  static const String sampleVideo =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  Future<List<Media>> featured() async => const [
        Media(id: 'd1', name: 'ليالي البنفسج', isSeries: true, year: 2026, rating: 7.4, c1: Color(0xFF4C1D95)),
        Media(id: 'd2', name: 'Midnight Express', isSeries: false, year: 2026, rating: 6.9, c1: Color(0xFF1E3A8A)),
        Media(id: 'd3', name: 'ظلال الصحراء', isSeries: true, year: 2025, rating: 8.1, c1: Color(0xFF7C2D12)),
        Media(id: 'd4', name: 'The Last Harbor', isSeries: false, year: 2024, rating: 7.0, c1: Color(0xFF134E4A)),
      ];

  @override
  Future<List<Media>> trending() async => const [
        Media(id: 'd5', name: 'رحلة النجوم', isSeries: false, year: 2026, rating: 6.7, c1: Color(0xFF6D28D9), c2: Color(0xFF1E1B4B)),
        Media(id: 'd6', name: 'Silent Hill Road', isSeries: false, year: 2025, rating: 7.2, c1: Color(0xFF831843), c2: Color(0xFF1F1020)),
        Media(id: 'd7', name: 'عائلة المدينة', isSeries: true, year: 2026, rating: 7.8, c1: Color(0xFF0F766E), c2: Color(0xFF042F2E)),
        Media(id: 'd8', name: 'Neon Rain', isSeries: true, year: 2025, rating: 8.3, c1: Color(0xFF1D4ED8), c2: Color(0xFF172554)),
        Media(id: 'd9', name: 'سر الجبل', isSeries: false, year: 2024, rating: 6.5, c1: Color(0xFFB45309), c2: Color(0xFF3B1D04)),
        Media(id: 'd10', name: 'Crimson Tide 2', isSeries: false, year: 2026, rating: 6.1, c1: Color(0xFF9D174D), c2: Color(0xFF2A0A18)),
        Media(id: 'd11', name: 'ليلة الغيم', isSeries: false, year: 2025, rating: 7.0, c1: Color(0xFF3730A3), c2: Color(0xFF1E1B4B)),
        Media(id: 'd12', name: 'Paper Planes', isSeries: true, year: 2024, rating: 7.6, c1: Color(0xFF166534), c2: Color(0xFF052E16)),
        Media(id: 'd13', name: 'الوادي الأخضر', isSeries: false, year: 2023, rating: 6.8, c1: Color(0xFF115E59), c2: Color(0xFF042F2E)),
      ];

  @override
  Future<MediaDetail> detail(Media m) async => MediaDetail(
        media: m,
        overview: 'نص تجريبي لوصف العمل. استبدله ببيانات مصدرك الحقيقي.',
        genres: const ['دراما', 'أكشن'],
        runtime: 110,
        cast: const [Person('ممثل ١', null), Person('ممثلة ٢', null), Person('ممثل ٣', null), Person('ممثلة ٤', null)],
        crew: const [Person('مخرج', null), Person('كاتب', null), Person('منتج', null)],
        chips: const ['released', 'AR', '2026-06-24'],
        streamUrl: sampleVideo,
      );
}

/// مصدر TMDB (themoviedb.org): معلومات وصور وتقييمات فقط، بدون روابط مشاهدة.
class TmdbRepository implements ContentRepository {
  final String key;
  TmdbRepository(this.key);

  String get _lang =>
      const {'ar': 'ar-SA', 'en': 'en-US', 'fr': 'fr-FR', 'es': 'es-ES'}[
          langNotifier.value] ??
      'en-US';

  Future<Map<String, dynamic>> _json(String path, [Map<String, String>? extra]) async {
    final uri = Uri.https('api.themoviedb.org', '/3/$path',
        {'api_key': key, 'language': _lang, ...?extra});
    final res = await http.get(uri).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) throw Exception('TMDB ${res.statusCode}');
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  Future<List<Media>> _list(String path, {required bool backdrop}) async {
    final data = await _json(path);
    final list = (data['results'] as List).cast<Map<String, dynamic>>();
    final out = <Media>[];
    for (final m in list) {
      final type = m['media_type'];
      if (type != null && type != 'movie' && type != 'tv') continue;
      final p = (backdrop ? m['backdrop_path'] : m['poster_path']) as String?;
      if (p == null) continue;
      final date = ((m['release_date'] ?? m['first_air_date'] ?? '') as String);
      out.add(Media(
        id: '${m['id']}',
        name: ((m['title'] ?? m['name'] ?? '') as String),
        isSeries: type == 'tv',
        year: date.length >= 4 ? (int.tryParse(date.substring(0, 4)) ?? 0) : 0,
        rating: (m['vote_average'] as num?)?.toDouble() ?? 0,
        image: 'https://image.tmdb.org/t/p/${backdrop ? 'w780' : 'w342'}$p',
      ));
    }
    return out;
  }

  @override
  Future<List<Media>> featured() async =>
      (await _list('trending/all/week', backdrop: true)).take(5).toList();

  @override
  Future<List<Media>> trending() => _list('trending/all/day', backdrop: false);

  List<Person> _people(dynamic l, int n) => ((l as List?) ?? const [])
      .cast<Map<String, dynamic>>()
      .take(n)
      .map((p) => Person(
          '${p['name'] ?? ''}',
          p['profile_path'] == null
              ? null
              : 'https://image.tmdb.org/t/p/w185${p['profile_path']}'))
      .toList();

  @override
  Future<MediaDetail> detail(Media m) async {
    final kind = m.isSeries ? 'tv' : 'movie';
    final d = await _json('$kind/${m.id}', {'append_to_response': 'credits'});
    final credits = (d['credits'] as Map<String, dynamic>?) ?? const {};
    int runtime = (d['runtime'] as num?)?.toInt() ?? 0;
    final ep = d['episode_run_time'];
    if (runtime == 0 && ep is List && ep.isNotEmpty) {
      runtime = (ep.first as num).toInt();
    }
    final bd = d['backdrop_path'] as String?;
    return MediaDetail(
      media: m,
      overview: '${d['overview'] ?? ''}',
      genres: ((d['genres'] as List?) ?? const [])
          .map((g) => '${(g as Map)['name']}')
          .toList(),
      runtime: runtime,
      backdrop: bd == null ? m.image : 'https://image.tmdb.org/t/p/w780$bd',
      cast: _people(credits['cast'], 14),
      crew: _people(credits['crew'], 10),
      chips: [
        '${d['status'] ?? ''}',
        '${d['original_language'] ?? ''}'.toUpperCase(),
        '${d['release_date'] ?? d['first_air_date'] ?? ''}',
      ].where((s) => s.isNotEmpty).toList(),
    );
  }
}

/// مصدر JSON خاص (خادم تملكه أو مرخّص لك). المسارات المتوقعة:
///   GET {base}/featured        -> [ عنصر, ... ]
///   GET {base}/trending        -> [ عنصر, ... ]
///   GET {base}/title/{id}      -> تفاصيل عنصر
/// عنصر القائمة: {"id":"1","name":"..","type":"movie|series","year":2026,"rating":7.5,"image":"https://.."}
/// التفاصيل: نفس الحقول + overview, genres[], runtime, backdrop, cast[{name,image}], crew[{name,image}],
///   status, language, country, date, age, views, stream (رابط mp4/m3u8), trailer (رابط مباشر)
class JsonApiRepository implements ContentRepository {
  final String base;
  JsonApiRepository(this.base);

  String get _b => base.endsWith('/') ? base.substring(0, base.length - 1) : base;

  Future<dynamic> _get(String path) async {
    final res = await http.get(Uri.parse('$_b/$path')).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) throw Exception('API ${res.statusCode}');
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  Media _media(Map<String, dynamic> m) => Media(
        id: '${m['id'] ?? ''}',
        name: '${m['name'] ?? ''}',
        isSeries: m['type'] == 'series',
        year: (m['year'] as num?)?.toInt() ?? 0,
        rating: (m['rating'] as num?)?.toDouble() ?? 0,
        image: m['image'] as String?,
      );

  List<Person> _people(dynamic l) => ((l as List?) ?? const [])
      .cast<Map<String, dynamic>>()
      .map((p) => Person('${p['name'] ?? ''}', p['image'] as String?))
      .toList();

  Future<List<Media>> _list(String path) async =>
      ((await _get(path)) as List).cast<Map<String, dynamic>>().map(_media).toList();

  @override
  Future<List<Media>> featured() => _list('featured');
  @override
  Future<List<Media>> trending() => _list('trending');

  @override
  Future<MediaDetail> detail(Media m) async {
    final d = (await _get('title/${m.id}')) as Map<String, dynamic>;
    final chips = <String>[
      '${d['status'] ?? ''}',
      '${d['age'] ?? ''}',
      '${d['views'] ?? ''}',
      '${d['language'] ?? ''}',
      '${d['country'] ?? ''}',
      '${d['date'] ?? ''}',
    ].where((s) => s.isNotEmpty).toList();
    return MediaDetail(
      media: _media(d).name.isEmpty ? m : _media(d),
      overview: '${d['overview'] ?? ''}',
      genres: ((d['genres'] as List?) ?? const []).map((g) => '$g').toList(),
      runtime: (d['runtime'] as num?)?.toInt() ?? 0,
      backdrop: (d['backdrop'] as String?) ?? m.image,
      cast: _people(d['cast']),
      crew: _people(d['crew']),
      chips: chips,
      streamUrl: d['stream'] as String?,
      trailerUrl: d['trailer'] as String?,
    );
  }
}

/// إذا فشل المصدر الأساسي نعرض البيانات التجريبية بدل شاشة فارغة.
class FallbackRepository implements ContentRepository {
  final ContentRepository primary;
  final ContentRepository backup;
  FallbackRepository(this.primary, this.backup);

  @override
  Future<List<Media>> featured() async {
    try {
      final r = await primary.featured();
      return r.isEmpty ? await backup.featured() : r;
    } catch (_) {
      return backup.featured();
    }
  }

  @override
  Future<List<Media>> trending() async {
    try {
      final r = await primary.trending();
      return r.isEmpty ? await backup.trending() : r;
    } catch (_) {
      return backup.trending();
    }
  }

  @override
  Future<MediaDetail> detail(Media m) async {
    try {
      return await primary.detail(m);
    } catch (_) {
      return MediaDetail.basic(m);
    }
  }
}

// تُمرَّر وقت البناء (انظر README والـ workflow). إن كانت فارغة نستخدم البيانات التجريبية.
const String _apiBase = String.fromEnvironment('API_BASE');
const String _tmdbKey = String.fromEnvironment('TMDB_KEY');

final ContentRepository repo = _apiBase.isNotEmpty
    ? FallbackRepository(JsonApiRepository(_apiBase), DemoRepository())
    : _tmdbKey.isNotEmpty
        ? FallbackRepository(TmdbRepository(_tmdbKey), DemoRepository())
        : DemoRepository();
