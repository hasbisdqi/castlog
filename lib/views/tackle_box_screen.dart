import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/models/setup_model.dart';

class TackleBoxScreen extends StatefulWidget {
  const TackleBoxScreen({super.key});

  @override
  State<TackleBoxScreen> createState() => _TackleBoxScreenState();
}

class _TackleBoxScreenState extends State<TackleBoxScreen> {
  final List<LoadoutModel> _loadouts = const [
    // 1. Emerald Lake Carp & Spod Duo
    LoadoutModel(
      id: 'loadout_1',
      name: 'Emerald Lake Heavy Loadout',
      rods: [
        RodSlotData(
          slotIndex: 1,
          type: SetupType.carp,
          rodName: 'UL-CHUBER™ Deep Horizon',
          rodLength: '4.0 m',
          rodImage:
              'https://wiki.fishingplanet.com/images/c/c9/DeepHorizon.png',
          reel: 'Leviathan 9000',
          line: 'Braid 0.28 mm',
          leader: 'Carp Camo 0.35',
          weightOrFloat: 'Method Feeder 100g',
          hook: '#4/0 Hair Rig',
          baitOrLure: 'Boilies Strawberry 20mm',
        ),
        RodSlotData(
          slotIndex: 2,
          type: SetupType.spod,
          rodName: 'UL-CHUBER™ Power Launcher Spod',
          rodLength: '3.6 m',
          rodImage: 'https://wiki.fishingplanet.com/images/c/cf/5902.png',
          reel: 'UL-CHUBER™ Griffon Spod',
          line: 'Braid 0.24 mm',
          leader: null,
          weightOrFloat: 'Large Spod Rocket',
          hook: null,
          baitOrLure: 'Sweet Corn & Hemp Mix',
        ),
      ],
    ),

    // 2. Spinning & Casting Predator Setup
    LoadoutModel(
      id: 'loadout_2',
      name: 'Predator Hunter Loadout',
      rods: [
        RodSlotData(
          slotIndex: 1,
          type: SetupType.spinning,
          rodName: 'MagFin™ JigWinner',
          rodLength: '2.7 m',
          rodImage: 'https://wiki.fishingplanet.com/images/c/ce/JigWinner.png',
          reel: 'Vortex 4000',
          line: 'Braid 0.18 mm',
          leader: 'Titanium Leader 0.25',
          weightOrFloat: null,
          hook: null,
          baitOrLure: 'Shad 10 cm + JigHead 14g',
        ),
        RodSlotData(
          slotIndex: 2,
          type: SetupType.casting,
          rodName: 'MagFin™ BassCaster',
          rodLength: '2.2 m',
          rodImage: 'https://wiki.fishingplanet.com/images/3/35/BassCaster.png',
          reel: 'Helios 3000 Cast',
          line: 'Fluoro 0.28 mm',
          leader: 'Fluorocarbon 0.30',
          weightOrFloat: null,
          hook: null,
          baitOrLure: 'Crankbait Deep Runner 2m',
        ),
      ],
    ),

    // 3. Float, Feeder & Bottom Setup (3 Rods)
    LoadoutModel(
      id: 'loadout_3',
      name: 'Lightwater & River Combo',
      rods: [
        RodSlotData(
          slotIndex: 1,
          type: SetupType.float,
          rodName: 'RIVERTEX™ Fenix',
          rodLength: '3.9 m',
          rodImage: 'https://wiki.fishingplanet.com/images/f/ff/Fenix.png',
          reel: 'Espira ML 3500',
          line: 'Mono 0.20 mm',
          leader: 'Fluoro 0.16 mm',
          weightOrFloat: 'Oval Wagler 8g',
          hook: '#10 Classic Hook',
          baitOrLure: 'Maggots & Redworm',
        ),
        RodSlotData(
          slotIndex: 2,
          type: SetupType.feeder,
          rodName: 'UL-CHUBER™ Big Alli',
          rodLength: '3.6 m',
          rodImage: 'https://wiki.fishingplanet.com/images/e/e6/Big_Alli.png',
          reel: 'Amplus 5000',
          line: 'Mono 0.25 mm',
          leader: 'Mono Leader 0.20',
          weightOrFloat: 'Closed Feeder 60g',
          hook: '#6 Feeder Hook',
          baitOrLure: 'Cheese & Dough Paste',
        ),
        RodSlotData(
          slotIndex: 3,
          type: SetupType.feeder,
          rodName: 'UL-CHUBER™ Heavy Chaser',
          rodLength: '3.4 m',
          rodImage:
              'https://wiki.fishingplanet.com/images/a/a4/Heavy_Chaser.png',
          reel: 'Big River 6000',
          line: 'Braid 0.30 mm',
          leader: 'Titanium Leader 0.35',
          weightOrFloat: 'Sinker 150g',
          hook: '#2/0 Catfish Hook',
          baitOrLure: 'Cutbait & Large Minnows',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                    const SizedBox(height: 25),
                    _buildToolbar(_loadouts.length),
                    const SizedBox(height: 18),
                    ..._loadouts.map((loadout) => _buildLoadoutCard(loadout)),
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
          'Tackle box.',
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
          'Your trusted setups, ready for the next session.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            height: 1.7,
            color: AppColors.muted,
          ),
        ),
      ],
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
              const TextSpan(text: 'Saved setups '),
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
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.line),
            ),
            child: Text(
              '＋ Add setup',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadoutCard(LoadoutModel loadout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Loadout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loadout.name,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loadout.subtitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Daftar Joran dalam Loadout
          ...loadout.rods.map((rod) => _buildRodSlotCard(rod)),
        ],
      ),
    );
  }

  Widget _buildRodSlotCard(RodSlotData rod) {
    final specs = rod.dynamicSpecs;
    final hasImage = rod.rodImage != null && rod.rodImage!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior:
          Clip.hardEdge, // Potong rapi jika gambar melewati batas kanan kartu
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Bar: Badge ROD X & Panjang Joran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  color: AppColors.ink, // Siku tajam tanpa borderRadius
                  child: Text(
                    'ROD ${rod.slotIndex}',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  rod.rodLength,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),

            // 2. Gambar Joran (Diberi ruang khusus agar tidak menabrak teks)
            if (hasImage) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -8,
                      right: -28, // Sedikit memanjang ke kanan
                      top: 0,
                      bottom: 0,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.82, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.network(
                          rod.rodImage!,
                          fit: BoxFit.contain,
                          headers: const {
                            'User-Agent':
                                'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ] else
              const SizedBox(height: 12),

            // 3. Tipe Setup & Nama Joran
            Text(
              rod.type.label.toUpperCase(),
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rod.rodName,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                color: AppColors.ink,
              ),
            ),

            // 4. Specs Grid 3 Kolom (Lurus vertikal tanpa divider)
            if (specs.isNotEmpty) ...[
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 24) / 3;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: specs.map((spec) {
                      return SizedBox(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              spec.label,
                              style: GoogleFonts.dmSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spec.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
