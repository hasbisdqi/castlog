import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. App Bar Minimalis dengan Quick Action
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white70,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // 2. Header User Info (Avatar + Bio)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Avatar dengan Ring Accent
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFF1E1E1E),
                      child: Icon(
                        Icons.person,
                        size: 44,
                        color: Colors.white70,
                      ),
                      // Jika pakai gambar:
                      // backgroundImage: NetworkImage('https://...'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Angler Pro",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Casting Specialist • Freshwater & Estuary",
                  style: TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
        ),

        // 3. Stats Grid / Summary Box (PB, Trips, Strike Rate)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProfileStat("Personal Best", "4.5 kg"),
                  Container(height: 30, width: 1, color: Colors.white10),
                  _buildProfileStat("Total Trips", "28"),
                  Container(height: 30, width: 1, color: Colors.white10),
                  _buildProfileStat("Hookup Rate", "78%"),
                ],
              ),
            ),
          ),
        ),

        // 4. Section: Fishing Tackle Gear Box
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "Tackle Box & Setup",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.phishing,
                    title: "Rod & Reel Setup",
                    subtitle: "2 Baitcasting, 1 Spinning",
                    onTap: () {},
                  ),
                  Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                  _buildMenuTile(
                    icon: Icons.inventory_2_outlined,
                    title: "Lure Collection",
                    subtitle: "24 items registered",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5. Section: Preferences & App Settings
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 10),
            child: Text(
              "Preferences",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.cloud_download_outlined,
                    title: "Export Log Data",
                    subtitle: "CSV / JSON Backup",
                    onTap: () {},
                  ),
                  Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                  _buildMenuTile(
                    icon: Icons.tune_rounded,
                    title: "App Settings",
                    subtitle: "Units, Theme & Privacy",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),

        // Extra Space di bawah agar tidak tertutup CustomNavBar
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  // Widget Pembantu untuk Item Statistik Profile
  static Widget _buildProfileStat(String label, String value) {
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
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
      ],
    );
  }

  // Widget Pembantu untuk Menu List
  static Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white70, size: 19),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white38, fontSize: 11),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white24,
        size: 20,
      ),
    );
  }
}
