import 'package:castlog/controllers/tackle_box_controller.dart';
import 'package:castlog/models/gear_model.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/gear_picker_bottom_sheet.dart';
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
                      'Choose your rods, then tap on gear cards to select equipment from your tackle collection.',
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
                      'Tap any gear card to open the bottom sheet with live search, category filter, and equipment catalog.',
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: AppColors.ink,
                      child: Text(
                        'ROD $index',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      slot.rodLength,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
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
                const SizedBox(height: 16),

                // 1. Big Horizontal Rod Selector Card (Sesuai Referensi Gambar)
                _buildFieldLabel('ROD'),
                _buildHorizontalRodCard(
                  slot: slot,
                  onTap: () {
                    GearPickerBottomSheet.show(
                      context: context,
                      title: '${slot.type.label} Rods',
                      items: availableRods,
                      currentSelectedName: slot.rodName,
                      isHorizontalRod: true,
                      onSelect: (gear) => controller.onSlotRodChanged(slot, gear),
                    );
                  },
                ),
                const SizedBox(height: 14),

                // 2. Square Cards Grid (Reel, Line, Leader, Hook, Bait/Lure)
                _buildFieldLabel('EQUIPMENT SLOTS (TAP TO SELECT)'),
                const SizedBox(height: 2),

                // Row 1: Reel & Line
                Row(
                  children: [
                    Expanded(
                      child: _buildSquareSlotItem(
                        label: 'REEL',
                        title: slot.reel ?? 'Select Reel',
                        image: _findImage(availableReels, slot.reel),
                        isConfigured: slot.reel != null,
                        onTap: () {
                          GearPickerBottomSheet.show(
                            context: context,
                            title: '${slot.type.label} Reels',
                            items: availableReels,
                            currentSelectedName: slot.reel,
                            onSelect: (gear) =>
                                controller.onSlotReelChanged(slot, gear),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSquareSlotItem(
                        label: 'LINE',
                        title: slot.line ?? 'Select Line',
                        image: _findImage(availableLines, slot.line),
                        isConfigured: slot.line != null,
                        onTap: () {
                          GearPickerBottomSheet.show(
                            context: context,
                            title: 'Fishing Lines',
                            items: availableLines,
                            currentSelectedName: slot.line,
                            onSelect: (gear) =>
                                controller.onSlotLineChanged(slot, gear),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Row 2: Leader & Weight/Float (jika ada)
                Row(
                  children: [
                    Expanded(
                      child: _buildSquareSlotItem(
                        label: 'LEADER',
                        title: slot.leader ?? 'No leader',
                        image: _findImage(availableLeaders, slot.leader),
                        isConfigured: slot.leader != null,
                        onTap: () {
                          GearPickerBottomSheet.show(
                            context: context,
                            title: 'Leaders',
                            items: availableLeaders,
                            currentSelectedName: slot.leader,
                            onSelect: (gear) =>
                                controller.onSlotLeaderChanged(slot, gear),
                          );
                        },
                      ),
                    ),
                    if (slot.type != SetupType.spinning &&
                        slot.type != SetupType.casting) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSquareSlotItem(
                          label: slot.type == SetupType.float
                              ? 'FLOAT'
                              : (slot.type == SetupType.spod
                                  ? 'SPOD ROCKET'
                                  : 'SINKER / FEEDER'),
                          title: slot.weightOrFloat ?? 'Select Sinker',
                          image: _findImage(
                              availableWeights, slot.weightOrFloat),
                          isConfigured: slot.weightOrFloat != null,
                          onTap: () {
                            GearPickerBottomSheet.show(
                              context: context,
                              title: slot.type == SetupType.float
                                  ? 'Floats & Bobbers'
                                  : 'Sinkers & Feeders',
                              items: availableWeights,
                              currentSelectedName: slot.weightOrFloat,
                              onSelect: (gear) => controller
                                  .onSlotWeightOrFloatChanged(slot, gear),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),

                // Row 3: Hook & Bait / Lure
                Row(
                  children: [
                    if (slot.type == SetupType.float ||
                        slot.type == SetupType.feeder ||
                        slot.type == SetupType.carp) ...[
                      Expanded(
                        child: _buildSquareSlotItem(
                          label: 'HOOK',
                          title: slot.hook ?? 'Select Hook',
                          image: _findImage(availableHooks, slot.hook),
                          isConfigured: slot.hook != null,
                          onTap: () {
                            GearPickerBottomSheet.show(
                              context: context,
                              title: 'Hooks',
                              items: availableHooks,
                              currentSelectedName: slot.hook,
                              onSelect: (gear) =>
                                  controller.onSlotHookChanged(slot, gear),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: _buildSquareSlotItem(
                        label: slot.type == SetupType.spinning ||
                                slot.type == SetupType.casting
                            ? 'LURE'
                            : (slot.type == SetupType.spod
                                ? 'GROUNDBAIT'
                                : 'BAIT'),
                        title: slot.baitOrLure.isNotEmpty
                            ? slot.baitOrLure
                            : 'Select Bait/Lure',
                        image: _findImage(availableBaits, slot.baitOrLure),
                        isConfigured: slot.baitOrLure.isNotEmpty,
                        onTap: () {
                          GearPickerBottomSheet.show(
                            context: context,
                            title: slot.type == SetupType.spinning ||
                                    slot.type == SetupType.casting
                                ? 'Lures & Softbaits'
                                : 'Baits & Groundbaits',
                            items: availableBaits,
                            currentSelectedName: slot.baitOrLure,
                            onSelect: (gear) =>
                                controller.onSlotBaitOrLureChanged(slot, gear),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _findImage(List<GearModel> list, String? name) {
    if (name == null || name.isEmpty) return null;
    final match = list.firstWhereOrNull((g) => g.name == name);
    return match?.image;
  }

  Widget _buildHorizontalRodCard({
    required EditableRodSlot slot,
    required VoidCallback onTap,
  }) {
    final hasImage = slot.rodImage != null && slot.rodImage!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(color: AppColors.ink, width: 1.2),
        ),
        child: Stack(
          children: [
            // Stat / Panjang di kanan atas
            Positioned(
              top: 10,
              right: 12,
              child: Text(
                slot.rodLength,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),

            // Gambar Joran Horizontal di tengah
            if (hasImage)
              Positioned.fill(
                top: 6,
                bottom: 26,
                left: 10,
                right: 10,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.black, Colors.transparent],
                      stops: [0.0, 0.88, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    slot.rodImage!,
                    fit: BoxFit.contain,
                    headers: const {
                      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                    },
                    errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                  ),
                ),
              ),

            // Nama & Kategori di kiri bawah
            Positioned(
              left: 12,
              bottom: 10,
              right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slot.type.label.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    slot.rodName.isNotEmpty ? slot.rodName : 'Tap to select rod',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),

            // Tombol edit kecil di kanan bawah
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(
                  'CHANGE',
                  style: GoogleFonts.dmSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareSlotItem({
    required String label,
    required String title,
    required String? image,
    required bool isConfigured,
    required VoidCallback onTap,
  }) {
    final hasImg = image != null && image.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(
            color: isConfigured ? AppColors.line : AppColors.line,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.muted,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 9,
                  color: AppColors.muted,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Center(
                child: hasImg
                    ? Image.network(
                        image,
                        fit: BoxFit.contain,
                        headers: const {
                          'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                        },
                        errorBuilder: (ctx, err, stack) => Icon(
                          Icons.phishing,
                          size: 24,
                          color: AppColors.muted.withValues(alpha: 0.4),
                        ),
                      )
                    : Icon(
                        Icons.add_circle_outline,
                        size: 22,
                        color: AppColors.muted.withValues(alpha: 0.5),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isConfigured ? AppColors.ink : AppColors.muted,
              ),
            ),
          ],
        ),
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
