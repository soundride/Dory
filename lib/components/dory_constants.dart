// 20.0
import 'package:flutter/material.dart';

const double regularSpace = 20.0;

// 40.0
const double largeSpace = 40.0;

// 10.0
const double smallSpace = 10.0;

// 48.0
const double submitButtonHeight = 48.0;

// all
// 20.0
const EdgeInsetsGeometry pagePadding = EdgeInsets.all(20.0);

// symmetric
// horizontal 6
// 패딩 값
const EdgeInsetsGeometry textFieldContentPadding =
    EdgeInsets.symmetric(horizontal: 6);

// symmetric
// horizontal: 20
// vertical: 10
// 하위 ('다음') 버튼의 아래 영역 패딩값.
const EdgeInsetsGeometry submitButtonBoxPadding = EdgeInsets.symmetric(
  horizontal: 20,
  // 히위 기종들의 화면 아래에 버튼이 달라붙는 현상을 막기 위해서 꼭 필요해
  vertical: 10,
);
