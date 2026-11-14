import 'package:castlog/models/fish_model.dart';
import 'package:castlog/models/gear_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dataset_initializer.dart';

Future<void> initializeDatabase() async {
  await Hive.initFlutter();

  Hive.registerAdapter(FishModelAdapter());
  Hive.registerAdapter(GearModelAdapter());

  await DatasetInitializer.initialize();
}