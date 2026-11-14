import 'dart:convert';

import 'package:castlog/models/gear_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/fish_model.dart';

class DatasetInitializer {
  static const String baseUrl =
      'https://raw.githubusercontent.com/hasbisdqi/fishingplanet-dataset/main';

  static const int datasetVersion = 3; // Naikkan jika dataset ada update

  static Future<void> initialize() async {
    final metaBox = await Hive.openBox('metadata');
    final fishBox = await Hive.openBox<FishModel>('fish');
    final gearBox = await Hive.openBox<GearModel>('gears');
    final mapsBox = await Hive.openBox<String>('maps_raw');

    final int currentVer = metaBox.get('dataset_version', defaultValue: 0);

    if (fishBox.isEmpty || currentVer < datasetVersion) {
      await _downloadFish();
    }

    if (gearBox.isEmpty || currentVer < datasetVersion) {
      await _downloadGears();
    }

    if (mapsBox.isEmpty || currentVer < datasetVersion) {
      await _downloadMaps();
    }

    await metaBox.put('dataset_version', datasetVersion);
  }

  static Future<void> _downloadMaps() async {
    final response = await http.get(
      Uri.parse('$baseUrl/maps.json'),
    );

    if (response.statusCode != 200) {
      return; // Fallback graceful
    }

    final box = Hive.box<String>('maps_raw');
    await box.clear();
    await box.put('maps_json', response.body);
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