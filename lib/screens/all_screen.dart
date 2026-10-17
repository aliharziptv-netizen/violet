import 'package:flutter/material.dart';
import '../data.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'detail_screen.dart';

class AllScreen extends StatefulWidget {
  final String title;
  final List<Media> items;
  const AllScreen({super.key, required this.title, required this.items});

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  bool searching = false;
  String q = '';

  @override
  Widget build(BuildContext context) {
    final list = widget.items
        .where((m) => q.isEmpty || m.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  circleButton(Icons.arrow_back, () => Navigator.of(context).pop(), size: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: searching
                        ? TextField(
                            autofocus: true,
                            onChanged: (v) => setState(() => q = v),
                            decoration: InputDecoration(
                              hintText: tr('search'),
                              border: InputBorder.none,
                            ),
                          )
                        : Text(widget.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  ),
                  Text('${list.length}',
                      style: const TextStyle(color: Colors.white38, fontSize: 18)),
                  const SizedBox(width: 12),
                  circleButton(
                    searching ? Icons.close : Icons.search,
                    () => setState(() {
                      searching = !searching;
                      if (!searching) q = '';
                    }),
                    size: 52,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.5,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final m = list[i];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DetailScreen(item: m)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: PosterCard(item: m, showTitle: false)),
                        const SizedBox(height: 6),
                        Text(m.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
