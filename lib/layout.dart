import 'package:castlog/views/add_log_screen.dart';
import 'package:castlog/views/home_screen.dart';
import 'package:castlog/views/map_screen.dart';
import 'package:castlog/views/profile_screen.dart';
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
    NavItemData(icon: Icons.map, label: "Map"),
    NavItemData(icon: Icons.person_outline_rounded, label: "Profile"),
  ];

  late final List<Widget> _pages = [
    const HomeScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
        onPlusTapped: () => Navigator.push(
          (context),
          MaterialPageRoute(builder: (builder) => AddLogScreen()),
        ),
      ),
    );
  }
}
