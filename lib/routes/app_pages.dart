import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/controllers/tackle_box_controller.dart';
import 'package:castlog/layout.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/views/achievements_screen.dart';
import 'package:castlog/views/active_session_screen.dart';
import 'package:castlog/views/angler_profile_screen.dart';
import 'package:castlog/views/catch_detail_screen.dart';
import 'package:castlog/views/leaderboard_screen.dart';
import 'package:castlog/views/notifications_screen.dart';
import 'package:castlog/views/profile_screen.dart';
import 'package:castlog/views/rank_detail_screen.dart';
import 'package:castlog/views/region_screen.dart';
import 'package:castlog/views/session_summary_screen.dart';
import 'package:castlog/views/sessions_screen.dart';
import 'package:castlog/views/setup_form_screen.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TackleBoxController>(() => TackleBoxController(), fenix: true);
    Get.lazyPut<SessionController>(() => SessionController(), fenix: true);
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const Layout(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.setupForm,
      page: () => const SetupFormScreen(),
    ),
    GetPage(
      name: AppRoutes.catchDetail,
      page: () => const CatchDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.activeSession,
      page: () => const ActiveSessionScreen(),
    ),
    GetPage(
      name: AppRoutes.sessionSummary,
      page: () => const SessionSummaryScreen(),
    ),
    GetPage(
      name: AppRoutes.sessions,
      page: () => const SessionsScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.anglerProfile,
      page: () => const AnglerProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.achievements,
      page: () => const AchievementsScreen(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.leaderboard,
      page: () => const LeaderboardScreen(),
    ),
    GetPage(
      name: AppRoutes.rankDetail,
      page: () => const RankDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.region,
      page: () => const RegionScreen(),
    ),
  ];
}
