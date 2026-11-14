
import 'package:hive/hive.dart';

part 'gear_model.g.dart';

@HiveType(typeId: 1)
class GearModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  String subCategory;

  @HiveField(3)
  String image;

  @HiveField(4)
  String description;

  GearModel({
    required this.name,
    required this.category,
    required this.subCategory,
    required this.image,
    required this.description,
  });

  factory GearModel.fromJson(Map<String, dynamic> json) {
    return GearModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'image': image,
      'description': description,
    };
  }
}
