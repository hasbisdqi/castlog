import 'package:hive/hive.dart';

part 'fish_model.g.dart';

@HiveType(typeId: 0)
class FishModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  String image;

  @HiveField(3)
  String description;

  FishModel({
    required this.name,
    required this.category,
    required this.image,
    required this.description,
  });

  factory FishModel.fromJson(Map<String, dynamic> json) {
    return FishModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}