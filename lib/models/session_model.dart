import 'package:castlog/models/setup_model.dart';

class CatchModel {
  final String id;
  final String species;
  final String waterway;
  final double weightKg;
  final double lengthCm;
  final String rodName;
  final SetupType rodType;
  final String? baitOrLure;
  final String? image;
  final String? notes;
  final DateTime timestamp;
  final String? sessionId;

  const CatchModel({
    required this.id,
    required this.species,
    required this.waterway,
    required this.weightKg,
    required this.lengthCm,
    required this.rodName,
    required this.rodType,
    this.baitOrLure,
    this.image,
    this.notes,
    required this.timestamp,
    this.sessionId,
  });

  String get weightFormatted => '${weightKg.toStringAsFixed(1)} kg';
  String get lengthFormatted => '${lengthCm.toStringAsFixed(0)} cm';

  Map<String, dynamic> toJson() => {
        'id': id,
        'species': species,
        'waterway': waterway,
        'weightKg': weightKg,
        'lengthCm': lengthCm,
        'rodName': rodName,
        'rodType': rodType.index,
        'baitOrLure': baitOrLure,
        'image': image,
        'notes': notes,
        'timestamp': timestamp.toIso8601String(),
        'sessionId': sessionId,
      };

  factory CatchModel.fromJson(Map<String, dynamic> json) {
    return CatchModel(
      id: json['id'] as String,
      species: json['species'] as String,
      waterway: json['waterway'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      lengthCm: (json['lengthCm'] as num).toDouble(),
      rodName: json['rodName'] as String,
      rodType: SetupType.values[json['rodType'] as int? ?? 0],
      baitOrLure: json['baitOrLure'] as String?,
      image: json['image'] as String?,
      notes: json['notes'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sessionId: json['sessionId'] as String?,
    );
  }
}

class SessionModel {
  final String id;
  final String waterwayName;
  final String waterwayRegion;
  final String waterwayImage;
  final LoadoutModel loadout;
  final DateTime startTime;
  DateTime? endTime;
  bool isActive;
  final List<CatchModel> catches;

  SessionModel({
    required this.id,
    required this.waterwayName,
    required this.waterwayRegion,
    required this.waterwayImage,
    required this.loadout,
    required this.startTime,
    this.endTime,
    this.isActive = true,
    List<CatchModel>? catches,
  }) : catches = catches ?? [];

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  String get formattedDuration {
    final d = duration;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  String get formattedDurationShort {
    final d = duration;
    if (d.inHours > 0) {
      final mins = d.inMinutes % 60;
      return mins > 0 ? '${d.inHours}h ${mins}m' : '${d.inHours}h';
    }
    final mins = d.inMinutes;
    return mins > 0 ? '${mins}m' : '${d.inSeconds}s';
  }

  double get totalWeightKg {
    return catches.fold(0.0, (sum, c) => sum + c.weightKg);
  }

  CatchModel? get biggestCatch {
    if (catches.isEmpty) return null;
    return catches.reduce((curr, next) => curr.weightKg > next.weightKg ? curr : next);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'waterwayName': waterwayName,
        'waterwayRegion': waterwayRegion,
        'waterwayImage': waterwayImage,
        'loadout': loadout.toJson(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'isActive': isActive,
        'catches': catches.map((c) => c.toJson()).toList(),
      };

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String? ?? 'session_${DateTime.now().millisecondsSinceEpoch}',
      waterwayName: json['waterwayName'] as String? ?? '',
      waterwayRegion: json['waterwayRegion'] as String? ?? '',
      waterwayImage: json['waterwayImage'] as String? ?? '',
      loadout: json['loadout'] != null
          ? LoadoutModel.fromJson(Map<String, dynamic>.from(json['loadout'] as Map))
          : const LoadoutModel(id: 'loadout_default', name: 'Default', rods: []),
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
      catches: (json['catches'] as List<dynamic>?)
              ?.map((c) => CatchModel.fromJson(Map<String, dynamic>.from(c as Map)))
              .toList() ??
          [],
    );
  }
}
