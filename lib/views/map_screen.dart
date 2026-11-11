import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Placeholder Google Maps / Interactive Map Surface
        Positioned.fill(
          child: Container(
            color: const Color(0xFF0F172A),
            child: Stack(
              children: [
                // Ilustrasi Background Pattern Peta/Spot Mockup
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_rounded,
                        size: 80,
                        color: const Color(0xFF38BDF8).withOpacity(0.15),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "PETA SPOT MANCING",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Marker Spot Mockup 1 (Rawa Pening)
                Positioned(
                  top: 240,
                  left: 120,
                  child: _buildMapPin("Rawa Pening", "Gabus", true),
                ),
                // Marker Spot Mockup 2 (Wadaslintang)
                Positioned(
                  top: 380,
                  right: 80,
                  child: _buildMapPin("Wadaslintang", "Toman", false),
                ),
              ],
            ),
          ),
        ),

        // 2. Top Header Overlay (Search Bar & Filter Spot)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // Search Field
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF38BDF8)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Cari spot, sungai, atau waduk...",
                              hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune, color: Colors.white70, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Quick Filter Chips (Potensial Spot)
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildFilterChip("Semua Spot", true),
                        _buildFilterChip("Spot Gabus", false),
                        _buildFilterChip("Spot Toman", false),
                        _buildFilterChip("Waduk & Rawa", false),
                        _buildFilterChip("Muara / Estuary", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3. Map Control Buttons (Pojok Kanan Atas-Tengah)
        Positioned(
          top: 150,
          right: 20,
          child: Column(
            children: [
              _buildMapActionButton(Icons.layers_outlined, () {}),
              const SizedBox(height: 8),
              _buildMapActionButton(Icons.my_location, () {}),
            ],
          ),
        ),

        // 4. Bottom Card Preview (Selected Spot Quick Info)
        Positioned(
          left: 20,
          right: 20,
          bottom: 110, // Memberikan jarak agar tidak tertutup CustomNavBar
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4ADE80).withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: Color(0xFF4ADE80)),
                              SizedBox(width: 6),
                              Text(
                                "HIGH POTENTIAL",
                                style: TextStyle(
                                  color: Color(0xFF4ADE80),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "• 2.4 km dari lokasi",
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                    const Icon(Icons.bookmark_border, color: Colors.white54, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Rawa Pening - Sektor Barat",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.phishing, size: 14, color: Color(0xFF38BDF8)),
                    SizedBox(width: 6),
                    Text(
                      "Target utama: Ikan Gabus & Channa",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.directions, size: 18, color: Color(0xFF0F172A)),
                        label: const Text(
                          "Rute ke Spot",
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Pin / Marker Spot di Peta
  Widget _buildMapPin(String name, String target, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.phishing,
                size: 14,
                color: isActive ? const Color(0xFF0F172A) : const Color(0xFF38BDF8),
              ),
              const SizedBox(width: 6),
              Text(
                "$name ($target)",
                style: TextStyle(
                  color: isActive ? const Color(0xFF0F172A) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
          size: 24,
        ),
      ],
    );
  }

  // Filter Chips
  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF1E293B).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF38BDF8) : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  // Map Action Button
  Widget _buildMapActionButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }
}