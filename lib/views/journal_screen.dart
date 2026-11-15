import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/catch_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum JournalSort {
  newest('Newest first'),
  heaviest('Heaviest first'),
  oldest('Oldest first');

  final String label;
  const JournalSort(this.label);
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  JournalSort _currentSort = JournalSort.newest;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _filters = [
    {'id': 'all', 'label': 'All catches'},
    {'id': 'carp', 'label': 'Carp'},
    {'id': 'bass', 'label': 'Bass'},
    {'id': 'recent', 'label': 'Recent'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSort() {
    setState(() {
      if (_currentSort == JournalSort.newest) {
        _currentSort = JournalSort.heaviest;
      } else if (_currentSort == JournalSort.heaviest) {
        _currentSort = JournalSort.oldest;
      } else {
        _currentSort = JournalSort.newest;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sticky topbar
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
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildFilterPills(),
                    const SizedBox(height: 24),
                    Obx(() {
                      final items = _filterAndSortCatches(sessionController);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildToolbar(items.length),
                          const SizedBox(height: 16),
                          _buildCatchGrid(items),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CatchModel> _filterAndSortCatches(SessionController controller) {
    final now = DateTime.now();

    final filtered = controller.catches.where((c) {
      final query = _searchQuery.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          c.species.toLowerCase().contains(query) ||
          c.waterway.toLowerCase().contains(query) ||
          c.rodName.toLowerCase().contains(query) ||
          (c.baitOrLure != null && c.baitOrLure!.toLowerCase().contains(query)) ||
          (c.notes != null && c.notes!.toLowerCase().contains(query));

      if (!matchesQuery) return false;

      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'carp') {
        return c.species.toLowerCase().contains('carp');
      }
      if (_selectedFilter == 'bass') {
        return c.species.toLowerCase().contains('bass');
      }
      if (_selectedFilter == 'recent') {
        return now.difference(c.timestamp).inDays <= 7;
      }
      return true;
    }).toList();

    // Sorting
    switch (_currentSort) {
      case JournalSort.newest:
        filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case JournalSort.heaviest:
        filtered.sort((a, b) => b.weightKg.compareTo(a.weightKg));
        break;
      case JournalSort.oldest:
        filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
    }

    return filtered;
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE ARCHIVE',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your catches.',
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
          'A collection of moments from every session.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            height: 1.6,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search species or location...',
          hintStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted),
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = filter['id']!;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ink : AppColors.paper,
                  border: Border.all(
                    color: isSelected ? AppColors.ink : AppColors.line,
                  ),
                ),
                child: Text(
                  filter['label']!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToolbar(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppColors.ink,
            ),
            children: [
              const TextSpan(text: 'All entries '),
              TextSpan(
                text: '· $count',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _toggleSort,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.soft,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _currentSort.label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCatchGrid(List<CatchModel> catches) {
    if (catches.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        width: double.infinity,
        color: AppColors.paper,
        child: Column(
          children: [
            const Icon(Icons.phishing, size: 40, color: AppColors.muted),
            const SizedBox(height: 10),
            Text(
              'No catches found',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search or filter keywords',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: catches.length,
      itemBuilder: (context, index) {
        return CatchCard(catchModel: catches[index]);
      },
    );
  }
}
