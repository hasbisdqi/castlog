class MapFishSpecies {
  final String name;
  final String rarityFound;
  final String image;
  final String url;

  const MapFishSpecies({
    required this.name,
    required this.rarityFound,
    required this.image,
    required this.url,
  });

  factory MapFishSpecies.fromJson(Map<String, dynamic> json) {
    return MapFishSpecies(
      name: json['name'] as String? ?? '',
      rarityFound: json['rarityFound'] as String? ?? 'Common',
      image: json['image'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'rarityFound': rarityFound,
        'image': image,
        'url': url,
      };
}

class WaterwayModel {
  final String name;
  final String region;
  final String locationCountry;
  final String image;
  final String description;
  final List<MapFishSpecies> fishSpecies;

  const WaterwayModel({
    required this.name,
    required this.region,
    required this.locationCountry,
    required this.image,
    required this.description,
    required this.fishSpecies,
  });

  factory WaterwayModel.fromJson(Map<String, dynamic> json) {
    final list = json['fishSpecies'] as List<dynamic>? ?? [];
    return WaterwayModel(
      name: json['name'] as String? ?? '',
      region: json['region'] as String? ?? '',
      locationCountry: json['locationCountry'] as String? ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fishSpecies: list.map((e) => MapFishSpecies.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
