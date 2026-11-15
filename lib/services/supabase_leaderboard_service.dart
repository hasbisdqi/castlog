import 'dart:convert';
import 'dart:developer';
import 'package:castlog/core/supabase_config.dart';
import 'package:http/http.dart' as http;

class LeaderboardEntry {
  final String id;
  final String? userId;
  final String name;
  final String species;
  final String category;
  final String location;
  final double weightKg;
  final String region;
  final String avatarUrl;
  final String photoUrl;
  final String rod;
  final String bait;
  final DateTime createdAt;

  LeaderboardEntry({
    required this.id,
    this.userId,
    required this.name,
    required this.species,
    required this.category,
    required this.location,
    required this.weightKg,
    required this.region,
    required this.avatarUrl,
    required this.photoUrl,
    required this.rod,
    required this.bait,
    required this.createdAt,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString(),
      name: json['name'] ?? 'Angler',
      species: json['species'] ?? 'Fish',
      category: json['category'] ?? 'Other',
      location: json['location'] ?? 'Waterway',
      weightKg: (json['weight_kg'] is num)
          ? (json['weight_kg'] as num).toDouble()
          : double.tryParse(json['weight_kg']?.toString() ?? '0') ?? 0.0,
      region: json['region'] ?? 'DI Yogyakarta',
      avatarUrl: json['avatar_url'] ?? 'https://i.pravatar.cc/100?img=12',
      photoUrl: json['photo_url'] ??
          'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85',
      rod: json['rod'] ?? 'Feeder Pro',
      bait: json['bait'] ?? 'Sweet Corn',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toViewMap(int rankIndex) {
    return {
      'rank': rankIndex < 10 ? '0$rankIndex' : '$rankIndex',
      'name': name,
      'species': species,
      'category': category,
      'location': location,
      'weight': '${weightKg.toStringAsFixed(2)} kg',
      'date': _formatDate(createdAt),
      'avatarUrl': avatarUrl,
      'photoUrl': photoUrl,
      'rod': rod,
      'bait': bait,
      'region': region,
    };
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }
}

class SupabaseLeaderboardService {
  static final SupabaseLeaderboardService _instance =
      SupabaseLeaderboardService._internal();
  factory SupabaseLeaderboardService() => _instance;
  SupabaseLeaderboardService._internal();

  final Map<String, String> _headers = {
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
    'Content-Type': 'application/json',
  };

  /// Fetch leaderboard entries filtered by region and category from Supabase
  Future<List<Map<String, dynamic>>> fetchLeaderboard({
    String? region,
    String? category,
  }) async {
    try {
      final queryParams = <String>[
        'select=*',
        'order=weight_kg.desc',
        'limit=50',
      ];

      // Match region flexibly (e.g. "Yogyakarta" matches "DI Yogyakarta" and "Kota Yogyakarta, DI Yogyakarta")
      if (region != null && region.isNotEmpty && region != 'All') {
        String cleanRegion = region;
        if (region.contains(',')) {
          final parts = region.split(',');
          cleanRegion = parts.last.trim();
        }
        cleanRegion = cleanRegion.replaceAll('DI ', '').replaceAll('DKI ', '').trim();
        queryParams.add('region=ilike.*$cleanRegion*');
      }

      if (category != null && category.isNotEmpty && category != 'Overall' && category != 'This month') {
        queryParams.add('category=ilike.*$category*');
      }

      final uri = Uri.parse(
          '${SupabaseConfig.url}/rest/v1/leaderboard_entries?${queryParams.join('&')}');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> results = [];
        for (int i = 0; i < data.length; i++) {
          final entry = LeaderboardEntry.fromJson(data[i]);
          results.add(entry.toViewMap(i + 1));
        }
        return results;
      } else {
        log('Error fetching leaderboard: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      log('Exception fetching leaderboard from Supabase: $e');
      return [];
    }
  }

  /// Submit a user catch directly to Supabase Leaderboard
  Future<bool> submitCatch({
    required String name,
    required String species,
    required String category,
    required String location,
    required double weightKg,
    required String region,
    String? avatarUrl,
    String? photoUrl,
    String? rod,
    String? bait,
    String? userId,
  }) async {
    try {
      final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/leaderboard_entries');
      final response = await http.post(
        uri,
        headers: {
          ..._headers,
          'Prefer': 'return=representation',
        },
        body: jsonEncode({
          'user_id': userId,
          'name': name.trim(),
          'species': species.trim(),
          'category': category.trim(),
          'location': location.trim(),
          'weight_kg': weightKg,
          'region': region.trim(),
          'avatar_url': avatarUrl ?? 'https://i.pravatar.cc/100?img=12',
          'photo_url': photoUrl ??
              'https://images.unsplash.com/photo-1535392432937-a27c36ec07b5?w=1000&q=85',
          'rod': rod ?? 'Feeder Pro',
          'bait': bait ?? 'Sweet Corn',
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        log('Failed to submit catch to Supabase: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      log('Exception submitting catch to Supabase: $e');
      return false;
    }
  }
}
