import 'package:flutter/material.dart';

class CatchCard extends StatelessWidget {
  final Map<String, String> item;
  final VoidCallback? onTap;

  const CatchCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              top: 4,
              right: -150,
              width: 300,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.black, Colors.transparent],
                    stops: [0.0, 0.55, 0.95],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  item['image'] ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/placeholder/fish.png',
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                item['weight'] ?? '',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['sub'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
