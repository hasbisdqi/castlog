import 'package:castlog/models/gear_model.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:castlog/services/gear_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditableRodSlot {
  final int id;
  SetupType type;
  String rodName;
  String rodLength;
  String? rodImage;
  String? reel;
  String? line;
  String? leader;
  String? weightOrFloat;
  String? hook;
  String baitOrLure;

  EditableRodSlot({
    required this.id,
    this.type = SetupType.spinning,
    this.rodName = '',
    this.rodLength = '2.4 m',
    this.rodImage,
    this.reel,
    this.line,
    this.leader,
    this.weightOrFloat,
    this.hook,
    this.baitOrLure = '',
  });

  RodSlotData toRodSlotData(int slotIndex) {
    return RodSlotData(
      slotIndex: slotIndex,
      type: type,
      rodName: rodName.isEmpty ? '${type.label} Rod' : rodName,
      rodLength: rodLength,
      rodImage: rodImage,
      reel: reel,
      line: line,
      leader: leader,
      weightOrFloat: weightOrFloat,
      hook: hook,
      baitOrLure: baitOrLure.isEmpty ? 'Standard Bait' : baitOrLure,
    );
  }
}

class TackleBoxController extends GetxController {
  final GearService _gearService = GearService();

  // Observable loadout list
  final RxList<LoadoutModel> loadouts = <LoadoutModel>[].obs;

  // Form states
  final TextEditingController nameController = TextEditingController();
  final RxList<EditableRodSlot> formRodSlots = <EditableRodSlot>[].obs;
  String? editingLoadoutId;

  int _slotCounter = 0;

  @override
  void onInit() {
    super.onInit();
    _loadDefaultLoadouts();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void _loadDefaultLoadouts() {
    loadouts.assignAll([
      const LoadoutModel(
        id: 'loadout_1',
        name: 'Emerald Lake Heavy Loadout',
        rods: [
          RodSlotData(
            slotIndex: 1,
            type: SetupType.carp,
            rodName: 'UL-CHUBER™ Deep Horizon',
            rodLength: '4.0 m',
            rodImage:
                'https://wiki.fishingplanet.com/images/c/c9/DeepHorizon.png',
            reel: 'Leviathan 9000',
            line: 'Braid 0.28 mm',
            leader: 'Carp Camo 0.35',
            weightOrFloat: 'Method Feeder 100g',
            hook: '#4/0 Hair Rig',
            baitOrLure: 'Boilies Strawberry 20mm',
          ),
          RodSlotData(
            slotIndex: 2,
            type: SetupType.spod,
            rodName: 'UL-CHUBER™ Power Launcher Spod',
            rodLength: '3.6 m',
            rodImage: 'https://wiki.fishingplanet.com/images/c/cf/5902.png',
            reel: 'UL-CHUBER™ Griffon Spod',
            line: 'Braid 0.24 mm',
            leader: null,
            weightOrFloat: 'Large Spod Rocket',
            hook: null,
            baitOrLure: 'Sweet Corn & Hemp Mix',
          ),
        ],
      ),
      const LoadoutModel(
        id: 'loadout_2',
        name: 'Predator Hunter Loadout',
        rods: [
          RodSlotData(
            slotIndex: 1,
            type: SetupType.spinning,
            rodName: 'MagFin™ JigWinner',
            rodLength: '2.7 m',
            rodImage:
                'https://wiki.fishingplanet.com/images/c/ce/JigWinner.png',
            reel: 'Vortex 4000',
            line: 'Braid 0.18 mm',
            leader: 'Titanium Leader 0.25',
            weightOrFloat: null,
            hook: null,
            baitOrLure: 'Shad 10 cm + JigHead 14g',
          ),
          RodSlotData(
            slotIndex: 2,
            type: SetupType.casting,
            rodName: 'MagFin™ BassCaster',
            rodLength: '2.2 m',
            rodImage:
                'https://wiki.fishingplanet.com/images/3/35/BassCaster.png',
            reel: 'Helios 3000 Cast',
            line: 'Fluoro 0.28 mm',
            leader: 'Fluorocarbon 0.30',
            weightOrFloat: null,
            hook: null,
            baitOrLure: 'Crankbait Deep Runner 2m',
          ),
        ],
      ),
    ]);
  }

  // Gear options from Hive
  List<GearModel> getRods(SetupType type) => _gearService.getRodsByType(type);
  List<GearModel> getReels(SetupType type) => _gearService.getReels(type);
  List<GearModel> getLines() => _gearService.getLines();
  List<GearModel> getLeaders() => _gearService.getLeaders();
  List<GearModel> getHooks(SetupType type) => _gearService.getHooks(type);
  List<GearModel> getWeightsOrFloats(SetupType type) =>
      _gearService.getWeightsOrFloats(type);
  List<GearModel> getBaitsOrLures(SetupType type) =>
      _gearService.getBaitsOrLures(type);

  void startCreateLoadout() {
    editingLoadoutId = null;
    nameController.text = '';
    formRodSlots.clear();
    _slotCounter = 0;
    addRodSlot();
  }

  void startEditLoadout(LoadoutModel loadout) {
    editingLoadoutId = loadout.id;
    nameController.text = loadout.name;
    formRodSlots.clear();
    _slotCounter = 0;

    for (final rod in loadout.rods) {
      _slotCounter++;
      formRodSlots.add(EditableRodSlot(
        id: _slotCounter,
        type: rod.type,
        rodName: rod.rodName,
        rodLength: rod.rodLength,
        rodImage: rod.rodImage,
        reel: rod.reel,
        line: rod.line,
        leader: rod.leader,
        weightOrFloat: rod.weightOrFloat,
        hook: rod.hook,
        baitOrLure: rod.baitOrLure,
      ));
    }
  }

  void addRodSlot() {
    if (formRodSlots.length >= 4) return;
    _slotCounter++;
    final defaultType = SetupType.spinning;
    final availableRods = getRods(defaultType);

    formRodSlots.add(EditableRodSlot(
      id: _slotCounter,
      type: defaultType,
      rodName: availableRods.isNotEmpty ? availableRods.first.name : 'MagFin™ JigWinner',
      rodImage: availableRods.isNotEmpty ? availableRods.first.image : null,
      rodLength: '2.4 m',
      baitOrLure: 'Shad 10 cm',
    ));
  }

  void removeRodSlot(int id) {
    if (formRodSlots.length <= 1) return;
    formRodSlots.removeWhere((slot) => slot.id == id);
  }

  void onSlotTypeChanged(EditableRodSlot slot, SetupType newType) {
    slot.type = newType;
    final rods = getRods(newType);
    if (rods.isNotEmpty) {
      slot.rodName = rods.first.name;
      slot.rodImage = rods.first.image;
    } else {
      slot.rodName = '${newType.label} Rod';
      slot.rodImage = null;
    }
    slot.weightOrFloat = null;
    slot.hook = null;
    formRodSlots.refresh();
  }

  void onSlotRodChanged(EditableRodSlot slot, String rodName) {
    slot.rodName = rodName;
    final rods = getRods(slot.type);
    final match = rods.firstWhereOrNull((r) => r.name == rodName);
    if (match != null) {
      slot.rodImage = match.image;
    }
    formRodSlots.refresh();
  }

  bool saveLoadout() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a loadout name',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (formRodSlots.isEmpty) {
      Get.snackbar('Validation Error', 'Add at least one rod to your loadout',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final newRods = formRodSlots.asMap().entries.map((entry) {
      return entry.value.toRodSlotData(entry.key + 1);
    }).toList();

    if (editingLoadoutId != null) {
      final index = loadouts.indexWhere((l) => l.id == editingLoadoutId);
      if (index != -1) {
        loadouts[index] = LoadoutModel(
          id: editingLoadoutId!,
          name: name,
          rods: newRods,
        );
      }
    } else {
      loadouts.add(LoadoutModel(
        id: 'loadout_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        rods: newRods,
      ));
    }

    return true;
  }
}
