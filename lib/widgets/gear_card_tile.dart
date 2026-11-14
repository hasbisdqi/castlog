import 'package:castlog/models/gear_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GearCardTile extends StatelessWidget {
  final GearModel gear;
  final bool isHorizontalRod;
  final bool isSelected;
  final VoidCallback onTap;

  const GearCardTile({
    super.key,
    required this.gear,
    this.isHorizontalRod = false,
    this.isSelected = false,
    required this.onTap,
  });

  String _extractStat(GearModel item) {
    final desc = item.description;
    final name = item.name;

    final lengthPattern = RegExp(r"(\d+(\.\d+)?\s*(m|ft|'|" r'"))');
    final lengthMatch = lengthPattern.firstMatch(desc) ?? lengthPattern.firstMatch(name);
    if (lengthMatch != null) return lengthMatch.group(0)!;

    // Cek pattern berat / kg / lb / g
    final weightMatch =
        RegExp(r"(\d+(\.\d+)?\s*(kg|lbs?|g|oz))", caseSensitive: false)
            .firstMatch(desc) ??
        RegExp(r"(\d+(\.\d+)?\s*(kg|lbs?|g|oz))", caseSensitive: false)
            .firstMatch(name);
    if (weightMatch != null) return weightMatch.group(0)!;

    return item.subCategory.isNotEmpty ? item.subCategory : '';
  }

  @override
  Widget build(BuildContext context) {
    final stat = _extractStat(gear);

    if (isHorizontalRod) {
      return InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.paper,
            border: Border.all(
              color: isSelected ? AppColors.ink : AppColors.line,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Stack(
            children: [
              // 1. Stat kanan atas
              if (stat.isNotEmpty)
                Positioned(
                  top: 10,
                  right: 12,
                  child: Text(
                    stat,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

              // 2. Gambar Joran Horizontal di tengah
              Positioned.fill(
                top: 8,
                bottom: 28,
                left: 12,
                right: 12,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.88, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    gear.image,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    headers: const {
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),

              // 3. Info Kiri Bawah (Kategori + Nama)
              Positioned(
                left: 12,
                bottom: 10,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      gear.category.toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      gear.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    color: AppColors.ink,
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Square / Grid Tile (Reel, Line, Lure, Hook, dll)
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(
            color: isSelected ? AppColors.ink : AppColors.line,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Category tag & stat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    gear.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                if (stat.isNotEmpty)
                  Text(
                    stat,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),

            // Middle image
            Expanded(
              child: Center(
                child: Image.network(
                  gear.image,
                  fit: BoxFit.contain,
                  headers: const {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                  },
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.phishing,
                    size: 28,
                    color: AppColors.muted.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Bottom name
            Text(
              gear.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.15,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
