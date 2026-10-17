import 'package:flutter/foundation.dart';

/// اللغة الحالية: en / ar / fr / es
final ValueNotifier<String> langNotifier = ValueNotifier<String>('ar');

const Map<String, Map<String, String>> _tr = {
  'en': {
    'choose': 'Choose your language',
    'continue': 'Continue',
    'home': 'Home',
    'live': 'Live',
    'matches': 'Matches',
    'news': 'News',
    'downloads': 'Downloads',
    'settings': 'Settings',
    'watch': 'Watch',
    'fav': 'Favorites',
    'trending': 'Trending today',
    'all': 'See all',
    'series': 'Series',
    'movie': 'Movie',
    'soon': 'Coming soon',
    'language': 'Language',
  },
  'ar': {
    'choose': 'اختر لغتك',
    'continue': 'متابعة',
    'home': 'الرئيسية',
    'live': 'بث مباشر',
    'matches': 'المباريات',
    'news': 'الأخبار',
    'downloads': 'التنزيلات',
    'settings': 'الإعدادات',
    'watch': 'مشاهدة',
    'fav': 'مفضلتي',
    'trending': 'رائج اليوم',
    'all': 'عرض الكل',
    'series': 'مسلسل',
    'movie': 'فيلم',
    'soon': 'قريباً',
    'language': 'اللغة',
  },
  'fr': {
    'choose': 'Choisissez votre langue',
    'continue': 'Continuer',
    'home': 'Accueil',
    'live': 'En direct',
    'matches': 'Matchs',
    'news': 'Actualités',
    'downloads': 'Téléchargements',
    'settings': 'Paramètres',
    'watch': 'Regarder',
    'fav': 'Favoris',
    'trending': 'Tendances du jour',
    'all': 'Tout voir',
    'series': 'Série',
    'movie': 'Film',
    'soon': 'Bientôt',
    'language': 'Langue',
  },
  'es': {
    'choose': 'Elige tu idioma',
    'continue': 'Continuar',
    'home': 'Inicio',
    'live': 'En vivo',
    'matches': 'Partidos',
    'news': 'Noticias',
    'downloads': 'Descargas',
    'settings': 'Ajustes',
    'watch': 'Ver',
    'fav': 'Favoritos',
    'trending': 'Tendencias de hoy',
    'all': 'Ver todo',
    'series': 'Serie',
    'movie': 'Película',
    'soon': 'Próximamente',
    'language': 'Idioma',
  },
};

String tr(String key) =>
    _tr[langNotifier.value]?[key] ?? _tr['en']![key] ?? key;

bool get isRtl => langNotifier.value == 'ar';
