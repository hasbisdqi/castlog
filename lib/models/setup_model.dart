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
}
