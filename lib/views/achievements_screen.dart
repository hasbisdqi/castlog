import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();

    final achievements = [
      {
        'id': '01',
        'title': 'First Catch',
        'desc': 'Record your first fish in CastLog.',
        'unlocked': controller.catches.isNotEmpty,
      },
      {
        'id': '02',
        'title': 'Regular Angler',
        'desc': 'Complete 10 fishing sessions.',
        'unlocked': controller.pastSessions.length >= 2,
      },
      {
        'id': '03',
        'title': 'Heavyweight',
        'desc': 'Catch a fish above 10 kg.',
        'unlocked': controller.catches.any((c) => c.weightKg >= 8.0),
      },
      {
        'id': '04',
        'title': 'Species Collector',
        'desc': 'Record 5 different species.',
        'unlocked': controller.catches.map((c) => c.species).toSet().length >= 3,
      },
      {
        'id': '05',
        'title': 'Journal Keeper',
        'desc': 'Save active catch entries.',
        'unlocked': true,
      },
      {
        'id': '06',
        'title': 'Local Competitor',
        'desc': 'Join your regional leaderboard.',
        'unlocked': true,
      },
      {
        'id': '07',
        'title': 'Top Ten',
        'desc': 'Reach the top 10 in your region.',
        'unlocked': false,
      },
      {
        'id': '08',
        'title': 'Legendary Catch',
        'desc': 'Record a unique trophy catch.',
        'unlocked': false,
      },
    ];

    final unlockedCount = achievements.where((a) => a['unlocked'] == true).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, size: 14, color: AppColors.muted),
                      const SizedBox(width: 6),
                      Text(
                        'Back',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Eyebrow
              Text(
                'MILESTONES & RECORDS',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),

              // Page Title
              Text(
                'Personal best.',
                style: GoogleFonts.manrope(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  height: 1.13,
                  letterSpacing: -2.0,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Small milestones from every fishing session.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Section: Your records
              _buildRecordsSection(controller),
              const SizedBox(height: 36),

              // Section: Achievements
              _buildAchievementsSection(achievements, unlockedCount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsSection(SessionController controller) {
    CatchModel? heaviest;
    for (final c in controller.catches) {
      if (heaviest == null || c.weightKg > heaviest.weightKg) {
        heaviest = c;
      }
    }

    final speciesCounts = <String, int>{};
    for (final c in controller.catches) {
      speciesCounts[c.species] = (speciesCounts[c.species] ?? 0) + 1;
    }
    String mostCaught = 'Common Carp';
    int maxCount = 0;
    speciesCounts.forEach((k, v) {
      if (v > maxCount) {
        maxCount = v;
        mostCaught = k;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your records',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            Text(
              '4 RECORDS',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.line),
              bottom: BorderSide(color: AppColors.line),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildMetaItem(
                      'HEAVIEST CATCH',
                      heaviest != null ? heaviest.weightFormatted : '8.2 kg',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetaItem('MOST CAUGHT SPECIES', mostCaught),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildMetaItem('LONGEST SESSION', '3h 20m'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetaItem('MOST CATCHES / SESSION', '18 fish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(
    List<Map<String, dynamic>> achievements,
    int unlockedCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            Text(
              '$unlockedCount / ${achievements.length} UNLOCKED',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final a = achievements[index];
            final isUnlocked = a['unlocked'] as bool;

            return Opacity(
              opacity: isUnlocked ? 1.0 : 0.45,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['id'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      a['title'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a['desc'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
