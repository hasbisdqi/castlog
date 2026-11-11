import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. App Bar Minimalis
        SliverAppBar.large(
          expandedHeight: 130,
          floating: false,
          pinned: true,
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CastLog",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Fishing Journal",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white38,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.tune_rounded,
                color: Colors.white70,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // 2. Summary Dashboard Minimalis (Border Halus)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Total Strike", "42"),
                  Container(height: 28, width: 1, color: Colors.white10),
                  _buildStatItem("Spots", "12"),
                  Container(height: 28, width: 1, color: Colors.white10),
                  _buildStatItem("Max Weight", "4.5 kg"),
                ],
              ),
            ),
          ),
        ),

        // 3. Section Header: Lures
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              "Favorite Lures",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        // 4. Horizontal Minimalist Lure Chips
        SliverToBoxAdapter(
          child: SizedBox(
            height: 140, // Ditinggikan sedikit agar rasio gambar pas
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildLureCard(
                  name: "Softfrog 4cm",
                  count: "21 Strikes",
                  imageUrl: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=400&auto=format&fit=crop", // Gambar contoh
                ),
                _buildLureCard(
                  name: "Minnow 7cm",
                  count: "15 Strikes",
                  imageUrl: "https://images.unsplash.com/photo-1516962215378-7fa2e137ae93?q=80&w=400&auto=format&fit=crop",
                ),
                _buildLureCard(
                  name: "Spoon 12g",
                  count: "6 Strikes",
                  imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=400&auto=format&fit=crop",
                ),
              ],
            ),
          ),
        ),

        // 5. Section Header: Recent Strikes
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              "Recent Logs",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        // 6. Vertical List Logs (Simple Card Style)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final fishList = [
                "Ikan Gabus",
                "Ikan Toman",
                "Ikan Hampala",
                "Ikan Barramundi",
              ];
              final weightList = ["1.2 kg", "3.8 kg", "0.9 kg", "2.5 kg"];
              final lureList = [
                "Softfrog 4cm",
                "Jumpfrog",
                "Minnow Sinking",
                "Pencil Bait",
              ];

              final fishName = fishList[index % fishList.length];
              final weight = weightList[index % weightList.length];
              final lure = lureList[index % lureList.length];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.phishing,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    fishName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "$lure • Rawa Pening",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  trailing: Text(
                    weight,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }, childCount: 6),
          ),
        ),

        // Spacing bawah agar item terbawah tidak tertutup Floating CustomNavBar
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  static Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
      ],
    );
  }

  static Widget _buildLureCard({
    required String name,
    required String count,
    required String imageUrl,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Gambar Lure / Fishing Background
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF121212),
                    child: const Icon(Icons.phishing, color: Colors.white24),
                  );
                },
              ),
            ),

            // Layer Gradient (Fade Efek dari Transparan ke Hitam di bagian bawah)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Border Halus Minimalis di Atas Card
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
              ),
            ),

            // Teks Informasi Lure
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    count,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
