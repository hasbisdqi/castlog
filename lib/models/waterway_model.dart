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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapFishSpecies &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
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
    final seen = <String>{};
    final species = <MapFishSpecies>[];
    for (final item in list) {
      if (item is Map<String, dynamic>) {
        final sp = MapFishSpecies.fromJson(item);
        if (sp.name.isNotEmpty && seen.add(sp.name)) {
          species.add(sp);
        }
      }
    }

    return WaterwayModel(
      name: json['name'] as String? ?? '',
      region: json['region'] as String? ?? '',
      locationCountry: json['locationCountry'] as String? ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fishSpecies: species,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterwayModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
