// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/medicine.dart';

class DoryHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());

    await Hive.openBox<Medicine>(DoryHiveBox.medicine);
  }
}

class DoryHiveBox {
  static const String medicine = 'medicine';
}
