enum SetupType {
  spinning('Spinning'),
  casting('Casting'),
  float('Float'),
  feeder('Feeder / Bottom'),
  carp('Carp'),
  spod('Spod');

  final String label;
  const SetupType(this.label);
}

class GearSpecItem {
  final String label;
  final String value;

  const GearSpecItem({required this.label, required this.value});
}

class RodSlotData {
  final int slotIndex;
  final SetupType type;
  final String rodName;
  final String rodLength;
  final String? rodImage;
  final String? reel;
  final String? line;
  final String? leader;
  final String? weightOrFloat;
  final String? hook;
  final String baitOrLure;

  const RodSlotData({
    required this.slotIndex,
    required this.type,
    required this.rodName,
    required this.rodLength,
    this.rodImage,
    this.reel,
    this.line,
    this.leader,
    this.weightOrFloat,
    this.hook,
    required this.baitOrLure,
  });

  List<GearSpecItem> get dynamicSpecs {
    final list = <GearSpecItem>[];

    list.add(GearSpecItem(label: 'ROD', value: rodName));

    if (reel != null && reel!.isNotEmpty) {
      list.add(GearSpecItem(label: 'REEL', value: reel!));
    }
    if (line != null && line!.isNotEmpty) {
      list.add(GearSpecItem(label: 'LINE', value: line!));
    }
    if (leader != null && leader!.isNotEmpty) {
      list.add(GearSpecItem(label: 'LEADER', value: leader!));
    }

    switch (type) {
      case SetupType.spinning:
      case SetupType.casting:
        list.add(GearSpecItem(label: 'LURE', value: baitOrLure));
        break;

      case SetupType.float:
        if (weightOrFloat != null && weightOrFloat!.isNotEmpty) {
          list.add(GearSpecItem(label: 'FLOAT', value: weightOrFloat!));
        }
        if (hook != null && hook!.isNotEmpty) {
          list.add(GearSpecItem(label: 'HOOK', value: hook!));
        }
        list.add(GearSpecItem(label: 'BAIT', value: baitOrLure));
        break;

      case SetupType.feeder:
        if (weightOrFloat != null && weightOrFloat!.isNotEmpty) {
          list.add(GearSpecItem(label: 'FEEDER / SINKER', value: weightOrFloat!));
        }
        if (hook != null && hook!.isNotEmpty) {
          list.add(GearSpecItem(label: 'HOOK', value: hook!));
        }
        list.add(GearSpecItem(label: 'BAIT', value: baitOrLure));
        break;

      case SetupType.carp:
        if (weightOrFloat != null && weightOrFloat!.isNotEmpty) {
          list.add(GearSpecItem(label: 'SINKER', value: weightOrFloat!));
        }
        if (hook != null && hook!.isNotEmpty) {
          list.add(GearSpecItem(label: 'CARP HOOK', value: hook!));
        }
        list.add(GearSpecItem(label: 'BAIT', value: baitOrLure));
        break;

      case SetupType.spod:
        if (weightOrFloat != null && weightOrFloat!.isNotEmpty) {
          list.add(GearSpecItem(label: 'SPOD ROCKET', value: weightOrFloat!));
        }
        list.add(GearSpecItem(label: 'GROUNDBAIT', value: baitOrLure));
        break;
    }

    return list;
  }

  Map<String, dynamic> toJson() => {
        'slotIndex': slotIndex,
        'type': type.index,
        'rodName': rodName,
        'rodLength': rodLength,
        'rodImage': rodImage,
        'reel': reel,
        'line': line,
        'leader': leader,
        'weightOrFloat': weightOrFloat,
        'hook': hook,
        'baitOrLure': baitOrLure,
      };

  factory RodSlotData.fromJson(Map<String, dynamic> json) {
    return RodSlotData(
      slotIndex: json['slotIndex'] as int? ?? 1,
      type: json['type'] is int
          ? SetupType.values[json['type'] as int]
          : SetupType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => SetupType.spinning,
            ),
      rodName: json['rodName'] as String? ?? '',
      rodLength: json['rodLength'] as String? ?? '',
      rodImage: json['rodImage'] as String?,
      reel: json['reel'] as String?,
      line: json['line'] as String?,
      leader: json['leader'] as String?,
      weightOrFloat: json['weightOrFloat'] as String?,
      hook: json['hook'] as String?,
      baitOrLure: json['baitOrLure'] as String? ?? '',
    );
  }
}

class LoadoutModel {
  final String id;
  final String name;
  final List<RodSlotData> rods;

  const LoadoutModel({
    required this.id,
    required this.name,
    required this.rods,
  });

  String get subtitle =>
      '${rods.length} rod${rods.length > 1 ? "s" : ""} · Custom loadout';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rods': rods.map((r) => r.toJson()).toList(),
      };

  factory LoadoutModel.fromJson(Map<String, dynamic> json) {
    return LoadoutModel(
      id: json['id'] as String? ?? 'loadout_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] as String? ?? 'Custom Loadout',
      rods: (json['rods'] as List<dynamic>?)
              ?.map((r) => RodSlotData.fromJson(Map<String, dynamic>.from(r as Map)))
              .toList() ??
          [],
    );
  }
}
