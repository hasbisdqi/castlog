import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CastLog hook emblem + wordmark widget using the official hook logo asset.
/// Matches the editorial journal theme (`AppColors.ink` & `AppColors.bg`).
class CastlogLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool inverted;

  const CastlogLogo({
    super.key,
    this.size = 22,
    this.showText = true,
    this.inverted = false,
  });

  static const String assetPath = 'assets/logo/castlog_logo.png';

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = inverted ? AppColors.paper : AppColors.ink;
    final double badgeSize = size * 1.32;

    final Widget mark = Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(badgeSize * 0.28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        width: badgeSize,
        height: badgeSize,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );

    if (!showText) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mark,
        SizedBox(width: size * 0.42),
        RichText(
          text: TextSpan(
            style: GoogleFonts.manrope(
              fontSize: size,
              fontWeight: FontWeight.w800,
              color: primaryColor,
              letterSpacing: -1.2,
              height: 1.0,
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
      ],
    );
  }
}
