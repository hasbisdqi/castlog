import 'package:castlog/models/gear_model.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:hive/hive.dart';

class GearService {
  Box<GearModel>? _box;

  Box<GearModel> get box {
    _box ??= Hive.box<GearModel>('gears');
    return _box!;
  }

  List<GearModel> getAllGears() {
    if (!Hive.isBoxOpen('gears')) return [];
    return box.values.toList();
  }

  List<GearModel> getRodsByType(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];

    return box.values.where((gear) {
      if (gear.category.toLowerCase() != 'rods') return false;
      final sub = gear.subCategory.toLowerCase();
      switch (type) {
        case SetupType.spinning:
          return sub.contains('spinning');
        case SetupType.casting:
          return sub.contains('casting');
        case SetupType.float:
          return sub.contains('match') ||
              sub.contains('telescopic') ||
              sub.contains('float');
        case SetupType.feeder:
          return sub.contains('feeder') || sub.contains('bottom');
        case SetupType.carp:
          return sub.contains('carp');
        case SetupType.spod:
          return sub.contains('spod');
      }
    }).toList();
  }

  List<GearModel> getReels(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];

    return box.values.where((gear) {
      if (gear.category.toLowerCase() != 'reels') return false;
      final sub = gear.subCategory.toLowerCase();
      if (type == SetupType.casting) {
        return sub.contains('casting') || sub.contains('baitcast');
      }
      return sub.contains('spinning');
    }).toList();
  }

  List<GearModel> getLines() {
    if (!Hive.isBoxOpen('gears')) return [];
    return box.values
        .where((gear) => gear.category.toLowerCase() == 'lines')
        .toList();
  }

  List<GearModel> getLeaders() {
    if (!Hive.isBoxOpen('gears')) return [];
    return box.values
        .where((gear) =>
            gear.category.toLowerCase() != 'rods' &&
            (gear.subCategory.toLowerCase() == 'leaders' ||
                gear.category.toLowerCase() == 'rig' &&
                    gear.name.toLowerCase().contains('leader')))
        .toList();
  }

  List<GearModel> getHooks(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];
    return box.values
        .where((gear) => gear.category.toLowerCase() == 'hooks')
        .toList();
  }

  List<GearModel> getWeightsOrFloats(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];

    return box.values.where((gear) {
      if (gear.category.toLowerCase() == 'rods') return false;

      final cat = gear.category.toLowerCase();
      final sub = gear.subCategory.toLowerCase();
      final name = gear.name.toLowerCase();

      switch (type) {
        case SetupType.float:
          if (sub.contains('alarm') ||
              name.contains('bell') ||
              sub.contains('buoy') ||
              name.contains('buoy')) {
            return false;
          }

          return cat == 'bobbers and fishing alarm' ||
              sub.contains('bobber') ||
              sub.contains('waggler') ||
              sub.contains('slider');
        case SetupType.feeder:
          if (cat != 'sinker and feeders') return false;
          return sub.contains('feeder') || sub.contains('sinker');
        case SetupType.carp:
          if (cat != 'sinker and feeders') return false;
          return sub.contains('sinker') ||
              sub.contains('feeder') ||
              name.contains('flat') ||
              name.contains('method') ||
              name.contains('carp');
        case SetupType.spod:
          if (cat != 'sinker and feeders') return false;
          return sub.contains('spod') || name.contains('spod');
        default:
          return false;
      }
    }).toList();
  }

  List<GearModel> getBaitsOrLures(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];

    return box.values.where((gear) {
      if (gear.category.toLowerCase() == 'rods') return false;

      final cat = gear.category.toLowerCase();

      switch (type) {
        case SetupType.spinning:
        case SetupType.casting:
          return cat == 'lures';
        case SetupType.spod:
          return cat == 'groundbaits';
        default:
          return cat == 'baits';
      }
    }).toList();
  }
}
