import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/views/home_screen.dart';
import 'package:castlog/views/journal_screen.dart';
import 'package:castlog/views/tackle_box_screen.dart';
import 'package:castlog/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final List<NavItemData> _navItems = [
    NavItemData(icon: Icons.home_rounded, label: "Home"),
    NavItemData(icon: Icons.notes, label: "Journal"),
    NavItemData(icon: Icons.bento, label: "Tackle Box"),
  ];

  late final List<Widget> _pages = [
    const HomeScreen(),
    const JournalScreen(),
    const TackleBoxScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: CustomNavBar(
        navItems: _navItems,
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
