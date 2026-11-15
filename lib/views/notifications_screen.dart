import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _sessionReminder = true;
  bool _journalReminder = true;
  bool _personalBestAlert = true;
  bool _leaderboardUpdate = true;

  String _quietFrom = '22:00';
  String _quietUntil = '07:00';

  @override
  Widget build(BuildContext context) {
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
                        'Settings',
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
                'PREFERENCES',
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
                'Notifications.',
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
                'Choose which reminders deserve your attention.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Reminders Section
              Text(
                'Reminders',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              _buildToggleRow(
                title: 'Session reminder',
                subtitle: 'A reminder to log your fishing session.',
                value: _sessionReminder,
                onChanged: (val) => setState(() => _sessionReminder = val),
              ),
              _buildToggleRow(
                title: 'Catch journal reminder',
                subtitle: 'Remind me to complete an unfinished catch entry.',
                value: _journalReminder,
                onChanged: (val) => setState(() => _journalReminder = val),
              ),
              _buildToggleRow(
                title: 'Personal best alert',
                subtitle: 'When a new personal record is recorded.',
                value: _personalBestAlert,
                onChanged: (val) => setState(() => _personalBestAlert = val),
              ),
              _buildToggleRow(
                title: 'Leaderboard update',
                subtitle: 'When my local ranking changes.',
                value: _leaderboardUpdate,
                onChanged: (val) => setState(() => _leaderboardUpdate = val),
              ),
              const SizedBox(height: 36),

              // Quiet Hours Section
              Text(
                'Quiet hours',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeInput('From', _quietFrom, (val) {
                      setState(() => _quietFrom = val);
                    }),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTimeInput('Until', _quietUntil, (val) {
                      setState(() => _quietUntil = val);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Save Button
              InkWell(
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Preferences Saved',
                    'Your notification preferences have been updated.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.paper,
                    colorText: AppColors.ink,
                    borderRadius: 0,
                    borderColor: AppColors.ink,
                    borderWidth: 1,
                    margin: const EdgeInsets.all(16),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  color: AppColors.ink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Save preferences',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '↗',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Notification controls are visual preferences for your CastLog companion experience.',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.ink,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.paper,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const Icon(Icons.access_time, size: 16, color: AppColors.muted),
            ],
          ),
        ),
      ],
    );
  }
}
