import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';
import 'home_shell.dart';

class LangOption {
  final String code;
  final String flag;
  final String name;
  const LangOption(this.code, this.flag, this.name);
}

const List<LangOption> kLangs = [
  LangOption('en', '🇺🇸', 'English'),
  LangOption('ar', '🇸🇦', 'العربية'),
  LangOption('fr', '🇫🇷', 'Français'),
  LangOption('es', '🇪🇸', 'Español'),
];

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (context, current, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('choose'),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 28),
                  for (final l in kLangs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => langNotifier.value = l.code,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 64,
                          decoration: BoxDecoration(
                            color: current == l.code
                                ? kPrimary.withOpacity(0.15)
                                : kCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: current == l.code
                                  ? kPrimary
                                  : Colors.white12,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l.flag, style: const TextStyle(fontSize: 26)),
                              const SizedBox(width: 14),
                              Text(l.name,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600)),
                              if (current == l.code) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.check, color: kPrimary),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeShell()),
                    ),
                    child: Container(
                      height: 58,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: kButtonGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tr('continue'),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
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
