import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CatchDetailScreen extends StatelessWidget {
  final CatchModel? catchData;

  const CatchDetailScreen({super.key, this.catchData});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final m = months[dt.month - 1];
    final d = dt.day.toString().padLeft(2, '0');
    final y = dt.year;
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$m $d, $y · $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    final CatchModel? catchModel = catchData ?? (Get.arguments is CatchModel ? Get.arguments as CatchModel : null);

    if (catchModel == null) {
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
                  'Catch entry not found',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: AppColors.ink,
                    child: Text(
                      'Back to journal',
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

    final entryId = catchModel.id.replaceAll('catch_', '').padLeft(5, '0');

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
                'CATCH ENTRY · #$entryId',
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
                '${catchModel.species}.',
                style: GoogleFonts.manrope(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  height: 1.13,
                  letterSpacing: -2.0,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 20),

              // Hero Image (Grayscale filter editorial style)
              _buildHeroImage(catchModel),
              const SizedBox(height: 24),

              // Recorded Weight
              Text(
                'RECORDED WEIGHT',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                catchModel.weightFormatted,
                style: GoogleFonts.manrope(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -2.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 20),

              // Detail Meta Grid (2 Columns, Borders Top and Bottom)
              _buildMetaGrid(catchModel),
              const SizedBox(height: 24),

              // Notes Section
              _buildNotesSection(catchModel),
              const SizedBox(height: 36),

              // Inline Action Buttons
              _buildActionButtons(context, sessionController, catchModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(CatchModel catchModel) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: catchModel.image != null && catchModel.image!.isNotEmpty
          ? ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Image.network(
                catchModel.image!,
                headers: const {'User-Agent': 'Mozilla/5.0'},
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _buildPlaceholderImage(),
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.soft,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phishing, size: 48, color: AppColors.muted),
            const SizedBox(height: 8),
            Text(
              'No photo available',
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

  Widget _buildMetaGrid(CatchModel catchModel) {
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
                  'LOCATION',
                  catchModel.waterway,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetaItem(
                  'CAUGHT',
                  _formatDate(catchModel.timestamp),
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
                  'ROD SETUP',
                  catchModel.rodName,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetaItem(
                  'BAIT / LURE',
                  catchModel.baitOrLure ?? 'Not specified',
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
                  'LENGTH',
                  catchModel.lengthFormatted,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetaItem(
                  'SESSION',
                  catchModel.sessionId ?? 'Recorded catch',
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

  Widget _buildNotesSection(CatchModel catchModel) {
    final notes = catchModel.notes;
    final hasNotes = notes != null && notes.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hasNotes ? notes : 'No additional field notes recorded for this catch.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            height: 1.7,
            color: hasNotes ? AppColors.ink : AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    SessionController controller,
    CatchModel catchModel,
  ) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _confirmDelete(context, controller, catchModel),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.line),
              ),
              child: Center(
                child: Text(
                  'Delete entry',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () {
              Get.snackbar(
                'Share',
                '${catchModel.species} (${catchModel.weightFormatted}) ready to share!',
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
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.line),
              ),
              child: Center(
                child: Text(
                  'Share catch ↗',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(
    BuildContext context,
    SessionController controller,
    CatchModel catchModel,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.paper,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'Delete entry?',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Are you sure you want to remove this ${catchModel.species} from your journal? This action cannot be undone.',
          style: GoogleFonts.dmSans(fontSize: 13, height: 1.5, color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
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
              controller.deleteCatch(catchModel.id);
              Get.back();
              Get.snackbar(
                'Deleted',
                '${catchModel.species} removed from journal',
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.red.shade700,
              child: Text(
                'Delete',
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
    );
  }
}
