import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RankDetailScreen extends StatelessWidget {
  const RankDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional argument passed via Get.toNamed(AppRoutes.rankDetail, arguments: {...})
    final Map<String, dynamic> args =
        (Get.arguments as Map<String, dynamic>?) ?? {};

    final String rank = args['rank'] ?? '01';
    final String anglerName = args['anglerName'] ?? 'Arga Pratama';
    final String anglerAvatar =
        args['avatarUrl'] ?? 'https://i.pravatar.cc/150?img=11';
    final String species = args['species'] ?? 'Common Carp';
    final String location = args['location'] ?? 'Emerald Lake';
    final String region = args['region'] ?? 'Yogyakarta';
    final String weight = args['weight'] ?? '18.42 kg';
    final String date = args['date'] ?? 'Nov 11, 2026';
    final String rod = args['rod'] ?? 'Carp Hunter';
    final String bait = args['bait'] ?? 'Sweet Corn';
    final String photoUrl = args['photoUrl'] ??
        'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85';

    // Grayscale color matrix for editorial photo
    const ColorFilter greyscaleFilter = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 16, color: AppColors.muted),
                    const SizedBox(width: 6),
                    Text(
                      'Leaderboard',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Eyebrow
              Text(
                'LEADERBOARD ENTRY · RANK #$rank',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'A remarkable catch.',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 18),

              // Photo (Grayscale)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  border: Border.all(color: AppColors.line),
                ),
                child: ColorFiltered(
                  colorFilter: greyscaleFilter,
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.soft,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: AppColors.muted),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Eyebrow: Species · Region
              Text(
                '$species · $region',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),

              // Rank detail weight
              Text(
                weight,
                style: GoogleFonts.manrope(
                  fontSize: 52,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -3.0,
                  color: AppColors.ink,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 22),

              // Profile Head
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.line),
                    bottom: BorderSide(color: AppColors.line),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.soft,
                      backgroundImage: NetworkImage(anglerAvatar),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anglerName,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Rank #$rank · Local leaderboard',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Detail Meta Grid (2 columns, 6 items)
              _buildMetaGrid([
                {'label': 'SPECIES', 'value': species},
                {'label': 'WEIGHT', 'value': weight},
                {'label': 'LOCATION', 'value': location},
                {'label': 'DATE', 'value': date},
                {'label': 'ROD', 'value': rod},
                {'label': 'BAIT', 'value': bait},
              ]),
              const SizedBox(height: 22),

              // Prototype Notice
              Text(
                'This is sample leaderboard content for the visual prototype, not a verified player submission.',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Back to rankings button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'Back to rankings',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaGrid(List<Map<String, String>> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i += 2) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 1, color: AppColors.line),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetaCell(
                      items[i]['label']!,
                      items[i]['value']!,
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.line,
                  ),
                  Expanded(
                    child: (i + 1 < items.length)
                        ? _buildMetaCell(
                            items[i + 1]['label']!,
                            items[i + 1]['value']!,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
