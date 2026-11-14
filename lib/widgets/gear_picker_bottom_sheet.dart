import 'package:castlog/models/gear_model.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/gear_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GearPickerBottomSheet extends StatefulWidget {
  final String title;
  final List<GearModel> items;
  final String? currentSelectedName;
  final bool isHorizontalRod;
  final ValueChanged<GearModel> onSelect;

  const GearPickerBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.currentSelectedName,
    this.isHorizontalRod = false,
    required this.onSelect,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<GearModel> items,
    String? currentSelectedName,
    bool isHorizontalRod = false,
    required ValueChanged<GearModel> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GearPickerBottomSheet(
        title: title,
        items: items,
        currentSelectedName: currentSelectedName,
        isHorizontalRod: isHorizontalRod,
        onSelect: onSelect,
      ),
    );
  }

  @override
  State<GearPickerBottomSheet> createState() => _GearPickerBottomSheetState();
}

class _GearPickerBottomSheetState extends State<GearPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSubCategory = 'All';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _subCategories {
    final subs = <String>{'All'};
    for (final item in widget.items) {
      if (item.subCategory.trim().isNotEmpty) {
        subs.add(item.subCategory.trim());
      }
    }
    return subs.toList();
  }

  List<GearModel> get _filteredItems {
    return widget.items.where((gear) {
      final matchesSearch = _searchQuery.isEmpty ||
          gear.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          gear.subCategory.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSub = _selectedSubCategory == 'All' ||
          gear.subCategory.toLowerCase() == _selectedSubCategory.toLowerCase();

      return matchesSearch && matchesSub;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;
    final subCats = _subCategories;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: AppColors.ink, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle / bar
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
                      widget.title.toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Choose Equipment',
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

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              color: AppColors.paper,
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Search equipment by name or model...',
                  hintStyle: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.muted,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
          ),

          const SizedBox(height: 12),

          // Filter Chips (Pills)
          if (subCats.length > 2)
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: subCats.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = subCats[index];
                  final isSelected = cat == _selectedSubCategory;

                  return InkWell(
                    onTap: () => setState(() => _selectedSubCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.ink : AppColors.paper,
                        border: Border.all(
                          color: isSelected ? AppColors.ink : AppColors.line,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} ITEMS FOUND',
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),

          // Content List or Grid
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 40,
                          color: AppColors.muted,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No equipment matches query',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.isHorizontalRod
                    ? ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return GearCardTile(
                            gear: item,
                            isHorizontalRod: true,
                            isSelected: item.name == widget.currentSelectedName,
                            onTap: () {
                              widget.onSelect(item);
                              Get.back();
                            },
                          );
                        },
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.88,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return GearCardTile(
                            gear: item,
                            isHorizontalRod: false,
                            isSelected: item.name == widget.currentSelectedName,
                            onTap: () {
                              widget.onSelect(item);
                              Get.back();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
