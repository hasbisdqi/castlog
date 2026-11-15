import 'package:castlog/controllers/auth_controller.dart';
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
    final authController = Get.find<AuthController>();

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
              Obx(() {
                final user = authController.currentUser.value;
                final name = (user != null && user.displayName.isNotEmpty)
                    ? user.displayName
                    : 'Fishing Journal';
                final isSupabase = authController.isLoggedIn;

                return InkWell(
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
                            image: DecorationImage(
                              image: NetworkImage(user?.avatarUrl ??
                                  'https://i.pravatar.cc/150?img=12'),
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
                                name,
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user?.email ?? 'guest@castlog.local',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: AppColors.muted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isSupabase
                                      ? const Color(0xFFE8F5E9)
                                      : AppColors.soft,
                                  border: Border.all(
                                    color: isSupabase
                                        ? const Color(0xFF81C784)
                                        : AppColors.line,
                                  ),
                                ),
                                child: Text(
                                  isSupabase
                                      ? '● Supabase Cloud'
                                      : '○ Guest Mode',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSupabase
                                        ? const Color(0xFF2E7D32)
                                        : AppColors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Stats Row
              Obx(() => _buildStatsRow(controller)),
              const SizedBox(height: 36),

              // Community Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Community'),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.leaderboard),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Leaderboard',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 12, color: AppColors.muted),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() => _buildSettingsRow(
                    title: 'My region',
                    value: controller.userRegion.value,
                    onTap: () => Get.toNamed(AppRoutes.region),
                  )),
              _buildSettingsRow(
                title: 'Personal best & achievements',
                value: 'View',
                onTap: () => Get.toNamed(AppRoutes.achievements),
              ),
              const SizedBox(height: 36),

              // Preferences Section
              _buildSectionHeader('Preferences'),
              const SizedBox(height: 10),
              Obx(() => _buildSettingsRow(
                    title: 'Account',
                    value: authController.isLoggedIn
                        ? authController.currentUser.value!.email
                        : 'Guest · Not signed in',
                  )),
              _buildSettingsRow(
                title: 'Cloud sync',
                value: 'Supabase PostgreSQL',
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
                value: 'Manage',
                onTap: () => Get.toNamed(AppRoutes.notifications),
              ),
              _buildSettingsRow(
                title: 'Data & backup',
                value: 'Local storage (Hive) + Cloud',
              ),
              _buildSettingsRow(
                title: 'About CastLog',
                value: 'Version 1.0',
              ),
              const SizedBox(height: 28),

              // Auth Action Button (Sign in / Sign out)
              Obx(() {
                if (authController.isLoggedIn) {
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => authController.signOut(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade800,
                        side: BorderSide(color: Colors.red.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        'Sign out of Supabase',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign in with Supabase',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_outward, size: 14),
                        ],
                      ),
                    ),
                  );
                }
              }),
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
            child: _buildStatItem(
              controller.catches.isEmpty ? '--' : '#1',
              'Local rank',
              hasBorder: false,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              maxWeight > 0 ? '${maxWeight.toStringAsFixed(1)} kg' : '0.0 kg',
              'Personal best',
              hasBorder: true,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              '0${controller.unlockedAchievementsCount}',
              'Achievements',
              hasBorder: true,
            ),
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
