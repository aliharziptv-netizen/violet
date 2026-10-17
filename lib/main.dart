import 'package:flutter/material.dart';
import 'screens/language_screen.dart';
import 'strings.dart';
import 'theme.dart';

void main() => runApp(const VioletApp());

class VioletApp extends StatelessWidget {
  const VioletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (context, lang, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Violet',
        theme: buildTheme(),
        builder: (context, child) => Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        ),
        home: const LanguageScreen(),
      ),
    );
  }
}
