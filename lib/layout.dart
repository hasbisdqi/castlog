import 'package:castlog/controllers/navigation_controller.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:castlog/views/home_screen.dart';
import 'package:castlog/views/journal_screen.dart';
import 'package:castlog/views/tackle_box_screen.dart';
import 'package:castlog/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Layout extends StatelessWidget {
  const Layout({super.key});

  static final List<NavItemData> _navItems = [
    NavItemData(icon: Icons.home_rounded, label: "Home"),
    NavItemData(icon: Icons.notes, label: "Journal"),
    NavItemData(icon: Icons.bento, label: "Tackle Box"),
  ];

  static const List<Widget> _pages = [
    HomeScreen(),
    JournalScreen(),
    TackleBoxScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Obx(() {
      final selectedIndex = navController.selectedIndex.value;
      return Scaffold(
        backgroundColor: AppColors.bg,
        extendBody: true,
        body: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: CustomNavBar(
          navItems: _navItems,
          selectedIndex: selectedIndex,
          onItemTapped: (index) {
            navController.changeTab(index);
          },
        ),
      );
    });
  }
}
