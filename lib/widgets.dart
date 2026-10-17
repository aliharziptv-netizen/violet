import 'package:flutter/material.dart';
import 'data.dart';
import 'theme.dart';

Widget circleButton(IconData icon, VoidCallback onTap, {double size = 46}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black54,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white),
    ),
  );
}

class PosterCard extends StatelessWidget {
  final Media item;
  final double? width;
  final bool showTitle;
  const PosterCard({super.key, required this.item, this.width, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [item.c1, item.c2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            if (item.image != null)
              Positioned.fill(
                child: Image.network(
                  item.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            if (showTitle)
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black87],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            if (item.year > 0 && showTitle)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${item.year}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 3),
                    const Icon(Icons.star_border, size: 14, color: kPrimary),
                  ],
                ),
              ),
            ),
            if (showTitle)
              Positioned(
                left: 10,
                right: 10,
                bottom: 12,
                child: Text(item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
          ],
        ),
      ),
    );
  }
}
