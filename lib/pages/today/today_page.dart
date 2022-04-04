import 'dart:io';

import 'package:dory/components/dory_constants.dart';
import 'package:dory/components/dory_page_route.dart';
import 'package:dory/main.dart';
import 'package:dory/models/medicine_alarm.dart';
import 'package:dory/pages/today/tody_empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/medicine.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 복용 할 약은?',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regularSpace),
        // const Divider(height: 1, thickness: 2.0),
        // 리스트뷰와 리스트타일은 꼭 함께 따라다니는 편이야
        // 하지만 우리는 리스트타일을 쓰진 않을거지만, 리스트타일은 커스텀 디자인 넣기에 불편해서 우린 하나씩 넣을거야
        // 아래 디바이더는 각 리스트들이 한 행씩 끊어져 보이게끔 해주는거야. 디바이더에는 높이값이 필요
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
        // const Divider(height: 1, thickness: 2.0),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return const TodayEmpty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(MedicineAlarm(
          medicine.id,
          medicine.name,
          medicine.imagePath,
          alarm,
          medicine.key,
        ));
      }
    }

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
              return MedicineListTile(
                medicineAlarm: medicineAlarms[index],
              );
            },
            // 세퍼레이터빌더는 각 리스트 행 사이 간격을 먹여줄 수 있어
            separatorBuilder: (context, index) {
              return const Divider(
                height: regularSpace,
              );
            },
          ),
        ),
        const Divider(height: 1, thickness: 1.0),
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
        CupertinoButton(
          // 쿠퍼티노버튼은 기본적으로 패딩을 갖고 있어서, 꽉채우고 싶으면 아래 패딩 엣지인센츠 제로 먹여.
          padding: EdgeInsets.zero,
          onPressed: medicineAlarm.imagePath == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      page: ImageDetailPage(medicineAlarm: medicineAlarm),
                    ),
                  );
                },
          child: CircleAvatar(
            radius: 40,
            foregroundImage: medicineAlarm.imagePath == null
                ? null
                : FileImage(
                    File(medicineAlarm.imagePath!),
                  ),
          ),
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🕑${medicineAlarm.alarmTime}', style: textStyle),
              const SizedBox(height: 6),
              // 밑에 Wrap으로 영역 씌워주면 텍스트 길어졌을때 다음줄로 내려갈거야
              Wrap(
                // 아래 wrapcross 센터는 wrap으로 둘러쌓인 영역인 경우에서 사용해 cross악시스 처럼
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${medicineAlarm.name},', style: textStyle),
                  TileActionButton(
                    onTap: () {},
                    title: '지금',
                  ),
                  Text('|', style: textStyle),
                  TileActionButton(
                    onTap: () {},
                    title: '아까',
                  ),
                  Text('먹었어요!', style: textStyle),
                ],
              )
            ],
          ),
        ),
        CupertinoButton(
          onPressed: () {
            medicineRepository.deleteMedicine(medicineAlarm.key);
          },
          child: const Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ],
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
        child: Image.file(
          File(medicineAlarm.imagePath!),
        ),
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.w500);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // 아래 보면 copyWith가 있는데, 이건 특정 영역에만 특정 스타일을 주고 싶을때 쓰는거야.
        // 단, 너러블한 것이 있는 경우에는 ? 물음표를 붙여주도록 해
        child: Text(
          title,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
