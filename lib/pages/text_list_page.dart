import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motivate_yourself/services/db_services.dart';

import '../constants/Constants.dart';

class TextListPage extends StatefulWidget {
  const TextListPage({Key? key}) : super(key: key);
  static const String id = 'settings_page';

  @override
  State<TextListPage> createState() => _TextListPageState();
}

class _TextListPageState extends State<TextListPage> with Constants {
  late List<String> textList;
  @override
  void initState() {
    super.initState();
    textList = DbServices().getAnimationTextListWithoutAnimation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    textList = DbServices().getAnimationTextListWithoutAnimation();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'text_list',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.w700),
        ).tr(),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: textList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              height: size.height * 0.04,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notes_outlined,
                        color: const Color(0xff1B7340),
                        size: size.height * 0.03,
                      ),
                      const SizedBox(width: 10),
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText(
                              textList[index].length > 40
                                  ? '${textList[index].substring(0, 35)}...'
                                  : textList[index],
                              textStyle: const TextStyle(color: Colors.white),
                              speed: const Duration(milliseconds: 100)),
                        ],
                        isRepeatingAnimation: true,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (textList.length > 1) {
                        DbServices().removeAnimationText(index);
                        setState(() {});
                      }
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red[900],
                      size: size.height * 0.025,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
