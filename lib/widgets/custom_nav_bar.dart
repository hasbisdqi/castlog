import 'package:castlog/widgets/nav_item.dart';
import 'package:flutter/material.dart';

class NavItemData {
  final IconData icon;
  final String label;

  NavItemData({required this.icon, required this.label});
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this._navItems,
    required this._selectedIndex,
    required this.onItemTapped,
    this.onPlusTapped,
  });

  final List<NavItemData> _navItems;
  final int _selectedIndex;
  final ValueChanged<int> onItemTapped;
  final VoidCallback? onPlusTapped;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
        child: Row(
          children: [
            // Floating Navigation Bar (Home, Map, Profile)
            Expanded(
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_navItems.length, (index) {
                    final isSelected = _selectedIndex == index;
                    final item = _navItems[index];

                    return NavItem(
                      index: index,
                      onItemTapped: onItemTapped,
                      isSelected: isSelected,
                      item: item,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol Plus di sebelah kanan
            GestureDetector(
              onTap: onPlusTapped,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
