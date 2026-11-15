import 'dart:convert';
import 'package:castlog/core/supabase_config.dart';
import 'package:castlog/models/user_model.dart';
import 'package:http/http.dart' as http;

class SupabaseAuthService {
  final Map<String, String> _headers = {
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
    'Content-Type': 'application/json',
  };

  /// Register a new user with Supabase Auth
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/auth/v1/signup');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
        'data': {
          'display_name': displayName.trim(),
          'avatar_url': 'https://i.pravatar.cc/100?img=12',
        },
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data as Map<String, dynamic>;
    } else {
      final msg = data['msg'] ??
          data['message'] ??
          data['error_description'] ??
          'Sign up failed with status ${response.statusCode}';
      throw Exception(msg);
    }
  }

  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/auth/v1/token?grant_type=password');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final accessToken = data['access_token'] as String?;
      final userObj = data['user'] as Map<String, dynamic>?;

      final id = userObj?['id'] as String? ?? 'user_${DateTime.now().millisecondsSinceEpoch}';
      final userEmail = userObj?['email'] as String? ?? email;
      final metadata = userObj?['user_metadata'] as Map<String, dynamic>?;
      final displayName = metadata?['display_name'] as String? ?? userEmail.split('@').first;
      final avatarUrl = metadata?['avatar_url'] as String? ?? 'https://i.pravatar.cc/100?img=12';

      return UserModel(
        id: id,
        email: userEmail,
        displayName: displayName,
        avatarUrl: avatarUrl,
        accessToken: accessToken,
        isGuest: false,
      );
    } else {
      final msg = data['msg'] ??
          data['message'] ??
          data['error_description'] ??
          'Invalid login credentials';
      throw Exception(msg);
    }
  }

  /// Sign out
  Future<void> signOut({String? accessToken}) async {
    if (accessToken == null || accessToken.isEmpty) return;
    try {
      final uri = Uri.parse('${SupabaseConfig.url}/auth/v1/logout');
      await http.post(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (_) {}
  }
}
