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
        .where((gear) =>
            gear.category.toLowerCase() == 'lines' ||
            gear.category.toLowerCase().contains('line'))
        .toList();
  }

  List<GearModel> getLeaders() {
    if (!Hive.isBoxOpen('gears')) return [];
    return box.values
        .where((gear) =>
            gear.category.toLowerCase().contains('leader') ||
            gear.subCategory.toLowerCase().contains('leader') ||
            gear.name.toLowerCase().contains('leader'))
        .toList();
  }

  List<GearModel> getHooks(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];
    return box.values
        .where((gear) =>
            gear.category.toLowerCase().contains('hook') ||
            gear.subCategory.toLowerCase().contains('hook') ||
            gear.name.toLowerCase().contains('hook'))
        .toList();
  }

  List<GearModel> getWeightsOrFloats(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];

    return box.values.where((gear) {
      final cat = gear.category.toLowerCase();
      final sub = gear.subCategory.toLowerCase();
      final name = gear.name.toLowerCase();

      switch (type) {
        case SetupType.float:
          return cat.contains('float') ||
              sub.contains('float') ||
              cat.contains('bobber') ||
              name.contains('float') ||
              name.contains('bobber') ||
              name.contains('wagler');
        case SetupType.feeder:
          return cat.contains('feeder') ||
              sub.contains('feeder') ||
              cat.contains('sinker') ||
              sub.contains('sinker') ||
              name.contains('feeder') ||
              name.contains('sinker');
        case SetupType.carp:
          return cat.contains('sinker') ||
              sub.contains('sinker') ||
              name.contains('method feeder') ||
              name.contains('carp sinker') ||
              name.contains('sinker');
        case SetupType.spod:
          return cat.contains('spod') ||
              sub.contains('spod') ||
              name.contains('spod');
        default:
          return false;
      }
    }).toList();
  }

  List<GearModel> getBaitsOrLures(SetupType type) {
    if (!Hive.isBoxOpen('gears')) return [];

    return box.values.where((gear) {
      final cat = gear.category.toLowerCase();
      final sub = gear.subCategory.toLowerCase();

      switch (type) {
        case SetupType.spinning:
        case SetupType.casting:
          return cat.contains('lure') || sub.contains('lure');
        case SetupType.spod:
          return cat.contains('groundbait') ||
              sub.contains('groundbait') ||
              gear.name.toLowerCase().contains('spod mix');
        default:
          return cat.contains('bait') || sub.contains('bait');
      }
    }).toList();
  }
}
