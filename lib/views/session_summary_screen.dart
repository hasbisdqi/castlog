import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/start_session_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SessionSummaryScreen extends StatelessWidget {
  final SessionModel? sessionData;

  const SessionSummaryScreen({super.key, this.sessionData});

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _formatDateSpan(DateTime start, DateTime? end) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final m = months[start.month - 1];
    final d = start.day.toString().padLeft(2, '0');
    final y = start.year;
    final startT = _formatTime(start);
    final endT = end != null ? _formatTime(end) : _formatTime(DateTime.now());
    return '$m $d, $y · $startT – $endT';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    final SessionModel? session = sessionData ??
        (Get.arguments is SessionModel
            ? Get.arguments as SessionModel
            : controller.lastCompletedSession.value ??
                (controller.pastSessions.isNotEmpty ? controller.pastSessions.first : null));

    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, size: 36, color: AppColors.muted),
                const SizedBox(height: 12),
                Text(
                  'No recent session summary found',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Get.offAllNamed(AppRoutes.home),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: AppColors.ink,
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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

    final uniqueSpecies = session.catches.map((c) => c.species).toSet().length;
    final heaviest = session.biggestCatch;
    final waterwayShort = session.waterwayName.split(" - ").first;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back to Home
              InkWell(
                onTap: () => Get.offAllNamed(AppRoutes.home),
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
                'SESSION COMPLETED',
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
                'A good day\non the water.',
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
                'Your fishing session has been saved to your history.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),

              // Rank Hero / Session Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${session.waterwayName} · ${session.waterwayRegion}'.toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Session summary.',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateSpan(session.startTime, session.endTime),
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFFC4C4C0),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Stats Row
              _buildStatsBlock(
                catchesCount: session.catches.length,
                speciesCount: uniqueSpecies,
                durationFormatted: session.formattedDuration,
              ),
              const SizedBox(height: 24),

              // Detail Meta Grid
              _buildMetaGrid(session, heaviest, waterwayShort),
              const SizedBox(height: 36),

              // Notable Catches Highlight
              if (session.catches.isNotEmpty) ...[
                _buildNotableCatches(session),
                const SizedBox(height: 36),
              ],

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBlock({
    required int catchesCount,
    required int speciesCount,
    required String durationFormatted,
  }) {
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
            child: _buildStatItem('$catchesCount', 'Catches', hasBorder: false),
          ),
          Expanded(
            child: _buildStatItem('$speciesCount', 'Species', hasBorder: true),
          ),
          Expanded(
            child: _buildStatItem(durationFormatted, 'Duration', hasBorder: true),
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

  Widget _buildMetaGrid(
    SessionModel session,
    CatchModel? heaviest,
    String waterwayShort,
  ) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMetaItem(
                  'HEAVIEST CATCH',
                  heaviest != null ? '${heaviest.species} · ${heaviest.weightFormatted}' : 'None recorded',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetaItem(
                  'PRODUCTIVE SETUP',
                  session.loadout.name,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMetaItem(
                  'MAP',
                  waterwayShort,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetaItem(
                  'RODS USED',
                  '${session.loadout.rods.length} setups',
                ),
              ),
            ],
          ),
        ],
      ),
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
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildNotableCatches(SessionModel session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catches logged (${session.catches.length})',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: session.catches.map((c) {
            return InkWell(
              onTap: () => Get.toNamed(AppRoutes.catchDetail, arguments: c),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      color: AppColors.soft,
                      child: c.image != null && c.image!.isNotEmpty
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ]),
                              child: Image.network(
                                c.image!,
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
                            c.species,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${c.rodName} · ${c.baitOrLure ?? "Bait"}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      c.weightFormatted,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Get.offAllNamed(AppRoutes.home),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            color: AppColors.ink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Back to home',
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
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            Get.offAllNamed(AppRoutes.home);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              StartSessionBottomSheet.show(Get.context ?? context);
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.line),
            ),
            child: Center(
              child: Text(
                'Start another session',
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
    );
  }
}
