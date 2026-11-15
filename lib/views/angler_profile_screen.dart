import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AnglerProfileScreen extends StatelessWidget {
  const AnglerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();

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
                        'Profile',
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
                'ANGLER PROFILE',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 16),

              // Profile Head
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.soft,
                      border: Border.all(color: AppColors.line),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=12'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fishing Journal',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'North America · Angler since 2026',
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
              const SizedBox(height: 24),

              // Page Title
              Text(
                'A record of\nevery cast.',
                style: GoogleFonts.manrope(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  height: 1.13,
                  letterSpacing: -2.0,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 24),

              // Stats Block
              Obx(() => _buildStatsRow(controller)),
              const SizedBox(height: 36),

              // Section: Personal bests
              _buildPersonalBests(controller),
              const SizedBox(height: 36),

              // Section: Community
              _buildCommunitySection(),
              const SizedBox(height: 28),

              // Profile Settings Button
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Center(
                    child: Text(
                      'Profile settings',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
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

  Widget _buildStatsRow(SessionController controller) {
    final totalCatches = controller.catches.length;
    double maxWeight = 0;
    for (final c in controller.catches) {
      if (c.weightKg > maxWeight) maxWeight = c.weightKg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.line),
          bottom: BorderSide(color: AppColors.line),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('$totalCatches', 'Total catches', hasBorder: false),
          ),
          Expanded(
            child: _buildStatItem(
              maxWeight > 0 ? '${maxWeight.toStringAsFixed(1)} kg' : '0.0 kg',
              'Personal best',
              hasBorder: true,
            ),
          ),
          Expanded(
            child: _buildStatItem('#12', 'Local rank', hasBorder: true),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {required bool hasBorder}) {
    return Container(
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        border: Border(
          left: hasBorder ? const BorderSide(color: AppColors.line) : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.2,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalBests(SessionController controller) {
    CatchModel? heaviest;
    for (final c in controller.catches) {
      if (heaviest == null || c.weightKg > heaviest.weightKg) {
        heaviest = c;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Personal bests',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.achievements),
              child: Text(
                'All achievements →',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (heaviest != null)
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.catchDetail, arguments: heaviest),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    color: AppColors.soft,
                    child: heaviest.image != null && heaviest.image!.isNotEmpty
                        ? ColorFiltered(
                            colorFilter: const ColorFilter.matrix(<double>[
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0, 0, 0, 1, 0,
                            ]),
                            child: Image.network(
                              heaviest.image!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(Icons.phishing, size: 20, color: AppColors.muted),
                            ),
                          )
                        : const Icon(Icons.phishing, size: 20, color: AppColors.muted),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heaviest.species,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Heaviest catch · ${heaviest.waterway.split(" - ").first}',
                          style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    heaviest.weightFormatted,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        _buildInfoRow('Region', 'North America'),
        _buildInfoRow('Current rank', '#12 overall'),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
