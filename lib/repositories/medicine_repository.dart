import 'dart:developer';

import 'package:dory/repositories/dory_hive.dart';
import 'package:hive/hive.dart';

import 'package:dory/models/medicine.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  Box<Medicine> get medicineBox {
    _medicineBox ??= Hive.box<Medicine>(DoryHiveBox.medicine);
    return _medicineBox!;
    // 위와 동일 코드는 아래와 같아
    // if(_medicineBox == null) {
    // _medicineBox = Hive.box<Medicine>(DoryHiveBox.medicine);}
    // 메디슨박스가 널값이면 아래와 같이 수행해줘. 그런데 아니면? 을 나타내는 방식이 위에 ??= 방식이야.
  }

  void addMedicine(Medicine medicine) async {
    int key = await medicineBox.add(medicine);

    log('[addMedicine] add (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);

    log('[deleteMedicineß] delete (key:$key)');
    log('result ${medicineBox.values.toList()}');
  }

  void updateMedicine({
    required int key,
    required Medicine medicine,
  }) async {
    await medicineBox.put(key, medicine);

    log('[updateMedicine] update (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  int get newId {
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}
