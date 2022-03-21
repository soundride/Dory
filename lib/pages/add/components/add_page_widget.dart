import 'package:dory/components/dory_constants.dart';
import 'package:flutter/material.dart';

class AddPageBody extends StatelessWidget {
  const AddPageBody({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 키보드를 특정 액션에 맞춰서 닫히고 열리게 할 수 있는 코드야
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      // 아래 wrap padding 을 줘서 텍스트 좌측 공간 여백을 더 준거야. 기존 코드에 패딩을  wrap  한거야
      // 아래 싱글차일드스크롤뷰 적용한 것이 안드로이드 폰에서 패딩 영역 오버플로우 나왔을 경우 대응한거야
      child: Padding(
        padding: pagePadding,
        child: Column(
          // 아래 crossaxis 부분이 텍스트를 좌측 정렬로 해주는 부분이야
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton(
      {Key? key, required this.onPressed, required this.text})
      : super(key: key);

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // safearea로 감싸놓으면 아이폰 하단의 앱 닫는 실행하는 버튼과 노치쪽하고 스타일이 겹치지 않을거야.
      child: Padding(
        padding: submitButtonBoxPadding,
        child: SizedBox(
          height: submitButtonHeight,
          child: ElevatedButton(
            // onPressed: ,
            // '다음'이라는 글자에 스타일을 줄건데, 텍스트 쪽에 스타일을 주지 않고, 아래 style이라는 걸 별도로
            // 만든 이유는, elevatedbutton에서 갖고있는 텍스트 스타일하고 부딪히면서 검정색으로 글자가 표기되는
            // 오류가 발생될 수 있기 때문이야.
            // 아래 onpressed 는 기존에 애드 메디슨 페이지에 있던 것을 가져와서 컴포넌트 구조로 변경해준거야. 위젯 형태로
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
