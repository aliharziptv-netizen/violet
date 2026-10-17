import 'package:flutter/material.dart';
import '../data.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'player_screen.dart';

class DetailScreen extends StatefulWidget {
  final Media item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Future<MediaDetail> future = repo.detail(widget.item);
  bool fav = false;

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _open(String? url, String title) {
    if (url == null || url.isEmpty) {
      _snack(tr('nostream'));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlayerScreen(url: url, title: title),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MediaDetail>(
        future: future,
        builder: (context, snap) {
          final d = snap.data ?? MediaDetail.basic(widget.item);
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _header(d),
              if (snap.connectionState != ConnectionState.done)
                const LinearProgressIndicator(minHeight: 2, color: kPrimary),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _playButton(d),
                    const SizedBox(height: 12),
                    _downloadButton(d),
                    const SizedBox(height: 18),
                    _chips(d),
                    if (d.overview.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      _title(tr('overview')),
                      const SizedBox(height: 8),
                      Text(d.overview,
                          style: const TextStyle(color: Colors.white70, height: 1.6)),
                    ],
                  ],
                ),
              ),
              if (d.cast.isNotEmpty) _people(tr('cast'), d.cast),
              if (d.crew.isNotEmpty) _people(tr('crew'), d.crew),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _grad(Media m) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [m.c1, m.c2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

  Widget _header(MediaDetail d) {
    final m = d.media;
    final bg = d.backdrop ?? m.image;
    return SizedBox(
      height: 440,
      child: Stack(
        children: [
          Positioned.fill(
            child: bg != null
                ? Image.network(bg, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _grad(m))
                : _grad(m),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black38, kBg],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.95],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 16,
                    child: circleButton(Icons.arrow_back, () => Navigator.of(context).pop()),
                  ),
                  Positioned(
                    top: 8,
                    right: 16,
                    child: circleButton(
                      fav ? Icons.favorite : Icons.favorite_border,
                      () => setState(() => fav = !fav),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 130,
                  height: 195,
                  child: PosterCard(item: m, showTitle: false),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      if (d.genres.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kPrimary.withOpacity(0.4)),
                          ),
                          child: Text(d.genres.take(3).join(', '),
                              style: const TextStyle(color: kPrimary)),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(m.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 17)),
                          const SizedBox(width: 4),
                          const Icon(Icons.star_border, color: kPrimary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (m.year > 0) '${m.year}',
                          if (d.runtime > 0) '${d.runtime} ${tr('min')}',
                        ].join('   '),
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _playButton(MediaDetail d) {
    return GestureDetector(
      onTap: () => _open(d.streamUrl, d.media.name),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: kButtonGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tr('play'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(width: 10),
            const Icon(Icons.play_arrow_rounded, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _downloadButton(MediaDetail d) {
    return GestureDetector(
      onTap: () => _snack(tr('soon')),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kPrimary, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tr('download'),
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: kPrimary)),
            const SizedBox(width: 10),
            const Icon(Icons.download_rounded, color: kPrimary),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, {IconData? icon, bool accent = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: accent ? kPrimary.withOpacity(0.15) : kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent ? kPrimary.withOpacity(0.5) : Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text,
                style: TextStyle(
                    color: accent ? kPrimary : Colors.white70,
                    fontWeight: FontWeight.w600)),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 18, color: accent ? kPrimary : Colors.white54),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chips(MediaDetail d) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (d.trailerUrl != null && d.trailerUrl!.isNotEmpty)
          _chip(tr('trailer'),
              icon: Icons.play_circle_outline,
              accent: true,
              onTap: () => _open(d.trailerUrl, '${d.media.name} - ${tr('trailer')}')),
        for (final c in d.chips) _chip(c),
      ],
    );
  }

  Widget _title(String text) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 26,
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _people(String title, List<Person> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _title(title),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) {
                final p = list[i];
                return SizedBox(
                  width: 86,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: kPrimary.withOpacity(0.18),
                        backgroundImage:
                            p.image != null ? NetworkImage(p.image!) : null,
                        child: p.image == null
                            ? Text(
                                p.name.isEmpty ? '?' : p.name.characters.first,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: kPrimary),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(p.name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.white60)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
