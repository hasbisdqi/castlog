import 'package:castlog/models/session_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatchCard extends StatelessWidget {
  final Map<String, String>? item;
  final CatchModel? catchModel;
  final VoidCallback? onTap;

  const CatchCard({
    super.key,
    this.item,
    this.catchModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = catchModel?.species ?? item?['title'] ?? '';
    final sub = catchModel != null
        ? '${catchModel!.waterway.split(" - ").first} · ${catchModel!.rodName}'
        : (item?['sub'] ?? '');
    final weight = catchModel?.weightFormatted ?? item?['weight'] ?? '';
    final imageUrl = catchModel?.image ?? item?['image'] ?? '';

    final handleTap = onTap ??
        (catchModel != null
            ? () => Get.toNamed(AppRoutes.catchDetail, arguments: catchModel)
            : null);

    return GestureDetector(
      onTap: handleTap,
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
                  imageUrl,
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
                weight,
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
                    title,
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
                    sub,
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
