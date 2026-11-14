import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:castlog/models/waterway_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LogCatchBottomSheet extends StatefulWidget {
  const LogCatchBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LogCatchBottomSheet(),
    );
  }

  @override
  State<LogCatchBottomSheet> createState() => _LogCatchBottomSheetState();
}

class _LogCatchBottomSheetState extends State<LogCatchBottomSheet> {
  final sessionController = Get.find<SessionController>();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  MapFishSpecies? _selectedSpecies;
  RodSlotData? _selectedRod;

  @override
  void initState() {
    super.initState();
    final speciesList = sessionController.getCurrentWaterwaySpecies();
    if (speciesList.isNotEmpty) {
      _selectedSpecies = speciesList.first;
    }

    final rods = sessionController.activeSession.value?.loadout.rods ?? [];
    if (rods.isNotEmpty) {
      _selectedRod = rods.first;
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lengthController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSession = sessionController.activeSession.value;
    final availableSpecies = sessionController.getCurrentWaterwaySpecies();
    final availableRods = activeSession?.loadout.rods ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 36,
              height: 4,
              color: AppColors.line,
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECORD CATCH · ${activeSession?.waterwayName ?? "SESSION"}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Add to journal.',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, size: 20, color: AppColors.ink),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SPECIES PICKER (Filtered to active location)
                  _buildSectionLabel('SPECIES (FOUND AT THIS WATERWAY)'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      border: Border.all(color: AppColors.line),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<MapFishSpecies>(
                        value: _selectedSpecies,
                        isExpanded: true,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                        items: availableSpecies.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                if (s.image.isNotEmpty) ...[
                                  Image.network(
                                    s.image,
                                    width: 32,
                                    height: 24,
                                    fit: BoxFit.contain,
                                    headers: const {'User-Agent': 'Mozilla/5.0'},
                                    errorBuilder: (_, _, _) => const Icon(Icons.phishing, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    s.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  s.rarityFound,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSpecies = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 2. ROD SELECTION (Hanya memilih joran dari setup yang dipakai)
                  _buildSectionLabel('TACKLE / ROD USED (FROM CURRENT LOADOUT)'),
                  if (availableRods.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: AppColors.paper,
                      child: Text(
                        'No rods configured in current loadout.',
                        style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                      ),
                    )
                  else
                    Column(
                      children: availableRods.map((rod) {
                        final isSelected = _selectedRod?.slotIndex == rod.slotIndex;

                        return InkWell(
                          onTap: () => setState(() => _selectedRod = rod),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.paper,
                              border: Border.all(
                                color: isSelected ? AppColors.ink : AppColors.line,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  color: isSelected ? AppColors.ink : AppColors.muted,
                                  child: Text(
                                    'ROD ${rod.slotIndex}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rod.rodName,
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      Text(
                                        '${rod.type.label} · Bait: ${rod.baitOrLure}',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 10,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, size: 16, color: AppColors.ink),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 18),

                  // 3. WEIGHT & LENGTH (2 Columns)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('WEIGHT (KG)'),
                            _buildTextField(_weightController, 'e.g. 3.4', TextInputType.number),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('LENGTH (CM)'),
                            _buildTextField(_lengthController, 'e.g. 52', TextInputType.number),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 4. NOTES
                  _buildSectionLabel('NOTES (OPTIONAL)'),
                  Container(
                    color: AppColors.paper,
                    child: TextField(
                      controller: _notesController,
                      maxLines: 2,
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.ink),
                      decoration: InputDecoration(
                        hintText: 'e.g. Morning bite near the water lily pads...',
                        hintStyle: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.line),
                          borderRadius: BorderRadius.zero,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.ink),
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SUBMIT BUTTON
                  InkWell(
                    onTap: _submitCatch,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: AppColors.ink,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save to journal',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_outward_rounded, size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitCatch() {
    if (_selectedSpecies == null) {
      Get.snackbar('Species required', 'Please select a fish species');
      return;
    }
    if (_selectedRod == null) {
      Get.snackbar('Rod required', 'Please select a rod');
      return;
    }

    final weight = double.tryParse(_weightController.text.trim()) ?? 1.5;
    final length = double.tryParse(_lengthController.text.trim()) ?? 40.0;

    sessionController.addCatch(
      species: _selectedSpecies!.name,
      weightKg: weight,
      lengthCm: length,
      rodSlot: _selectedRod!,
      image: _selectedSpecies!.image.isNotEmpty ? _selectedSpecies!.image : null,
      notes: _notesController.text.trim(),
    );

    Get.back();
    Get.snackbar(
      'Catch Recorded!',
      '${_selectedSpecies!.name} (${weight.toStringAsFixed(1)} kg) added to journal',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.paper,
      colorText: AppColors.ink,
      margin: const EdgeInsets.all(16),
      borderRadius: 0,
      borderColor: AppColors.ink,
      borderWidth: 1,
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.muted,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    TextInputType keyboardType,
  ) {
    return Container(
      color: AppColors.paper,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.line),
            borderRadius: BorderRadius.zero,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.ink),
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}
