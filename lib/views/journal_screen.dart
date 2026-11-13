import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/widgets/catch_card.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allCatches = [
    {
      'title': 'Common Carp',
      'sub': 'Emerald Lake · Today',
      'weight': '8.2 kg',
      'species': 'carp',
      'image': 'https://wiki.fishingplanet.com/images/e/e6/Common_Carp.png',
    },
    {
      'title': 'Grass Carp',
      'sub': 'Emerald Lake · Yesterday',
      'weight': '6.7 kg',
      'species': 'carp',
      'image': 'https://wiki.fishingplanet.com/images/a/ae/Grass_Carp.png',
    },
    {
      'title': 'Mirror Carp',
      'sub': 'Lonely Oak · 2 days ago',
      'weight': '5.1 kg',
      'species': 'carp',
      'image': 'https://wiki.fishingplanet.com/images/0/0d/Mirror_Carp.png',
    },
    {
      'title': 'Largemouth Bass',
      'sub': 'Lone Star Lake · 4 days ago',
      'weight': '3.4 kg',
      'species': 'bass',
      'image': 'https://wiki.fishingplanet.com/images/5/52/Largemouth_Bass.png',
    },
    {
      'title': 'Common Carp',
      'sub': 'Emerald Lake · 5 days ago',
      'weight': '7.3 kg',
      'species': 'carp',
      'image': 'https://wiki.fishingplanet.com/images/e/e6/Common_Carp.png',
    },
    {
      'title': 'Bluegill',
      'sub': 'Lone Star Lake · 1 week ago',
      'weight': '0.8 kg',
      'species': 'panfish',
      'image': 'https://wiki.fishingplanet.com/images/6/6b/Bluegill.png',
    },
  ];

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

  List<Map<String, String>> get _filteredCatches {
    return _allCatches.where((item) {
      final matchesQuery = _searchQuery.isEmpty ||
          (item['title']?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false) ||
          (item['sub']?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);

      if (!matchesQuery) return false;

      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'recent') return true;
      return (item['species'] ?? '') == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedCatches = _filteredCatches;

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
                    _buildToolbar(displayedCatches.length),
                    const SizedBox(height: 16),
                    _buildCatchGrid(displayedCatches),
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
        Container(
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
            height: 1.7,
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
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.ink),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search species or location...',
          hintStyle: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.muted,
          ),
          icon: const Icon(Icons.search, size: 18, color: AppColors.muted),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ink : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.ink : AppColors.line,
                  ),
                ),
                child: Text(
                  filter['label']!,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.muted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToolbar(int totalCount) {
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
                text: '· $totalCount',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
          ),
          child: Text(
            'Newest first ↓',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCatchGrid(List<Map<String, String>> catches) {
    if (catches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No catches found.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.muted,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: catches.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return CatchCard(item: catches[index]);
      },
    );
  }
}
