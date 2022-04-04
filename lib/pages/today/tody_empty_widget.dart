import 'dart:html';

import 'package:dory/components/dory_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayEmpty extends StatelessWidget {
  const TodayEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(child: Text('추가된 약이 없습니다.')),
          SizedBox(height: smallSpace),
          Text('약을 추가해 주세요.'),
          SizedBox(height: smallSpace),
          Icon(CupertinoIcons.arrow_down),
          SizedBox(height: largeSpace),
        ],
      ),
    );
  }
}
