import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/start_session_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final m = months[dt.month - 1];
    final d = dt.day.toString().padLeft(2, '0');
    final y = dt.year;
    return '$m $d, $y';
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

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
                'TIME ON THE WATER',
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
                'Sessions.',
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
                'Every trip, every spot, every story.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Section: Active session
              _buildActiveSessionSection(context, controller),
              const SizedBox(height: 36),

              // Section: Past sessions
              _buildPastSessionsSection(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSessionSection(
    BuildContext context,
    SessionController controller,
  ) {
    return Obx(() {
      final active = controller.activeSession.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active session',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              if (active != null)
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.activeSession),
                  child: Text(
                    'Open →',
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
          if (active != null)
            _buildActiveSessionRow(active, controller)
          else
            _buildNoActiveSessionBox(context),
        ],
      );
    });
  }

  Widget _buildActiveSessionRow(
    SessionModel active,
    SessionController controller,
  ) {
    final waterwayShort = active.waterwayName.split(" - ").first;

    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.activeSession),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF22C55E),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        waterwayShort,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${active.waterwayRegion} · Started ${_formatTime(active.startTime)}',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${active.catches.length}',
                  style: GoogleFonts.manrope(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'catches · active',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoActiveSessionBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.soft,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No session in progress.',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start a session to track your catches and time.',
            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () => StartSessionBottomSheet.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: AppColors.ink,
              child: Text(
                'Start a session ↗',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastSessionsSection(
    BuildContext context,
    SessionController controller,
  ) {
    return Obx(() {
      final list = controller.pastSessions;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Past sessions',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              InkWell(
                onTap: () => StartSessionBottomSheet.show(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '＋ New session',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (list.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              color: AppColors.paper,
              child: Center(
                child: Text(
                  'No past sessions recorded yet.',
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                ),
              ),
            )
          else
            Column(
              children: list.map((session) {
                return _buildPastSessionRow(session);
              }).toList(),
            ),
        ],
      );
    });
  }

  Widget _buildPastSessionRow(SessionModel session) {
    final waterwayShort = session.waterwayName.split(" - ").first;

    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.sessionSummary, arguments: session),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    waterwayShort,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${session.waterwayRegion} · ${_formatDate(session.startTime)}',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session.catches.length}',
                  style: GoogleFonts.manrope(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'catches · ${session.formattedDuration}',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
