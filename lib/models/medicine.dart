import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 1)
class Medicine {
  Medicine({
    required this.name,
    required this.imagePath,
    required this.alarms,
    required this.id,
  });

  @HiveField(0)
  final int
      id; //unique ai, UUID, millisecondsSinceEpoch 이렇게 상품 아이디를 설정하곤해. 우린 이번에 unique ai를 쓸거야. 상품 뒤에 숫자 붙어서 1씩 증가되는,random은 잘 안써

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imagePath;

  @HiveField(3)
  final List<String> alarms;

  @override
  String toString() {
    return '{id: $id, name:$name, imagePath: $imagePath, alarms: $alarms}';
  }
}
