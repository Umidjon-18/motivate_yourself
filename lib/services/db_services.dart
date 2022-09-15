import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbServices {
  var settingsBox = Hive.box('settings_box');
  storeImage(String imagePath) {
    settingsBox.put('image', imagePath);
  }

  String? getImage() {
    return settingsBox.get('image');
  }

  void storeAnimationSpeed(int speed) {
    settingsBox.put('animation_speed', speed);
  }

  int getAnimationSpeed() {
    return settingsBox.get('animation_speed') ?? 40;
  }

  void storeStyle(double fontSize, String textColor, String fontStyle) {
    settingsBox.put('textStyle', [fontSize, textColor, fontStyle]);
  }

  TextStyle getStyle() {
    var result = settingsBox.get('textStyle') ?? [40.0, '0xffffffff', 'normal'];
    return TextStyle(
        fontSize: result[0],
        color: Color(int.parse(result[1])),
        fontStyle: result[2] == 'normal' ? FontStyle.normal : FontStyle.italic,
        fontWeight: FontWeight.bold);
  }

  void storeAnimationText(String text, int animationIndex) {
    List textList = settingsBox.get('text_list') ??
        [
          '0-Assalomu alaykum',
        ];
    textList.add('$animationIndex-${text.trim()}');
    settingsBox.put('text_list', textList);
  }

  void removeAnimationText(int animationIndex) {
    List textList = settingsBox.get('text_list') ??
        [
          '0-Assalomu alaykum',
        ];
    textList.removeAt(animationIndex);
    settingsBox.put('text_list', textList);
  }

  List<AnimatedText> getAnimationTextList() {
    List textList = settingsBox.get('text_list') ??
        [
          '0-Assalomu alaykum',
        ];
    List<AnimatedText> animList = [];
    var currentStyle = getStyle();
    var currentSpeed = Duration(milliseconds: getAnimationSpeed());
    for (var item in textList) {
      var animIndex = item[0];
      var animText = item.toString().substring(2);
      switch (animIndex) {
        case "0":
          animList.add(TyperAnimatedText(animText,
              textStyle: currentStyle, speed: currentSpeed));
          break;
        case "1":
          animList.add(TypewriterAnimatedText(animText,
              textStyle: currentStyle, speed: currentSpeed));
          break;
        case "2":
          animList.add(FadeAnimatedText(animText,
              textStyle: currentStyle, duration: currentSpeed));
          break;
        case "3":
          animList.add(FlickerAnimatedText(animText,
              textStyle: currentStyle, speed: currentSpeed));
          break;
        case "4":
          animList.add(WavyAnimatedText(animText,
              textStyle: currentStyle, speed: currentSpeed));
          break;
        case "5":
          animList.add(RotateAnimatedText(animText,
              textStyle: currentStyle, duration: currentSpeed));
          break;

        default:
      }
    }
    return animList;
  }

  List<String> getAnimationTextListWithoutAnimation() {
    List textList = settingsBox.get('text_list') ??
        [
          '0-Assalomu alaykum',
        ];
    List<String> animList = [];
    for (var item in textList) {
      var animText = item.toString().substring(2);
      animList.add(animText);
    }
    return animList;
  }
}
