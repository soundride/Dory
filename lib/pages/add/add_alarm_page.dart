import 'dart:io';

import 'package:dory/components/dort_widgets.dart';
import 'package:dory/components/dory_colors.dart';
import 'package:dory/components/dory_constants.dart';
import 'package:dory/models/medicine.dart';
import 'package:dory/pages/add/add_medicinepage.dart';
import 'package:dory/services/add_medicine_service.dart';
import 'package:dory/services/dory_file_service.dart';
import 'package:dory/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage({
    Key? key,
    required this.medicineImage,
    required this.medicineName,
  }) : super(key: key);

  final File? medicineImage;
  final String medicineName;

  final service = AddMedicineService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            '매일 복약 잊지 말아요!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: largeSpace),
          Expanded(
            child: AnimatedBuilder(
              animation: service,
              builder: (context, _) {
                return ListView(
                  children: alarmWidgets,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          bool result = false;

          // 1. add alarm
          for (var alarm in service.alarms) {
            result = await notification.addNotifcication(
              medicineId: medicineRepository.newId,
              alarmTimeStr: alarm,
              title: '$alarm 약 먹을 시간이에요',
              body: '$medicineName 복약했다고 알려주세요',
            );
          }
          if (!result) {
            return showPermissionDenied(context, permission: '알람');
          }

          // 2. save image (local dir)
          String? imageFilePath;
          if (medicineImage != null) {
            imageFilePath = await saveImageToLocalDirectory(medicineImage!);
          }
          // 3. add medicine model (local DB, hive)
          final medicine = Medicine(
            id: medicineRepository.newId,
            name: medicineName,
            imagePath: imageFilePath,
            alarms: service.alarms.toList(),
          );
          medicineRepository.addMedicine(medicine);

          // 자료 작성이 끝났을 때 페이지를 끄고 뒤로 이동될 수 있도록 하는 코드가 네비게이터 팝인데
          // 네비게이터팝을 몇번씩 찍어서 하나씩 뒤로 보낼 수 있지만, 한번에 보낼 수 있는게 아래코드야
          // Navigator.pop(context);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        text: '완료',
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(
      service.alarms.map(
        (alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        ),
      ),
    );
    children.add(
      AddAlarmButton(
        service: service,
      ),
    );
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.time,
    required this.service,
  }) : super(key: key);

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              service.removeAlarm(time);
            },
            icon: const Icon(CupertinoIcons.minus_circle),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.subtitle2,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TimePickerBottomSheet(
                    initialTime: time,
                    service: service,
                  );
                },
              );
            },
            child: Text(time),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TimePickerBottomSheet extends StatelessWidget {
  TimePickerBottomSheet({
    Key? key,
    required this.initialTime,
    required this.service,
  }) : super(key: key);

  final String initialTime;
  final AddMedicineService service;
  DateTime? _setDateTime;

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              _setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDateTime,
          ),
        ),
        const SizedBox(height: regularSpace),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                    primary: Colors.white,
                    onPrimary: DoryColors.primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
              ),
            ),
            const SizedBox(width: smallSpace),
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                  ),
                  onPressed: () {
                    service.setAlarm(
                      prevTime: initialTime,
                      setTime: _setDateTime ?? initialDateTime,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('선택'),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key,
    required this.service,
  }) : super(key: key);

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1,
      ),
      onPressed: service.addNowAlarm,
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Icon(CupertinoIcons.plus_circle_fill),
          ),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          ),
        ],
      ),
    );
  }
}
