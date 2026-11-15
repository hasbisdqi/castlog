import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final SessionController _sessionController = Get.find<SessionController>();

  String _selectedTab = 'Overall';

  final List<String> _tabs = ['Overall', 'Carp', 'Bass', 'This month'];

  final List<Map<String, dynamic>> _allEntries = [
    {
      'rank': '01',
      'name': 'Arga Pratama',
      'species': 'Common Carp',
      'category': 'Carp',
      'location': 'Emerald Lake',
      'weight': '18.42 kg',
      'date': 'Nov 11, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=11',
      'photoUrl':
          'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85',
      'rod': 'Carp Hunter',
      'bait': 'Sweet Corn',
    },
    {
      'rank': '02',
      'name': 'Rizky Mahendra',
      'species': 'Grass Carp',
      'category': 'Carp',
      'location': 'Emerald Lake',
      'weight': '16.80 kg',
      'date': 'Nov 10, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=12',
      'photoUrl':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1000&q=85',
      'rod': 'River King 240',
      'bait': 'Bread Pellet',
    },
    {
      'rank': '03',
      'name': 'Dimas Saputra',
      'species': 'Common Carp',
      'category': 'Carp',
      'location': 'Lonely Oak',
      'weight': '15.25 kg',
      'date': 'Nov 09, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=13',
      'photoUrl':
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=1000&q=85',
      'rod': 'Carp Hunter',
      'bait': 'Sweet Corn',
    },
    {
      'rank': '04',
      'name': 'Fajar Nugroho',
      'species': 'Northern Pike',
      'category': 'Other',
      'location': 'White Moose',
      'weight': '12.90 kg',
      'date': 'Nov 08, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=14',
      'photoUrl':
          'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85',
      'rod': 'Predator Cast',
      'bait': 'Live Minnow',
    },
    {
      'rank': '05',
      'name': 'Bagas Wicaksono',
      'species': 'Common Carp',
      'category': 'Carp',
      'location': 'Emerald Lake',
      'weight': '11.75 kg',
      'date': 'Nov 07, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=15',
      'photoUrl':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1000&q=85',
      'rod': 'Carp Hunter',
      'bait': 'Sweet Corn',
    },
    {
      'rank': '06',
      'name': 'Raka Firmansyah',
      'species': 'Mirror Carp',
      'category': 'Carp',
      'location': 'Lonely Oak',
      'weight': '10.90 kg',
      'date': 'Nov 06, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=16',
      'photoUrl':
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=1000&q=85',
      'rod': 'Feeder Pro',
      'bait': 'Boilie Plum',
    },
    {
      'rank': '07',
      'name': 'Yoga Prakoso',
      'species': 'Common Carp',
      'category': 'Carp',
      'location': 'Emerald Lake',
      'weight': '9.85 kg',
      'date': 'Nov 05, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=17',
      'photoUrl':
          'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85',
      'rod': 'Match Master',
      'bait': 'Sweet Corn',
    },
    {
      'rank': '08',
      'name': 'Ilham Ramadhan',
      'species': 'Largemouth Bass',
      'category': 'Bass',
      'location': 'Lone Star',
      'weight': '8.70 kg',
      'date': 'Nov 04, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=18',
      'photoUrl':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1000&q=85',
      'rod': 'Bass Strike 66',
      'bait': 'Crankbait 5g',
    },
    {
      'rank': '09',
      'name': 'Aditya Putra',
      'species': 'Grass Carp',
      'category': 'Carp',
      'location': 'Emerald Lake',
      'weight': '8.25 kg',
      'date': 'Nov 03, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=19',
      'photoUrl':
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=1000&q=85',
      'rod': 'Telescopic 360',
      'bait': 'Weed Ball',
    },
    {
      'rank': '10',
      'name': 'Fikri Hidayat',
      'species': 'Common Carp',
      'category': 'Carp',
      'location': 'Lonely Oak',
      'weight': '7.95 kg',
      'date': 'Nov 02, 2026',
      'avatarUrl': 'https://i.pravatar.cc/100?img=20',
      'photoUrl':
          'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85',
      'rod': 'Carp Hunter',
      'bait': 'Sweet Corn',
    },
  ];

  List<Map<String, dynamic>> get _filteredEntries {
    if (_selectedTab == 'Carp') {
      return _allEntries.where((e) => e['category'] == 'Carp').toList();
    } else if (_selectedTab == 'Bass') {
      return _allEntries.where((e) => e['category'] == 'Bass').toList();
    }
    return _allEntries;
  }

  @override
  Widget build(BuildContext context) {
    const ColorFilter greyscaleFilter = ColorFilter.matrix(<double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ]);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 16, color: AppColors.muted),
                    const SizedBox(width: 6),
                    Text(
                      'Home',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Eyebrow
              Text(
                'CASTLOG COMMUNITY',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'Local rankings.',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'The biggest catches recorded by anglers in your region.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 20),

              // Region Card
              Obx(() {
                final currentRegion = _sessionController.userRegion.value;
                final regionList = [
                  'Yogyakarta',
                  'Jakarta',
                  'Jawa Barat',
                  'Jawa Timur',
                  'Bali',
                ];
                // Ensure current region is selectable in dropdown or displayed
                String dropdownValue = regionList.first;
                for (final r in regionList) {
                  if (currentRegion.contains(r)) {
                    dropdownValue = r;
                    break;
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECTED REGION',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          isDense: true,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: AppColors.ink),
                          style: GoogleFonts.manrope(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                          items: regionList.map((r) {
                            return DropdownMenuItem<String>(
                              value: r,
                              child: Text(r),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              _sessionController.setUserRegion(val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rankings are grouped by the angler\'s selected region.',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Get.toNamed(AppRoutes.region),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            side: const BorderSide(color: AppColors.line),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text(
                            'Change region',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Rank Hero Block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                color: AppColors.dark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MONTHLY LEADERBOARD · NOVEMBER 2026',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Big fish.\nLocal waters.',
                      style: GoogleFonts.manrope(
                        fontSize: 29,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.2,
                        height: 1.15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Top 10 heaviest catches submitted by anglers in this region.',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: const Color(0xFFC4C4C0),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _tabs.map((tab) {
                    final isSelected = _selectedTab == tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = tab;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.ink : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.ink : AppColors.line,
                            ),
                          ),
                          child: Text(
                            tab,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 22),

              // Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Top anglers ',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                      children: [
                        TextSpan(
                          text: '· ${_filteredEntries.length} entries',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'BY WEIGHT',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Ranked List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredEntries.length,
                separatorBuilder: (ctx, i) =>
                    const Divider(height: 1, thickness: 1, color: AppColors.line),
                itemBuilder: (ctx, i) {
                  final entry = _filteredEntries[i];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.rankDetail,
                        arguments: {
                          'rank': entry['rank'],
                          'anglerName': entry['name'],
                          'species': entry['species'],
                          'location': entry['location'],
                          'region': _sessionController.userRegion.value,
                          'weight': entry['weight'],
                          'date': entry['date'],
                          'avatarUrl': entry['avatarUrl'],
                          'photoUrl': entry['photoUrl'],
                          'rod': entry['rod'],
                          'bait': entry['bait'],
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text(
                              entry['rank'],
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF999999),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ColorFiltered(
                            colorFilter: greyscaleFilter,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.soft,
                              backgroundImage:
                                  NetworkImage(entry['avatarUrl']),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry['name'],
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${entry['species']} · ${entry['location']}',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                entry['weight'],
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                entry['date'],
                                style: GoogleFonts.dmSans(
                                  fontSize: 9,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Your current position card
              Obx(() => Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFFE9E9E6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR CURRENT POSITION',
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fishing Journal · ${_sessionController.userRegion.value}',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: const Color(0xFF777777),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '#12',
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Notice
              Text(
                'Illustrative prototype data. A real leaderboard would require verified catch submissions and a shared online data source.',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
