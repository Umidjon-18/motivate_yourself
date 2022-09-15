import 'package:flutter/material.dart';

class AllData {
  late String? bgImagePath;
  late List<String>? textList;
  late int? animationTypeIndex;
  late double? fontSize;
  late Color? textColor;
  AllData(
      {this.bgImagePath,
      this.textList,
      this.animationTypeIndex,
      this.fontSize,
      this.textColor});
}
