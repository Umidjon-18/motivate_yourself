import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

mixin Constants {
  List<String> bgImagesList = [
    'assets/images/gif_beach.gif',
    'assets/images/gif_beach2.gif',
    'assets/images/gif_beach3.gif',
    'assets/images/gif_waterfall.gif',
    'assets/images/gif_waterfall2.gif',
    'assets/images/gif_waterfall3.gif',
    'assets/images/gif_waterfall4.gif',
    'assets/images/gif_snowing.gif',
    'assets/images/gif_horse.gif',
  ];
  var dropdownItems = ['normal', 'italic'];

  List<dynamic> animationTypes = [
    TyperAnimatedText('Typer Animation'),
    TypewriterAnimatedText('Typewriter Animation'),
    FadeAnimatedText('Fade Animation'),
    FlickerAnimatedText('Flicker Animation'),
    WavyAnimatedText('Wavy Animation'),
    RotateAnimatedText('Rotate Animation'),
  ];
  final ValueNotifier<int> checkedBgImage = ValueNotifier<int>(0);
  final ValueNotifier<int> checkedAnimation = ValueNotifier<int>(0);
  final ValueNotifier<String> checkedFontStyle = ValueNotifier<String>('normal');
}
