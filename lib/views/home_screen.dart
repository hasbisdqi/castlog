import 'package:castlog/widgets/catch_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:castlog/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    _buildCurrentSessionSection(context),
                    const SizedBox(height: 12),
                    _buildHomeShortcuts(context),
                    const SizedBox(height: 36),
                    _buildStatsRow(),
                    const SizedBox(height: 38),
                    _buildLocalLeaderboard(context),
                    const SizedBox(height: 38),
                    _buildRecentCatches(context),
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
          onTap: () {},
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

  Widget _buildCurrentSessionSection(BuildContext context) {
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
            GestureDetector(
              onTap: () {},
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
        const SizedBox(height: 15),
        _buildActiveSessionCard(),
      ],
    );
  }

  Widget _buildActiveSessionCard() {
    return Container(
      height: 285,
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: Image.network(
                'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
                headers: const {'User-Agent': 'Mozilla/5.0'},
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: const Color.fromRGBO(226, 226, 80, 1)),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.1, 0.38, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 19,
            right: 19,
            child: Text(
              '●  LIVE SESSION',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 19,
            left: 19,
            right: 19,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Russia · Emerald Lake',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFFDDDDDD),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Emerald Lake',
                  style: GoogleFonts.manrope(
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(top: 13),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0x55FFFFFF))),
                  ),
                  child: Row(
                    children: [
                      _buildSessionMetaItem('DURATION', '02h 34m'),
                      const SizedBox(width: 24),
                      _buildSessionMetaItem('CATCHES', '12 fish'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Color(0xFF111111),
                size: 20,
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

  Widget _buildHomeShortcuts(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(
            text: 'All sessions',
            icon: '↗',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _buildSecondaryButton(text: '＋ New session', onTap: () {}),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    String? icon,
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
              Text(
                icon,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
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
            child: _buildStatItem('128', 'Total catches', hasBorder: false),
          ),
          Expanded(
            child: _buildStatItem('18.4 kg', 'Personal best', hasBorder: true),
          ),
          Expanded(child: _buildStatItem('24', 'Sessions', hasBorder: true)),
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

  Widget _buildLocalLeaderboard(BuildContext context) {
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
              onTap: () {},
              child: Text(
                'View rankings →',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {},
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
                      Text(
                        'YOUR REGION · YOGYAKARTA',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                          color: AppColors.muted,
                        ),
                      ),
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
                Text(
                  '#12 ↗',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.0,
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

  Widget _buildRecentCatches(BuildContext context) {
    final catches = [
      {
        'title': 'Common Carp',
        'sub': 'Emerald Lake · 2 hours ago',
        'weight': '8.2 kg',
        'image': 'https://wiki.fishingplanet.com/images/e/e6/Common_Carp.png',
      },
      {
        'title': 'Grass Carp',
        'sub': 'Emerald Lake · Yesterday',
        'weight': '6.7 kg',
        'image': 'https://wiki.fishingplanet.com/images/a/ae/Grass_Carp.png',
      },
      {
        'title': 'Mirror Carp',
        'sub': 'Lonely Oak · 2 days ago',
        'weight': '5.1 kg',
        'image': 'https://wiki.fishingplanet.com/images/0/0d/Mirror_Carp.png',
      },
    ];

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
              onTap: () {},
              child: Text(
                'View all →',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: catches.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom = 2
            crossAxisSpacing: 16, // Jarak horizontal antar kartu
            mainAxisSpacing: 16, // Jarak vertikal antar kartu
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            return CatchCard(item: catches[index]);
          },
        ),
      ],
    );
  }
}
