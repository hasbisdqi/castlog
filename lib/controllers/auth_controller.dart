import 'dart:convert';
import 'package:castlog/models/user_model.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/services/supabase_auth_service.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthController extends GetxController {
  final SupabaseAuthService _authService = SupabaseAuthService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  bool get isLoggedIn =>
      currentUser.value != null && !currentUser.value!.isGuest;
  bool get isGuest =>
      currentUser.value != null && currentUser.value!.isGuest;

  @override
  void onInit() {
    super.onInit();
    _loadSessionFromStorage();
  }

  void _loadSessionFromStorage() {
    try {
      if (Hive.isBoxOpen('settings_box')) {
        final box = Hive.box('settings_box');
        final raw = box.get('auth_session');
        if (raw != null && raw is String && raw.isNotEmpty) {
          final map = jsonDecode(raw);
          currentUser.value =
              UserModel.fromJson(Map<String, dynamic>.from(map as Map));
          return;
        }
      }
    } catch (_) {}

    // Default to guest mode so app is always interactive
    currentUser.value = UserModel.guest();
  }

  void _saveSessionToStorage() {
    try {
      if (!Hive.isBoxOpen('settings_box')) return;
      final box = Hive.box('settings_box');
      if (currentUser.value != null) {
        box.put('auth_session', jsonEncode(currentUser.value!.toJson()));
      } else {
        box.delete('auth_session');
      }
    } catch (_) {}
  }

  /// Sign in with Supabase
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final user = await _authService.signIn(email: email, password: password);
      currentUser.value = user;
      _saveSessionToStorage();

      Get.snackbar(
        'Welcome Back',
        'Signed in as ${user.email}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: AppColors.ink,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );

      Get.offAllNamed(AppRoutes.home);
      return true;
    } catch (e) {
      Get.snackbar(
        'Authentication Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: Colors.red,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register with Supabase
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      isLoading.value = true;
      final result = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Check if session was returned directly
      final session = result['session'] as Map<String, dynamic>?;
      if (session != null) {
        final accessToken = session['access_token'] as String?;
        currentUser.value = UserModel(
          id: result['id'] ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          displayName: displayName,
          avatarUrl: 'https://i.pravatar.cc/100?img=12',
          accessToken: accessToken,
          isGuest: false,
        );
        _saveSessionToStorage();
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Registration Successful',
          'Account created! You can now sign in with your credentials.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.paper,
          colorText: AppColors.ink,
          borderRadius: 0,
          borderColor: AppColors.ink,
          borderWidth: 1,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
        );
        Get.offNamed(AppRoutes.login);
      }

      return true;
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: Colors.red,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Continue as Guest without sign in
  void continueAsGuest() {
    currentUser.value = UserModel.guest();
    _saveSessionToStorage();
    Get.offAllNamed(AppRoutes.home);
  }

  /// Sign out
  Future<void> signOut() async {
    final token = currentUser.value?.accessToken;
    await _authService.signOut(accessToken: token);

    currentUser.value = UserModel.guest();
    _saveSessionToStorage();

    Get.snackbar(
      'Signed Out',
      'You are now in guest mode',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.paper,
      colorText: AppColors.ink,
      borderRadius: 0,
      borderColor: AppColors.ink,
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
    );

    Get.offAllNamed(AppRoutes.login);
  }
}
