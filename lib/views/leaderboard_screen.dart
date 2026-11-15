import 'package:castlog/controllers/auth_controller.dart';
import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/services/location_service.dart';
import 'package:castlog/services/supabase_leaderboard_service.dart';
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
  final AuthController _authController = Get.find<AuthController>();

  String _selectedTab = 'Overall';
  final List<String> _tabs = ['Overall', 'Carp', 'Bass', 'This month'];

  bool _isLoading = false;
  bool _isDetectingGps = false;
  String? _detectedCoords;

  List<Map<String, dynamic>> _supabaseEntries = [];

  // Fallback seed entries
  final List<Map<String, dynamic>> _fallbackEntries = [
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
  ];

  @override
  void initState() {
    super.initState();
    _loadSupabaseLeaderboard();
  }

  Future<void> _loadSupabaseLeaderboard() async {
    setState(() => _isLoading = true);
    try {
      final entries = await SupabaseLeaderboardService().fetchLeaderboard(
        region: _sessionController.userRegion.value,
        category: _selectedTab,
      );

      setState(() {
        _supabaseEntries = entries;
      });
    } catch (_) {
      // keep fallback
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _detectGpsAndRefresh() async {
    setState(() => _isDetectingGps = true);
    try {
      final loc = await LocationService().detectUserRegion();
      _sessionController.setUserRegion(loc.province);

      setState(() {
        _detectedCoords = loc.displayCoordinates;
      });

      await _loadSupabaseLeaderboard();

      Get.snackbar(
        'Location Detected',
        'Coordinates: ${loc.displayCoordinates}\nRegion: ${loc.formattedRegion}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: AppColors.ink,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Location Detection Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: Colors.red.shade800,
        borderRadius: 0,
        borderColor: Colors.red.shade800,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      setState(() => _isDetectingGps = false);
    }
  }

  Future<void> _submitBestCatchToCloud() async {
    final catches = _sessionController.catches;
    if (catches.isEmpty) {
      Get.snackbar(
        'No Catches Recorded',
        'Log a catch first in Active Session or Journal.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: AppColors.ink,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Find best catch
    var best = catches.first;
    for (final c in catches) {
      if (c.weightKg > best.weightKg) best = c;
    }

    final user = _authController.currentUser.value;
    final name = (user != null && user.displayName.isNotEmpty)
        ? user.displayName
        : 'Angler CastLog';

    String cat = 'Other';
    final sp = best.species.toLowerCase();
    if (sp.contains('carp')) {
      cat = 'Carp';
    } else if (sp.contains('bass')) {
      cat = 'Bass';
    } else if (sp.contains('pike') || sp.contains('trout')) {
      cat = 'Other';
    }

    Get.showOverlay(
      asyncFunction: () async {
        final success = await SupabaseLeaderboardService().submitCatch(
          name: name,
          species: best.species,
          category: cat,
          location: 'Emerald Lake',
          weightKg: best.weightKg,
          region: _sessionController.userRegion.value,
          avatarUrl: user?.avatarUrl,
          rod: best.rodName,
          bait: best.baitOrLure,
          userId: user?.id,
        );

        if (success) {
          await _loadSupabaseLeaderboard();
          Get.snackbar(
            'Submitted to Cloud',
            '${best.species} (${best.weightKg.toStringAsFixed(1)} kg) is now live on Supabase Leaderboard.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.paper,
            colorText: AppColors.ink,
            borderRadius: 0,
            borderColor: AppColors.ink,
            borderWidth: 1,
            margin: const EdgeInsets.all(16),
          );
        } else {
          Get.snackbar(
            'Submission Failed',
            'Please check your internet connection and try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.paper,
            colorText: Colors.red.shade800,
            borderRadius: 0,
            borderColor: Colors.red.shade800,
            borderWidth: 1,
            margin: const EdgeInsets.all(16),
          );
        }
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(color: AppColors.ink),
      ),
    );
  }

  List<Map<String, dynamic>> get _displayEntries {
    if (_supabaseEntries.isNotEmpty) {
      return _supabaseEntries;
    }
    if (_selectedTab == 'Carp') {
      return _fallbackEntries.where((e) => e['category'] == 'Carp').toList();
    } else if (_selectedTab == 'Bass') {
      return _fallbackEntries.where((e) => e['category'] == 'Bass').toList();
    }
    return _fallbackEntries;
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
        child: RefreshIndicator(
          color: AppColors.ink,
          onRefresh: _loadSupabaseLeaderboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    // Supabase cloud live pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.paper,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981), // Emerald green
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SUPABASE CLOUD',
                            style: GoogleFonts.dmSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  'The biggest catches recorded by anglers in your region, synced live via Supabase.',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 20),

                // Region & LBS Card
                Obx(() {
                  final currentRegion = _sessionController.userRegion.value;
                  final regionList = [
                    'DI Yogyakarta',
                    'DKI Jakarta',
                    'Jawa Barat',
                    'Jawa Timur',
                    'Bali',
                  ];

                  String dropdownValue = 'DI Yogyakarta';
                  for (final r in regionList) {
                    if (currentRegion.contains(r.replaceAll('DI ', '').replaceAll('DKI ', ''))) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'REGIONAL LEADERBOARD (LBS)',
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.muted,
                              ),
                            ),
                            if (_detectedCoords != null)
                              Text(
                                _detectedCoords!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                          ],
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
                                _loadSupabaseLeaderboard();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rankings are pulled from Supabase PostgreSQL for this region.',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _isDetectingGps ? null : _detectGpsAndRefresh,
                                icon: _isDetectingGps
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.ink,
                                        ),
                                      )
                                    : const Icon(Icons.my_location, size: 14, color: AppColors.ink),
                                label: Text(
                                  _isDetectingGps ? 'GPS...' : 'Detect GPS',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.ink),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  await Get.toNamed(AppRoutes.region);
                                  _loadSupabaseLeaderboard();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.ink,
                                  side: const BorderSide(color: AppColors.line),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  'Change Region',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MONTHLY LEADERBOARD · SUPABASE',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: const Color(0xFFAAAAAA),
                            ),
                          ),
                          InkWell(
                            onTap: _submitBestCatchToCloud,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              color: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cloud_upload_outlined,
                                      size: 12, color: AppColors.ink),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Submit My Catch',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                        'Verified catches submitted by anglers in your regional community.',
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
                            _loadSupabaseLeaderboard();
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
                            text: '· ${_displayEntries.length} entries',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.ink,
                        ),
                      )
                    else
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
                if (_displayEntries.isEmpty && !_isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events_outlined,
                            size: 32, color: AppColors.muted),
                        const SizedBox(height: 10),
                        Text(
                          'No Anglers in This Region Yet',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Be the first angler to record and submit a catch in this region!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _displayEntries.length,
                    separatorBuilder: (ctx, i) =>
                        const Divider(height: 1, thickness: 1, color: AppColors.line),
                    itemBuilder: (ctx, i) {
                      final entry = _displayEntries[i];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.rankDetail,
                            arguments: {
                              'rank': entry['rank'],
                              'anglerName': entry['name'],
                              'species': entry['species'],
                              'location': entry['location'],
                              'region': entry['region'] ??
                                  _sessionController.userRegion.value,
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
                                'YOUR REGION POSITION',
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: AppColors.muted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_authController.currentUser.value?.displayName ?? 'Angler'} · ${_sessionController.userRegion.value}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: const Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '#01',
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
                  'Connected to Supabase PostgreSQL database. Catch data is shared in real-time across all community anglers.',
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
      ),
    );
  }
}
