import 'package:castlog/controllers/tackle_box_controller.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SetupFormScreen extends StatelessWidget {
  const SetupFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TackleBoxController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky topbar with back button
            Container(
              color: AppColors.bg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, size: 18, color: AppColors.ink),
                        const SizedBox(width: 6),
                        Text(
                          'Tackle box',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR EQUIPMENT',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.editingLoadoutId == null
                          ? 'Build your\nloadout.'
                          : 'Edit your\nloadout.',
                      style: GoogleFonts.manrope(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        letterSpacing: -1.8,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Choose your rods, then select the gear assigned to each one. Bring up to four rods to a fishing session.',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        height: 1.7,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Loadout name field
                    Text(
                      'LOADOUT NAME',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: AppColors.paper,
                      child: TextField(
                        controller: controller.nameController,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g. Emerald Lake setup',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
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
                    const SizedBox(height: 32),

                    // Rods Section Header
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your rods',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            '${controller.formRodSlots.length} / 4 RODS',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rod Slots List
                    Obx(
                      () => Column(
                        children: controller.formRodSlots
                            .asMap()
                            .entries
                            .map((entry) => _buildSlotCard(
                                  context,
                                  controller,
                                  entry.value,
                                  entry.key + 1,
                                ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Add Rod Button
                    Obx(() {
                      final isMax = controller.formRodSlots.length >= 4;
                      return InkWell(
                        onTap: isMax ? null : () => controller.addRodSlot(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: isMax
                                  ? AppColors.line.withValues(alpha: 0.5)
                                  : AppColors.line,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isMax
                                ? 'Maximum 4 rods reached'
                                : '＋ Add another rod',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isMax ? AppColors.muted : AppColors.ink,
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Save Loadout Button
                    InkWell(
                      onTap: () {
                        if (controller.saveLoadout()) {
                          Get.back();
                        }
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
                              'Save loadout',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Gear options are populated dynamically from your Hive dataset based on each selected rod type.',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotCard(
    BuildContext context,
    TackleBoxController controller,
    EditableRodSlot slot,
    int index,
  ) {
    final availableRods = controller.getRods(slot.type);
    final availableReels = controller.getReels(slot.type);
    final availableLines = controller.getLines();
    final availableLeaders = controller.getLeaders();
    final availableWeights = controller.getWeightsOrFloats(slot.type);
    final availableHooks = controller.getHooks(slot.type);
    final availableBaits = controller.getBaitsOrLures(slot.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slot Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: AppColors.bg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rod $index',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                if (controller.formRodSlots.length > 1)
                  GestureDetector(
                    onTap: () => controller.removeRodSlot(slot.id),
                    child: Text(
                      'Remove',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Setup Type selector
                _buildFieldLabel('SETUP TYPE'),
                _buildDropdown<SetupType>(
                  value: slot.type,
                  items: SetupType.values.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(t.label),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.onSlotTypeChanged(slot, val);
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Rod Dropdown
                _buildFieldLabel('ROD'),
                _buildDropdown<String>(
                  value: availableRods.any((r) => r.name == slot.rodName)
                      ? slot.rodName
                      : (availableRods.isNotEmpty ? availableRods.first.name : null),
                  hint: 'Choose a rod',
                  items: availableRods.map((r) {
                    return DropdownMenuItem(
                      value: r.name,
                      child: Text(
                        r.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.onSlotRodChanged(slot, val);
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Reel & Line Grid
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('REEL'),
                          _buildDropdown<String>(
                            value: availableReels.any((r) => r.name == slot.reel)
                                ? slot.reel
                                : null,
                            hint: 'Choose reel',
                            items: availableReels.map((r) {
                              return DropdownMenuItem(
                                value: r.name,
                                child: Text(
                                  r.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => slot.reel = val,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('LINE'),
                          _buildDropdown<String>(
                            value: availableLines.any((l) => l.name == slot.line)
                                ? slot.line
                                : null,
                            hint: 'Choose line',
                            items: availableLines.map((l) {
                              return DropdownMenuItem(
                                value: l.name,
                                child: Text(
                                  l.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => slot.line = val,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Leader & Dynamic Weight/Float
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('LEADER (OPTIONAL)'),
                          _buildDropdown<String>(
                            value: availableLeaders.any((l) => l.name == slot.leader)
                                ? slot.leader
                                : null,
                            hint: 'No leader',
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('No leader'),
                              ),
                              ...availableLeaders.map((l) {
                                return DropdownMenuItem(
                                  value: l.name,
                                  child: Text(
                                    l.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: (val) => slot.leader = val,
                          ),
                        ],
                      ),
                    ),
                    if (slot.type != SetupType.spinning &&
                        slot.type != SetupType.casting) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel(
                              slot.type == SetupType.float
                                  ? 'FLOAT'
                                  : (slot.type == SetupType.spod
                                      ? 'SPOD ROCKET'
                                      : 'SINKER / FEEDER'),
                            ),
                            _buildDropdown<String>(
                              value: availableWeights
                                      .any((w) => w.name == slot.weightOrFloat)
                                  ? slot.weightOrFloat
                                  : null,
                              hint: 'Choose item',
                              items: availableWeights.map((w) {
                                return DropdownMenuItem(
                                  value: w.name,
                                  child: Text(
                                    w.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) => slot.weightOrFloat = val,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),

                // Hook (jika bukan spinning/casting/spod)
                if (slot.type == SetupType.float ||
                    slot.type == SetupType.feeder ||
                    slot.type == SetupType.carp) ...[
                  _buildFieldLabel('HOOK'),
                  _buildDropdown<String>(
                    value: availableHooks.any((h) => h.name == slot.hook)
                        ? slot.hook
                        : null,
                    hint: 'Choose hook',
                    items: availableHooks.map((h) {
                      return DropdownMenuItem(
                        value: h.name,
                        child: Text(
                          h.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => slot.hook = val,
                  ),
                  const SizedBox(height: 14),
                ],

                // Bait / Lure / Groundbait
                _buildFieldLabel(
                  slot.type == SetupType.spinning ||
                          slot.type == SetupType.casting
                      ? 'LURE'
                      : (slot.type == SetupType.spod
                          ? 'GROUNDBAIT'
                          : 'BAIT'),
                ),
                _buildDropdown<String>(
                  value: availableBaits.any((b) => b.name == slot.baitOrLure)
                      ? slot.baitOrLure
                      : (availableBaits.isNotEmpty
                          ? availableBaits.first.name
                          : null),
                  hint: 'Choose bait or lure',
                  items: availableBaits.map((b) {
                    return DropdownMenuItem(
                      value: b.name,
                      child: Text(
                        b.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) slot.baitOrLure = val;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.muted,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    String? hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(
                  hint,
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                )
              : null,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
