import 'dart:convert';
import 'package:castlog/models/waterway_model.dart';
import 'package:hive/hive.dart';

class WaterwayService {
  List<WaterwayModel> getAllWaterways() {
    if (!Hive.isBoxOpen('maps_raw')) return _getFallbackWaterways();
    final box = Hive.box<String>('maps_raw');
    final raw = box.get('maps_json');
    if (raw == null || raw.isEmpty) return _getFallbackWaterways();

    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => WaterwayModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return _getFallbackWaterways();
    }
  }

  WaterwayModel? getWaterwayByName(String name) {
    final all = getAllWaterways();
    return all.firstWhere(
      (w) => w.name.toLowerCase().contains(name.toLowerCase()) || name.toLowerCase().contains(w.name.toLowerCase()),
      orElse: () => all.first,
    );
  }

  List<WaterwayModel> _getFallbackWaterways() {
    return [
      const WaterwayModel(
        name: 'Emerald Lake - New York',
        region: 'North America',
        locationCountry: 'United States',
        image: 'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
        description: 'Deep and cold lake with scenic pine trees.',
        fishSpecies: [
          MapFishSpecies(
            name: 'Walleye',
            rarityFound: 'Common Trophy',
            image: 'https://wiki.fishingplanet.com/images/thumb/0/05/Walleye.png/300px-Walleye.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Chain Pickerel',
            rarityFound: 'Common Trophy Unique',
            image: 'https://wiki.fishingplanet.com/images/thumb/6/6c/Chain_Pickerel.png/300px-Chain_Pickerel.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Northern Pike',
            rarityFound: 'Young Common',
            image: 'https://wiki.fishingplanet.com/images/thumb/0/0b/Northern_Pike.png/300px-Northern_Pike.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Yellow Perch',
            rarityFound: 'Common Trophy',
            image: 'https://wiki.fishingplanet.com/images/thumb/6/6a/Yellow_Perch.png/300px-Yellow_Perch.png',
            url: '',
          ),
        ],
      ),
      const WaterwayModel(
        name: 'Lone Star Lake - Texas',
        region: 'North America',
        locationCountry: 'United States',
        image: 'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
        description: 'Small, quiet lake with peaceful atmosphere.',
        fishSpecies: [
          MapFishSpecies(
            name: 'Spotted Bass',
            rarityFound: 'Common',
            image: 'https://wiki.fishingplanet.com/images/thumb/7/7d/Spotted_Bass.png/300px-Spotted_Bass.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Bluegill',
            rarityFound: 'Common Trophy',
            image: 'https://wiki.fishingplanet.com/images/thumb/a/a2/Bluegill.png/300px-Bluegill.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Channel Catfish',
            rarityFound: 'Young',
            image: 'https://wiki.fishingplanet.com/images/thumb/7/73/Channel_Catfish.png/300px-Channel_Catfish.png',
            url: '',
          ),
        ],
      ),
      const WaterwayModel(
        name: 'Mudwater River - Missouri',
        region: 'North America',
        locationCountry: 'United States',
        image: 'https://wiki.fishingplanet.com/images/d/d2/Missouri.jpg',
        description: 'Meandering river with muddy waters and brush piles.',
        fishSpecies: [
          MapFishSpecies(
            name: 'Largemouth Bass',
            rarityFound: 'Young Common Trophy',
            image: 'https://wiki.fishingplanet.com/images/thumb/1/11/Largemouth_Bass.png/300px-Largemouth_Bass.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Bowfin',
            rarityFound: 'Common Trophy',
            image: 'https://wiki.fishingplanet.com/images/thumb/3/34/Bowfin.png/300px-Bowfin.png',
            url: '',
          ),
          MapFishSpecies(
            name: 'Spotted Gar',
            rarityFound: 'Common Trophy Unique',
            image: 'https://wiki.fishingplanet.com/images/thumb/5/59/Spotted_Gar.png/300px-Spotted_Gar.png',
            url: '',
          ),
        ],
      ),
    ];
  }
}
