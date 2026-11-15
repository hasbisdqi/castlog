import 'package:castlog/services/notification_service.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  // Scheduled notification state (Modul 7)
  DateTime? _scheduledTime;
  String _selectedWaterway = 'Emerald Lake';

  final List<String> _waterways = [
    'Emerald Lake',
    'Lone Star Lake',
    'Mudwater River',
    'Neherrin River',
    'Falcon Lake',
    'Saint-Croix Lake',
    'San Joaquin Delta',
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    try {
      if (Hive.isBoxOpen('settings_box')) {
        final box = Hive.box('settings_box');
        setState(() {
          _sessionReminder = box.get('notif_session', defaultValue: true);
          _journalReminder = box.get('notif_journal', defaultValue: true);
          _personalBestAlert = box.get('notif_pb', defaultValue: true);
          _leaderboardUpdate = box.get('notif_leaderboard', defaultValue: true);
          _quietFrom = box.get('notif_quiet_from', defaultValue: '22:00');
          _quietUntil = box.get('notif_quiet_until', defaultValue: '07:00');
        });
      }
    } catch (_) {}
  }

  void _savePreferences() {
    try {
      if (Hive.isBoxOpen('settings_box')) {
        final box = Hive.box('settings_box');
        box.put('notif_session', _sessionReminder);
        box.put('notif_journal', _journalReminder);
        box.put('notif_pb', _personalBestAlert);
        box.put('notif_leaderboard', _leaderboardUpdate);
        box.put('notif_quiet_from', _quietFrom);
        box.put('notif_quiet_until', _quietUntil);
      }
    } catch (_) {}

    Get.snackbar(
      'Preferences Saved',
      'Your notification preferences have been saved to local storage.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.paper,
      colorText: AppColors.ink,
      borderRadius: 0,
      borderColor: AppColors.ink,
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);

    String dateLabel;
    if (date == today) {
      dateLabel = 'Today';
    } else if (date == tomorrow) {
      dateLabel = 'Tomorrow';
    } else {
      dateLabel = '${dt.day}/${dt.month}/${dt.year}';
    }

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$dateLabel, $hour:$minute';
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.ink,
              onPrimary: Colors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.ink,
              onPrimary: Colors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _scheduledTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

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
                'PREFERENCES & MODUL 7',
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
                'Session alerts, catch notifications, and scheduled reminders for Fishing Planet.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // ==========================================
              // SECTION 1: IMMEDIATE NOTIFICATIONS
              // ==========================================
              _buildSectionTitle('Immediate Notifications'),
              const SizedBox(height: 6),
              Text(
                'Trigger an instant alert directly to the device notification tray.',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.notifications_active, size: 18),
                  label: const Text('Send Instant Notification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    await NotificationService().showInstantNotification(
                      title: 'Hello Angler!',
                      body: 'This is an immediate test notification from CastLog.',
                    );
                    Get.snackbar(
                      'Notification Sent',
                      'Instant alert delivered to notification tray.',
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
              ),
              const SizedBox(height: 36),

              // ==========================================
              // SECTION 2: SCHEDULED NOTIFICATIONS
              // ==========================================
              _buildSectionTitle('Scheduled Session Reminders'),
              const SizedBox(height: 6),
              Text(
                'Schedule peak bite hour reminders for your chosen waterway. Triggers even when the app is closed.',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 14),

              // Waterway Picker
              Text(
                'SELECT WATERWAY',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedWaterway,
                    items: _waterways.map((w) {
                      return DropdownMenuItem<String>(
                        value: w,
                        child: Text(
                          w,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedWaterway = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // DateTime Picker Box
              Text(
                'REMINDER DATE & TIME',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: AppColors.muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _scheduledTime == null
                              ? 'Select date and time...'
                              : _formatDateTime(_scheduledTime!),
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _scheduledTime == null ? AppColors.muted : AppColors.ink,
                          ),
                        ),
                      ),
                      if (_scheduledTime != null)
                        GestureDetector(
                          onTap: () => setState(() => _scheduledTime = null),
                          child: const Icon(Icons.close, size: 18, color: AppColors.muted),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Set Reminder Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.alarm, size: 18),
                  label: const Text('Set Session Reminder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _scheduledTime == null ? AppColors.soft : AppColors.ink,
                    foregroundColor: _scheduledTime == null ? AppColors.muted : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _scheduledTime == null
                      ? null
                      : () async {
                          final scheduledTime = _scheduledTime!;
                          await NotificationService().scheduleNotification(
                            id: 1,
                            title: 'Session Reminder: $_selectedWaterway',
                            body:
                                'Peak bite hours at $_selectedWaterway have begun. Open Fishing Planet to start casting!',
                            scheduledTime: scheduledTime,
                          );

                          Get.snackbar(
                            'Reminder Scheduled',
                            'Alert set for $_selectedWaterway at ${_formatDateTime(scheduledTime)}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.paper,
                            colorText: AppColors.ink,
                            borderRadius: 0,
                            borderColor: AppColors.ink,
                            borderWidth: 1,
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 4),
                          );

                          setState(() => _scheduledTime = null);
                        },
                ),
              ),
              const SizedBox(height: 36),

              // ==========================================
              // BAGIAN 3: TOGGLES & PREFERENSI (PROTOTYPE)
              // ==========================================
              _buildSectionTitle('Reminders Preferences'),
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
              const SizedBox(height: 32),

              // Quiet Hours Section
              _buildSectionTitle('Quiet hours'),
              const SizedBox(height: 14),
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

              // Save Preferences Button
              InkWell(
                onTap: _savePreferences,
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
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Notification preferences are saved locally and synced with flutter_local_notifications plugin.',
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

  Widget _buildSectionTitle(String title) {
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
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
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
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.paper,
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
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
