import 'package:flutter/material.dart';
import '../data.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'all_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Media>> featured = repo.featured();
  late final Future<List<Media>> trending = repo.trending();

  void _open(Media m) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(item: m)),
    );
  }

  Future<void> _openAll() async {
    final list = await trending;
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AllScreen(title: tr('trending'), items: list),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FutureBuilder<List<Media>>(
          future: featured,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const SizedBox(
                  height: 480, child: Center(child: CircularProgressIndicator()));
            }
            return _Hero(items: snap.data!, onOpen: _open);
          },
        ),
        const SizedBox(height: 20),
        _SectionHeader(title: tr('trending'), onAll: _openAll),
        const SizedBox(height: 12),
        FutureBuilder<List<Media>>(
          future: trending,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const SizedBox(
                  height: 230, child: Center(child: CircularProgressIndicator()));
            }
            final list = snap.data!;
            return SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _open(list[i]),
                  child: PosterCard(item: list[i], width: 150),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAll;
  const _SectionHeader({required this.title, required this.onAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 28,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onAll,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: Text(tr('all')),
            style: OutlinedButton.styleFrom(
              foregroundColor: kPrimary,
              side: BorderSide(color: kPrimary.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatefulWidget {
  final List<Media> items;
  final void Function(Media) onOpen;
  const _Hero({required this.items, required this.onOpen});

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> {
  final PageController controller = PageController();
  int page = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => page = i),
            itemBuilder: (_, i) => _HeroSlide(
              item: widget.items[i],
              onOpen: () => widget.onOpen(widget.items[i]),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.items.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == page ? 28 : 8,
                    height: 5,
                    decoration: BoxDecoration(
                      color: i == page ? kPrimary : Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final Media item;
  final VoidCallback onOpen;
  const _HeroSlide({required this.item, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [item.c1, item.c2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.movie_creation_outlined,
                size: 130, color: Colors.white24),
          ),
          if (item.image != null)
            Positioned.fill(
              child: Image.network(
                item.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, kBg],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.isSeries ? tr('series') : tr('movie'),
                        style: const TextStyle(color: kPrimary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 18, color: kPrimary)),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_border, color: kPrimary),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onOpen,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: kButtonGradient,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow_rounded),
                              const SizedBox(width: 6),
                              Text(tr('watch'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.favorite_border),
                              const SizedBox(width: 6),
                              Text(tr('fav'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
