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
  });

  final List<NavItemData> _navItems;
  final int _selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
