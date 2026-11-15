import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/log_catch_bottom_sheet.dart';
import 'package:castlog/widgets/start_session_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final active = controller.activeSession.value;
          if (active == null) {
            return _buildNoActiveSession(context);
          }

          final waterwayShort = active.waterwayName.split(" - ").first;
          final uniqueSpecies = active.catches.map((c) => c.species).toSet().length;
          final heaviest = active.biggestCatch?.weightKg ?? 0.0;

          return SingleChildScrollView(
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
                Obx(
                  () => Text(
                    'LIVE SESSION · ${controller.formattedTimer.value}',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Page Title
                Text(
                  '$waterwayShort.',
                  style: GoogleFonts.manrope(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    height: 1.13,
                    letterSpacing: -2.0,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${active.waterwayRegion} · Loadout: ${active.loadout.name}',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Session Hero Card
                _buildHeroCard(active, controller),
                const SizedBox(height: 28),

                // Stats Row
                _buildStatsBlock(
                  catchesCount: active.catches.length,
                  speciesCount: uniqueSpecies,
                  heaviestKg: heaviest,
                ),
                const SizedBox(height: 36),

                // Rods in Use Section
                _buildRodsSection(active),
                const SizedBox(height: 36),

                // Catches in This Session
                _buildSessionCatches(context, active),
                const SizedBox(height: 36),

                // Bottom Action Buttons
                _buildActionButtons(context, controller, active),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNoActiveSession(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phishing, size: 48, color: AppColors.muted),
            const SizedBox(height: 16),
            Text(
              'No active session',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new fishing expedition to track duration, rods, and catches in real time.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 13, height: 1.5, color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Get.back();
                StartSessionBottomSheet.show(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: AppColors.ink,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Start new session',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(SessionModel active, SessionController controller) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Grayscale Image
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Image.network(
                active.waterwayImage,
                headers: const {'User-Agent': 'Mozilla/5.0'},
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: const Color(0xFF1A1A1A)),
              ),
            ),
          ),

          // Gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.92),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // Status Indicator
          Positioned(
            top: 18,
            left: 19,
            child: Row(
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
                  'LIVE SESSION',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Session Details
          Positioned(
            bottom: 18,
            left: 19,
            right: 19,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current location',
                  style: GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFFCCCCCC)),
                ),
                const SizedBox(height: 3),
                Text(
                  active.waterwayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0x33FFFFFF))),
                  ),
                  child: Row(
                    children: [
                      Obx(() => _buildHeroMetaItem('DURATION', controller.formattedTimer.value)),
                      const SizedBox(width: 24),
                      _buildHeroMetaItem('CATCHES', '${active.catches.length} fish'),
                      const SizedBox(width: 24),
                      _buildHeroMetaItem('RODS', '${active.loadout.rods.length} setups'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 9,
            color: const Color(0xFFCCCCCC),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBlock({
    required int catchesCount,
    required int speciesCount,
    required double heaviestKg,
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
            child: _buildStatColumn('$catchesCount', 'Catches', hasBorder: false),
          ),
          Expanded(
            child: _buildStatColumn('$speciesCount', 'Species', hasBorder: true),
          ),
          Expanded(
            child: _buildStatColumn(
              heaviestKg > 0 ? '${heaviestKg.toStringAsFixed(1)} kg' : '—',
              'Heaviest',
              hasBorder: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {required bool hasBorder}) {
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

  Widget _buildRodsSection(SessionModel active) {
    final rods = active.loadout.rods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rods in use',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            Text(
              '${rods.length} configured',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (rods.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.paper,
            child: Text(
              'No rods configured in this loadout.',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
            ),
          )
        else
          Column(
            children: rods.map((rod) {
              final specs = [
                if (rod.reel != null && rod.reel!.isNotEmpty) rod.reel!,
                if (rod.line != null && rod.line!.isNotEmpty) rod.line!,
                if (rod.baitOrLure.isNotEmpty) rod.baitOrLure,
              ].join(' · ');

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      color: AppColors.ink,
                      child: Text(
                        'ROD ${rod.slotIndex}',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rod.rodName,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            specs.isNotEmpty ? specs : '${rod.type.name.toUpperCase()} setup',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSessionCatches(BuildContext context, SessionModel active) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Catches this session',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            Text(
              '${active.catches.length} total',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (active.catches.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: AppColors.paper,
            child: Column(
              children: [
                const Icon(Icons.phishing, size: 32, color: AppColors.muted),
                const SizedBox(height: 8),
                Text(
                  'No catches recorded yet',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap "Record a catch" below to log fish caught during this trip.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          )
        else
          Column(
            children: active.catches.map((c) {
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
                        width: 52,
                        height: 52,
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
                            const SizedBox(height: 3),
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

  Widget _buildActionButtons(
    BuildContext context,
    SessionController controller,
    SessionModel active,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () => LogCatchBottomSheet.show(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            color: AppColors.ink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Record a catch',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _confirmEndSession(context, controller, active),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.line),
            ),
            child: Center(
              child: Text(
                'End session',
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

  void _confirmEndSession(
    BuildContext context,
    SessionController controller,
    SessionModel active,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.paper,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'End session?',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Are you sure you want to end your session at ${active.waterwayName}? A summary of all your catches will be generated.',
          style: GoogleFonts.dmSans(fontSize: 13, height: 1.5, color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Keep fishing',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(ctx);
              final endedSession = controller.endCurrentSession();
              if (endedSession != null) {
                Get.offNamed(AppRoutes.sessionSummary, arguments: endedSession);
              } else {
                Get.back();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: AppColors.ink,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'End & View Summary',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
