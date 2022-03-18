import 'dart:io';
import 'package:dory/components/dory_constants.dart';
import 'package:dory/components/dory_page_route.dart';
import 'package:dory/pages/add/add_alarm_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();
  File? _medicineImage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: GestureDetector(
        // 키보드를 특정 액션에 맞춰서 닫히고 열리게 할 수 있는 코드야
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // 아래 wrap padding 을 줘서 텍스트 좌측 공간 여백을 더 준거야. 기존 코드에 패딩을  wrap  한거야
        // 아래 싱글차일드스크롤뷰 적용한 것이 안드로이드 폰에서 패디 영역 오버플로우 나왔을 경우 대응한거야
        child: SingleChildScrollView(
          child: Padding(
            padding: pagePadding,
            child: Column(
              // 아래 crossaxis 부분이 텍스트를 좌측 정렬로 해주는 부분이야
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // dory_constants 에서 사전에 정의해놓은 largespace 활용해서 어떤약이에요? 파트에 대한 스타일 정의
                // const SizedBox(height: largeSpace),
                Text(
                  '어떤 약이에요?',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: largeSpace),
                Center(
                  // 아래 메디슨이미지버튼에 대한 부분은 코드 최하단에 별도로 분리해놨어. 그쪽에서 불러온거야.
                  child: MedicineImageButton(
                    changeImageFile: (File? value) {
                      _medicineImage = value;
                    },
                  ),
                ),
                // 아래 코드에 보면 라지스페이지 + 레귤러스페이스를 더해주면 여백 공간을 더 줄 수 있어
                // 도리 콘스턴트스 파일에 보면, 레귤러와 라지스페이스의 값이 지정되어 있으므로, 60만큼 공간 준거야
                const SizedBox(height: largeSpace + regularSpace),
                Text(
                  '약 이름',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                TextFormField(
                  controller: _nameController,
                  maxLength: 20,
                  //아래 키보드 타입에 Textinputtype.email로 해주면 키보드 자판에 골뱅이가 등장할거야
                  keyboardType: TextInputType.text,
                  // 아래 인풋 액션은 엔터 눌렀을때 키보드 사라지는것과 동일해. '완료' 'done'이 키보드에 나와.
                  // done 말고도 많아. 커맨드+. 으로 찾아봐
                  textInputAction: TextInputAction.done,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: '"복용할 약 이름을 기입해주세요."',
                    hintStyle: Theme.of(context).textTheme.bodyText2,
                    // 아래 텍스트필드패딩도 도리 콘스턴트스에서 들어온거야
                    contentPadding: textFieldContentPadding,
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        // safearea로 감싸놓으면 아이폰 하단의 앱 닫는 실행하는 버튼과 노치쪽하고 스타일이 겹치지 않을거야.
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
              // onPressed: ,
              // '다음'이라는 글자에 스타일을 줄건데, 텍스트 쪽에 스타일을 주지 않고, 아래 style이라는 걸 별도로
              // 만든 이유는, elevatedbutton에서 갖고있는 텍스트 스타일하고 부딪히면서 검정색으로 글자가 표기되는
              // 오류가 발생될 수 있기 때문이야.
              style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1),
              child: Text('다음'),
            ),
          ),
        ),
      ),
    );
  }

  void _onAddAlarmPage() {
    Navigator.push(
      context,
      // 여기가 페이드 효과를 마련하는 곳
      FadePageRoute(
        page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text,
        ),
      ),
    );
  }
}

class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({Key? key, required this.changeImageFile})
      : super(key: key);

  final ValueChanged<File?> changeImageFile;

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        onPressed: _showBottomSheet,
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        child: _pickedImage == null
            ? const Icon(
                CupertinoIcons.photo_camera_solid,
                size: 30,
                color: Colors.white,
              )
            : CircleAvatar(
                foregroundImage: FileImage(_pickedImage!),
                radius: 40,
              ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
            onPressedCamera: () => _onPressed(ImageSource.camera),
            onPressedGallery: () => _onPressed(ImageSource.gallery),
          );
        });
  }

  void _onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changeImageFile(_pickedImage);
        });
      }
      Navigator.maybePop(context);
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet(
      {Key? key, required this.onPressedCamera, required this.onPressedGallery})
      : super(key: key);

  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: onPressedCamera,
              child: const Text('카메라로 촬영'),
            ),
            TextButton(
              onPressed: onPressedGallery,
              child: const Text('앨범에서 가져오기'),
            ),
          ],
        ),
      ),
    );
  }
}
