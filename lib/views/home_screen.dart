import 'package:castlog/controllers/navigation_controller.dart';
import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/catch_card.dart';
import 'package:castlog/widgets/log_catch_bottom_sheet.dart';
import 'package:castlog/widgets/start_session_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: AppColors.bg,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: _buildTopBar(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroHeader(),
                    const SizedBox(height: 38),
                    _buildCurrentSessionSection(context, sessionController),
                    const SizedBox(height: 12),
                    _buildHomeShortcuts(context, sessionController),
                    const SizedBox(height: 36),
                    Obx(() => _buildStatsRow(sessionController)),
                    const SizedBox(height: 38),
                    _buildLocalLeaderboard(context, sessionController),
                    const SizedBox(height: 38),
                    Obx(() => _buildRecentCatches(context, sessionController)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -1.2,
            ),
            children: const [
              TextSpan(text: 'cast'),
              TextSpan(
                text: 'log.',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profile),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.soft,
              border: Border.all(color: AppColors.line),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/100?img=12'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR FISHING JOURNAL',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Every catch\ntells a story.',
          style: GoogleFonts.manrope(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            height: 1.13,
            letterSpacing: -2.0,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your Fishing Planet adventures,\nall in one place.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            height: 1.7,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentSessionSection(
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
                'Current session',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              if (active != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.activeSession),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Open',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 12, color: AppColors.ink),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () => _confirmEndSession(context, controller, active),
                      child: Text(
                        'End session',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 15),
          active != null
              ? _buildActiveSessionCard(context, controller, active)
              : _buildNoActiveSessionCard(context),
        ],
      );
    });
  }

  Widget _buildNoActiveSessionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
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
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'NO ACTIVE EXPEDITION',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Ready to cast?',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick a waterway, select your multi-rod setup, and start recording your catches in real time.',
            style: GoogleFonts.dmSans(fontSize: 12, height: 1.5, color: AppColors.muted),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: () => StartSessionBottomSheet.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(
    BuildContext context,
    SessionController controller,
    dynamic active,
  ) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.activeSession),
      child: Container(
        height: 295,
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
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
                  errorBuilder: (_, _, _) =>
                      Container(color: const Color(0xFF1A1A1A)),
                ),
              ),
            ),

            // Dark Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),

            // Live Pulse Status
            Positioned(
              top: 18,
              left: 19,
              right: 19,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF22C55E), // Live green
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

            // Session Info & Details
            Positioned(
              bottom: 19,
              left: 19,
              right: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    active.waterwayRegion,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFFCCCCCC),
                    ),
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
                  const SizedBox(height: 4),
                  Text(
                    'Loadout: ${active.loadout.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFFBBBBBB),
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
                        Obx(() => _buildSessionMetaItem('DURATION', controller.formattedTimer.value)),
                        const SizedBox(width: 24),
                        _buildSessionMetaItem('CATCHES', '${active.catches.length} fish'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Log Catch Button (+ in circle)
            Positioned(
              right: 18,
              bottom: 18,
              child: InkWell(
                onTap: () => LogCatchBottomSheet.show(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF111111),
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmEndSession(
    BuildContext context,
    SessionController controller,
    dynamic active,
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
                Get.toNamed(AppRoutes.sessionSummary, arguments: endedSession);
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

  Widget _buildSessionMetaItem(String label, String value) {
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
        const SizedBox(height: 4),
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

  Widget _buildHomeShortcuts(
    BuildContext context,
    SessionController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(
            text: 'All sessions',
            icon: Icons.arrow_forward,
            onTap: () => Get.toNamed(AppRoutes.sessions),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Obx(() {
            final hasActive = controller.activeSession.value != null;
            return _buildSecondaryButton(
              text: hasActive ? 'Log catch' : 'New session',
              icon: Icons.add,
              onTap: () {
                if (hasActive) {
                  LogCatchBottomSheet.show(context);
                } else {
                  StartSessionBottomSheet.show(context);
                }
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                size: 14,
                color: AppColors.ink,
              ),
          ],
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
      padding: const EdgeInsets.symmetric(vertical: 22),
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
            child: _buildStatItem(
              controller.activeSession.value != null ? '1 Active' : '0 Active',
              'Sessions',
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
          left: hasBorder
              ? const BorderSide(color: AppColors.line)
              : BorderSide.none,
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

  Widget _buildLocalLeaderboard(
      BuildContext context, SessionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Local leaderboard',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.leaderboard),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View rankings',
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
        const SizedBox(height: 15),
        InkWell(
          onTap: () => Get.toNamed(AppRoutes.leaderboard),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            'YOUR REGION · ${controller.userRegion.value.toUpperCase()}',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.8,
                              color: AppColors.muted,
                            ),
                          )),
                      const SizedBox(height: 6),
                      Text(
                        'See how you rank locally.',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Top catches from anglers around you.',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                          controller.catches.isEmpty ? '--' : '#1',
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0,
                            color: AppColors.ink,
                          ),
                        )),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 16, color: AppColors.ink),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCatches(BuildContext context, SessionController controller) {
    final list = controller.catches.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent catches',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            GestureDetector(
              onTap: () => Get.find<NavigationController>().changeTab(1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Full journal',
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
        const SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return CatchCard(catchModel: list[index]);
          },
        ),
      ],
    );
  }
}
