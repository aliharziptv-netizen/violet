import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(tr('settings'),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: kPrimary),
              title: Text(tr('language')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor: kCard,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final l in kLangs)
                        ListTile(
                          leading: Text(l.flag, style: const TextStyle(fontSize: 24)),
                          title: Text(l.name),
                          trailing: langNotifier.value == l.code
                              ? const Icon(Icons.check, color: kPrimary)
                              : null,
                          onTap: () {
                            langNotifier.value = l.code;
                            Navigator.pop(ctx);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'This product uses the TMDB API but is not endorsed or certified by TMDB.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
