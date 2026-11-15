import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                        'Home',
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
                'YOUR ACCOUNT',
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
                'Profile.',
                style: GoogleFonts.manrope(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  height: 1.13,
                  letterSpacing: -2.0,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 20),

              // Profile Head (Clickable to open Angler Profile)
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.anglerProfile),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
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
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View angler profile ↗',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Obx(() => _buildStatsRow(controller)),
              const SizedBox(height: 36),

              // Community Section
              _buildSectionHeader('Community'),
              const SizedBox(height: 10),
              _buildSettingsRow(
                title: 'My region',
                value: 'North America ↗',
                onTap: () {
                  Get.snackbar(
                    'Region',
                    'Current region is North America',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.paper,
                    colorText: AppColors.ink,
                    borderRadius: 0,
                    borderColor: AppColors.ink,
                    borderWidth: 1,
                    margin: const EdgeInsets.all(16),
                  );
                },
              ),
              _buildSettingsRow(
                title: 'Personal best & achievements',
                value: 'View →',
                onTap: () => Get.toNamed(AppRoutes.achievements),
              ),
              const SizedBox(height: 36),

              // Preferences Section
              _buildSectionHeader('Preferences'),
              const SizedBox(height: 10),
              _buildSettingsRow(
                title: 'Display name',
                value: 'Fishing Journal',
              ),
              _buildSettingsRow(
                title: 'Weight unit',
                value: 'Kilograms · kg',
              ),
              _buildSettingsRow(
                title: 'Length unit',
                value: 'Centimeters · cm',
              ),
              _buildSettingsRow(
                title: 'Appearance',
                value: 'Monochrome',
              ),
              _buildSettingsRow(
                title: 'Notification settings',
                value: 'Manage →',
                onTap: () => Get.toNamed(AppRoutes.notifications),
              ),
              _buildSettingsRow(
                title: 'Data & backup',
                value: 'Local storage (Hive)',
              ),
              _buildSettingsRow(
                title: 'About CastLog',
                value: 'Version 1.0',
              ),
              const SizedBox(height: 24),

              // Notice
              Text(
                'CastLog is an independent companion journal for Fishing Planet. It is not affiliated with the game developers.',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.muted,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.ink,
      ),
    );
  }

  Widget _buildStatsRow(SessionController controller) {
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
            child: _buildStatItem('#12', 'Local rank', hasBorder: false),
          ),
          Expanded(
            child: _buildStatItem(
              maxWeight > 0 ? '${maxWeight.toStringAsFixed(1)} kg' : '0.0 kg',
              'Personal best',
              hasBorder: true,
            ),
          ),
          Expanded(
            child: _buildStatItem('06', 'Achievements', hasBorder: true),
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

  Widget _buildSettingsRow({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
