import 'dart:convert';

import 'package:castlog/models/gear_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/fish_model.dart';

class DatasetInitializer {
  static const String baseUrl =
      'https://raw.githubusercontent.com/hasbisdqi/fishingplanet-dataset/main';

  static Future<void> initialize() async {
    final fishBox = await Hive.openBox<FishModel>('fish');
    final gearBox = await Hive.openBox<GearModel>('gears');

    if (fishBox.isEmpty) {
      await _downloadFish();
    }

    if (gearBox.isEmpty) {
      await _downloadGears();
    }
  }

  static Future<void> _downloadFish() async {
    final response = await http.get(
      Uri.parse('$baseUrl/fish.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengunduh fish dataset');
    }

    final List<dynamic> jsonData = jsonDecode(response.body);

    final fish = jsonData
        .map((item) => FishModel.fromJson(item))
        .toList();

    final box = Hive.box<FishModel>('fish');

    await box.clear();
    await box.addAll(fish);
  }

  static Future<void> _downloadGears() async {
    final response = await http.get(
      Uri.parse('$baseUrl/gear.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengunduh gear dataset');
    }

    final List<dynamic> jsonData = jsonDecode(response.body);

    final gears = jsonData
        .map((item) => GearModel.fromJson(item))
        .toList();

    final box = Hive.box<GearModel>('gears');

    await box.clear();
    await box.addAll(gears);
  }
}