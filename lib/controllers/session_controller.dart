import 'dart:async';
import 'package:castlog/controllers/tackle_box_controller.dart';
import 'package:castlog/models/session_model.dart';
import 'package:castlog/models/setup_model.dart';
import 'package:castlog/models/waterway_model.dart';
import 'package:castlog/services/waterway_service.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  final WaterwayService _waterwayService = WaterwayService();

  // Observable active session
  final Rx<SessionModel?> activeSession = Rx<SessionModel?>(null);

  // Observable past sessions history
  final RxList<SessionModel> pastSessions = <SessionModel>[].obs;

  // Observable last completed session (for summary)
  final Rx<SessionModel?> lastCompletedSession = Rx<SessionModel?>(null);

  // Observable recent catches list (global across app)
  final RxList<CatchModel> catches = <CatchModel>[].obs;

  // Real-time timer
  final RxString formattedTimer = '00:00'.obs;
  Timer? _timer;

  List<WaterwayModel> get waterways => _waterwayService.getAllWaterways();

  @override
  void onInit() {
    super.onInit();
    _initDefaultSessionAndCatches();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _initDefaultSessionAndCatches() {
    // Initial sample catches
    catches.assignAll([
      CatchModel(
        id: 'catch_1',
        species: 'Common Carp',
        waterway: 'Emerald Lake - New York',
        weightKg: 8.2,
        lengthCm: 76,
        rodName: 'UL-CHUBER™ Deep Horizon',
        rodType: SetupType.carp,
        baitOrLure: 'Boilies Strawberry 20mm',
        image: 'https://wiki.fishingplanet.com/images/e/e6/Common_Carp.png',
        notes: 'Bite during morning peak right in deep water.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CatchModel(
        id: 'catch_2',
        species: 'Chain Pickerel',
        waterway: 'Emerald Lake - New York',
        weightKg: 2.4,
        lengthCm: 58,
        rodName: 'MagFin™ JigWinner',
        rodType: SetupType.spinning,
        baitOrLure: 'Shad 10 cm',
        image: 'https://wiki.fishingplanet.com/images/thumb/6/6c/Chain_Pickerel.png/300px-Chain_Pickerel.png',
        notes: 'Caught near the reed beds.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      ),
      CatchModel(
        id: 'catch_3',
        species: 'Walleye',
        waterway: 'Emerald Lake - New York',
        weightKg: 3.1,
        lengthCm: 64,
        rodName: 'MagFin™ JigWinner',
        rodType: SetupType.spinning,
        baitOrLure: 'Narrow Spoon 7g',
        image: 'https://wiki.fishingplanet.com/images/thumb/0/05/Walleye.png/300px-Walleye.png',
        notes: 'Deep structure bite.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
      ),
    ]);

    // Active session default
    final tackleController = Get.find<TackleBoxController>();
    final defaultLoadout = tackleController.loadouts.isNotEmpty
        ? tackleController.loadouts.first
        : const LoadoutModel(id: 'loadout_default', name: 'Emerald Lake Heavy', rods: []);

    final session = SessionModel(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      waterwayName: 'Emerald Lake - New York',
      waterwayRegion: 'North America',
      waterwayImage: 'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
      loadout: defaultLoadout,
      startTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 34)),
      catches: catches.toList(),
    );

    activeSession.value = session;
    _startTimer();

    // Initial sample past sessions
    pastSessions.assignAll([
      SessionModel(
        id: 'session_past_1',
        waterwayName: 'Emerald Lake - New York',
        waterwayRegion: 'North America',
        waterwayImage: 'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
        loadout: defaultLoadout,
        startTime: DateTime.now().subtract(const Duration(days: 2, hours: 3, minutes: 20)),
        endTime: DateTime.now().subtract(const Duration(days: 2)),
        isActive: false,
        catches: [
          CatchModel(
            id: 'catch_p1',
            species: 'Chain Pickerel',
            waterway: 'Emerald Lake - New York',
            weightKg: 2.1,
            lengthCm: 55,
            rodName: 'MagFin™ JigWinner',
            rodType: SetupType.spinning,
            baitOrLure: 'Shad 10 cm',
            image: 'https://wiki.fishingplanet.com/images/thumb/6/6c/Chain_Pickerel.png/300px-Chain_Pickerel.png',
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
          ),
          CatchModel(
            id: 'catch_p2',
            species: 'Walleye',
            waterway: 'Emerald Lake - New York',
            weightKg: 3.4,
            lengthCm: 66,
            rodName: 'MagFin™ JigWinner',
            rodType: SetupType.spinning,
            baitOrLure: 'Narrow Spoon 7g',
            image: 'https://wiki.fishingplanet.com/images/thumb/0/05/Walleye.png/300px-Walleye.png',
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
          ),
        ],
      ),
      SessionModel(
        id: 'session_past_2',
        waterwayName: 'Lone Star Lake - Texas',
        waterwayRegion: 'North America',
        waterwayImage: 'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
        loadout: defaultLoadout,
        startTime: DateTime.now().subtract(const Duration(days: 5, hours: 2, minutes: 10)),
        endTime: DateTime.now().subtract(const Duration(days: 5)),
        isActive: false,
        catches: [
          CatchModel(
            id: 'catch_p3',
            species: 'Spotted Bass',
            waterway: 'Lone Star Lake - Texas',
            weightKg: 1.8,
            lengthCm: 44,
            rodName: 'ValueSpin',
            rodType: SetupType.spinning,
            baitOrLure: 'Redworm',
            image: 'https://wiki.fishingplanet.com/images/thumb/7/7d/Spotted_Bass.png/300px-Spotted_Bass.png',
            timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
          ),
        ],
      ),
    ]);
  }

  void _startTimer() {
    _timer?.cancel();
    _updateTimerString();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimerString();
    });
  }

  void _updateTimerString() {
    final s = activeSession.value;
    if (s == null) {
      formattedTimer.value = '00:00';
      return;
    }
    formattedTimer.value = s.formattedDuration;
  }

  void startNewSession({
    required WaterwayModel waterway,
    required LoadoutModel loadout,
  }) {
    _timer?.cancel();

    final session = SessionModel(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      waterwayName: waterway.name,
      waterwayRegion: waterway.region.isNotEmpty ? waterway.region : waterway.locationCountry,
      waterwayImage: waterway.image.isNotEmpty
          ? waterway.image
          : 'https://wiki.fishingplanet.com/images/5/56/LoneStarLake.jpg',
      loadout: loadout,
      startTime: DateTime.now(),
      catches: [],
    );

    activeSession.value = session;
    _startTimer();
  }

  SessionModel? endCurrentSession() {
    final session = activeSession.value;
    if (session == null) return null;
    session.endTime = DateTime.now();
    session.isActive = false;
    _timer?.cancel();
    pastSessions.insert(0, session);
    lastCompletedSession.value = session;
    activeSession.value = null;
    formattedTimer.value = '00:00';
    return session;
  }

  void addCatch({
    required String species,
    required double weightKg,
    required double lengthCm,
    required RodSlotData rodSlot,
    String? image,
    String? notes,
  }) {
    final session = activeSession.value;
    final waterway = session?.waterwayName ?? 'Emerald Lake - New York';

    final newCatch = CatchModel(
      id: 'catch_${DateTime.now().millisecondsSinceEpoch}',
      species: species,
      waterway: waterway,
      weightKg: weightKg,
      lengthCm: lengthCm,
      rodName: rodSlot.rodName,
      rodType: rodSlot.type,
      baitOrLure: rodSlot.baitOrLure,
      image: image,
      notes: notes,
      timestamp: DateTime.now(),
      sessionId: session?.id,
    );

    catches.insert(0, newCatch);
    if (session != null) {
      session.catches.insert(0, newCatch);
      activeSession.refresh();
    }
  }

  void deleteCatch(String id) {
    catches.removeWhere((c) => c.id == id);
    if (activeSession.value != null) {
      activeSession.value!.catches.removeWhere((c) => c.id == id);
      activeSession.refresh();
    }
  }

  // Get species list available for current session waterway
  List<MapFishSpecies> getCurrentWaterwaySpecies() {
    final all = _waterwayService.getAllWaterways();
    if (all.isEmpty) return [];

    final session = activeSession.value;
    if (session == null) {
      return all.first.fishSpecies;
    }

    final match = _waterwayService.getWaterwayByName(session.waterwayName);
    if (match != null && match.fishSpecies.isNotEmpty) {
      return match.fishSpecies;
    }

    return all.first.fishSpecies;
  }
}
