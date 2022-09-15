import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:motivate_yourself/constants/Constants.dart';
import 'package:motivate_yourself/pages/settings_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../services/db_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Constants {
  late TextEditingController animationSpeedController;
  DateTime pre_backpress = DateTime.now();
  @override
  void initState() {
    super.initState();
    animationSpeedController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
       onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);

        final cantExit = timegap >= const Duration(seconds: 1);

        pre_backpress = DateTime.now();

        if (cantExit) {
          //show snackbar
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: "exit".tr(),
            ),
          );
          return false; // false will do nothing when back press
        } else {
          return true; // true will exit the app
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 16 / 375),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  splashRadius: 30,
                  onPressed: showDialog,
                  icon: const Icon(
                    MaterialIcons.speed,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                const Text(
                  'app_title',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                    fontSize: 22,
                  ),
                ).tr(),
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SettingsPage.id);
                  },
                  icon: const Icon(
                    CupertinoIcons.settings,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          // #for full background image
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(DbServices().getImage() ?? bgImagesList[0]),
                  fit: BoxFit.cover),
            ),
            // #for background gradient
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.4),
                    Colors.black.withOpacity(.3),
                    Colors.black.withOpacity(.3),
                    Colors.black.withOpacity(.4),
                  ],
                ),
              ),
              child: Center(
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: DbServices().getAnimationTextList(),
                  isRepeatingAnimation: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDialog() {
    var animationSpeed = DbServices().getAnimationSpeed();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("animation_speed").tr(),
          content: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: animationSpeed.toDouble() * 2.5,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 0,
                              endValue: animationSpeed.toDouble() * 1.1,
                              color: Colors.green,
                              startWidth: 10,
                              endWidth: 10),
                          GaugeRange(
                              startValue: animationSpeed.toDouble() * 1.1,
                              endValue: animationSpeed.toDouble() * 2,
                              color: Colors.orange,
                              startWidth: 10,
                              endWidth: 10),
                          GaugeRange(
                              startValue: animationSpeed.toDouble() * 2,
                              endValue: animationSpeed.toDouble() * 2.5,
                              color: Colors.red,
                              startWidth: 10,
                              endWidth: 10)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(value: animationSpeed.toDouble())
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Text(
                                animationSpeed.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              angle: 90,
                              positionFactor: 0.5),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 100,
                  child: TextField(
                    controller: animationSpeedController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'select_animation_speed'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                "cancel",
                style: TextStyle(color: Colors.black),
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                "update",
                style: TextStyle(color: Colors.black),
              ).tr(),
              onPressed: () {
                if (animationSpeedController.text.trim().isNotEmpty) {
                  DbServices().storeAnimationSpeed(
                      int.parse(animationSpeedController.text.trim()));
                  animationSpeedController.text = '';
                  setState(() {});
                Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
