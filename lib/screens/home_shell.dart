import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _NavItem {
  final IconData icon;
  final String key;
  const _NavItem(this.icon, this.key);
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  static const List<_NavItem> items = [
    _NavItem(Icons.home_rounded, 'home'),
    _NavItem(Icons.live_tv_rounded, 'live'),
    _NavItem(Icons.emoji_events_outlined, 'matches'),
    _NavItem(Icons.article_outlined, 'news'),
    _NavItem(Icons.download_rounded, 'downloads'),
    _NavItem(Icons.settings_outlined, 'settings'),
  ];

  Widget _page(int i) {
    if (i == 0) return HomeScreen();
    if (i == 5) return SettingsScreen();
    return _Placeholder(icon: items[i].icon, titleKey: items[i].key);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          body: _page(index),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
            decoration: const BoxDecoration(
              color: Color(0xFF0E0E14),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  for (int i = 0; i < items.length; i++)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => index = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: index == i
                                ? kPrimary.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: index == i
                                  ? kPrimary.withOpacity(0.5)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(items[i].icon,
                                  color: index == i ? kPrimary : Colors.white54),
                              const SizedBox(height: 4),
                              Text(
                                tr(items[i].key),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: index == i ? kPrimary : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  const _Placeholder({required this.icon, required this.titleKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: kPrimary),
            const SizedBox(height: 16),
            Text(tr(titleKey),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(tr('soon'), style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
