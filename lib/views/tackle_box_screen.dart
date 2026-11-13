import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:castlog/theme/app_colors.dart';

class SetupModel {
  final String name;
  final String category;
  final Map<String, String> specs;

  const SetupModel({
    required this.name,
    required this.category,
    required this.specs,
  });
}

class TackleBoxScreen extends StatefulWidget {
  const TackleBoxScreen({super.key});

  @override
  State<TackleBoxScreen> createState() => _TackleBoxScreenState();
}

class _TackleBoxScreenState extends State<TackleBoxScreen> {
  final List<SetupModel> _setups = const [
    SetupModel(
      name: 'Carp Hunter',
      category: 'Carp fishing · Spod setup',
      specs: {
        'ROD': 'Rhino X',
        'REEL': 'Syberia',
        'LINE': 'Mono 0.28',
        'BAIT': 'Sweet Corn',
      },
    ),
    SetupModel(
      name: 'Light Feeder',
      category: 'Lightweight · Feeder setup',
      specs: {
        'ROD': 'ValueSpin',
        'REEL': 'Espira',
        'LINE': 'Braid 0.12',
        'BAIT': 'Redworm',
      },
    ),
    SetupModel(
      name: 'Predator Hunter',
      category: 'Spinning · Lure setup',
      specs: {
        'ROD': 'JigWinner',
        'REEL': 'Vortex',
        'LINE': 'Braid 0.16',
        'LURE': 'Shad 10 cm',
      },
    ),
    SetupModel(
      name: 'Float Classic',
      category: 'Float fishing',
      specs: {
        'ROD': 'Match Pro',
        'REEL': 'Prima',
        'LINE': 'Mono 0.20',
        'BAIT': 'Maggot',
      },
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
                    _buildToolbar(_setups.length),
                    const SizedBox(height: 18),
                    ..._setups.map((setup) => _buildSetupCard(setup)),
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

  Widget _buildSetupCard(SetupModel setup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      setup.name,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      setup.category,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Edit',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(top: 13),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Wrap(
              spacing: 15,
              runSpacing: 10,
              children: setup.specs.entries.map((e) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: AppColors.muted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      e.value,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
