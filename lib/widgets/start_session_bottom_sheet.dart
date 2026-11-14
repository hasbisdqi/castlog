import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/controllers/tackle_box_controller.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:castlog/models/waterway_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StartSessionBottomSheet extends StatefulWidget {
  const StartSessionBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const StartSessionBottomSheet(),
    );
  }

  @override
  State<StartSessionBottomSheet> createState() => _StartSessionBottomSheetState();
}

class _StartSessionBottomSheetState extends State<StartSessionBottomSheet> {
  final sessionController = Get.find<SessionController>();
  final tackleController = Get.find<TackleBoxController>();

  WaterwayModel? _selectedWaterway;
  LoadoutModel? _selectedLoadout;

  @override
  void initState() {
    super.initState();
    final waterways = sessionController.waterways;
    if (waterways.isNotEmpty) {
      _selectedWaterway = waterways.first;
    }
    if (tackleController.loadouts.isNotEmpty) {
      _selectedLoadout = tackleController.loadouts.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final waterways = sessionController.waterways;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                      'START EXPEDITION',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'New Fishing Session',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
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
                  // 1. Waterway Section
                  Text(
                    'SELECT WATERWAY',
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      border: Border.all(color: AppColors.line),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<WaterwayModel>(
                        value: _selectedWaterway,
                        isExpanded: true,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                        items: waterways.map((w) {
                          return DropdownMenuItem(
                            value: w,
                            child: Text(
                              '${w.name} (${w.fishSpecies.length} species)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedWaterway = val);
                        },
                      ),
                    ),
                  ),

                  if (_selectedWaterway != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Available species: ${_selectedWaterway!.fishSpecies.take(5).map((f) => f.name).join(', ')}${_selectedWaterway!.fishSpecies.length > 5 ? '...' : ''}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 2. Loadout Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BRING LOADOUT / SETUP',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.muted,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          tackleController.startCreateLoadout();
                          Get.toNamed(AppRoutes.setupForm);
                        },
                        child: Text(
                          '＋ Create new setup',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Obx(() {
                    final list = tackleController.loadouts;
                    if (list.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Text(
                          'No loadouts yet. Tap "+ Create new setup" above.',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                        ),
                      );
                    }

                    return Column(
                      children: list.map((loadout) {
                        final isSelected = _selectedLoadout?.id == loadout.id;

                        return InkWell(
                          onTap: () => setState(() => _selectedLoadout = loadout),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.paper,
                              border: Border.all(
                                color: isSelected ? AppColors.ink : AppColors.line,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  size: 18,
                                  color: isSelected ? AppColors.ink : AppColors.muted,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loadout.name,
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${loadout.rods.length} rods · ${loadout.rods.map((r) => r.type.label).join(', ')}',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 11,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Start session button
                  InkWell(
                    onTap: () {
                      if (_selectedWaterway == null) {
                        Get.snackbar('Location needed', 'Please pick a waterway');
                        return;
                      }
                      if (_selectedLoadout == null) {
                        Get.snackbar('Setup needed', 'Please pick or create a loadout');
                        return;
                      }

                      sessionController.startNewSession(
                        waterway: _selectedWaterway!,
                        loadout: _selectedLoadout!,
                      );
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: AppColors.ink,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start fishing session',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
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
}
