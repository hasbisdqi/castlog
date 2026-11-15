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
  String? _customImageUrl;

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
    final rawSpecies = sessionController.getCurrentWaterwaySpecies();
    final seen = <String>{};
    final availableSpecies = rawSpecies.where((s) => s.name.isNotEmpty && seen.add(s.name)).toList();
    final availableRods = activeSession?.loadout.rods ?? [];

    if (availableSpecies.isNotEmpty) {
      if (_selectedSpecies == null || !availableSpecies.contains(_selectedSpecies)) {
        _selectedSpecies = availableSpecies.first;
      } else {
        _selectedSpecies = availableSpecies.firstWhere((s) => s == _selectedSpecies);
      }
    } else {
      _selectedSpecies = null;
    }

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
                  // Catch Screenshot Upload Box
                  _buildImageUploadBox(),

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

    final chosenImage = (_customImageUrl != null && _customImageUrl!.isNotEmpty)
        ? _customImageUrl
        : (_selectedSpecies!.image.isNotEmpty ? _selectedSpecies!.image : null);

    sessionController.addCatch(
      species: _selectedSpecies!.name,
      weightKg: weight,
      lengthCm: length,
      rodSlot: _selectedRod!,
      image: chosenImage,
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

  Widget _buildImageUploadBox() {
    const ColorFilter greyscaleFilter = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);

    if (_customImageUrl != null && _customImageUrl!.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.line),
          color: AppColors.paper,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ColorFiltered(
                  colorFilter: greyscaleFilter,
                  child: Image.network(
                    _customImageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: AppColors.soft,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: AppColors.muted),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _customImageUrl = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Screenshot attached',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showImagePickerModal,
                    child: Text(
                      'Change photo ↗',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _showImagePickerModal,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(
            color: const Color(0xFFC8C8C4),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '＋',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add catch screenshot',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose photo or preset catch snapshot',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerModal() {
    final urlController = TextEditingController();

    final presets = [
      {
        'title': 'Common Carp Catch',
        'url': 'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=600&q=80',
      },
      {
        'title': 'Grass Carp Snapshot',
        'url': 'https://images.unsplash.com/photo-1510130387422-82bed34b37e9?w=600&q=80',
      },
      {
        'title': 'Mirror Carp Trophy',
        'url': 'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=600&q=80',
      },
      {
        'title': 'Largemouth Bass Landing',
        'url': 'https://images.unsplash.com/photo-1515003197210-e0cd7184f8b5?w=600&q=80',
      },
      {
        'title': 'Pike Predator Moment',
        'url': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600&q=80',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attach Catch Photo',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Option 1: URL input
              Text(
                'ENTER IMAGE URL',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: AppColors.paper,
                      child: TextField(
                        controller: urlController,
                        style: GoogleFonts.dmSans(fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: 'https://...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final url = urlController.text.trim();
                      if (url.isNotEmpty) {
                        setState(() {
                          _customImageUrl = url;
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Attach'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Option 2: Presets
              Text(
                'PRESET CATCH PHOTOS',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: presets.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (ctx, i) {
                    final p = presets[i];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _customImageUrl = p['url'];
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: 110,
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                p['url']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                p['title']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_selectedSpecies != null && _selectedSpecies!.image.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _customImageUrl = _selectedSpecies!.image;
                      });
                      Navigator.pop(ctx);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.ink,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Use ${_selectedSpecies!.name} Illustration',
                      style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
