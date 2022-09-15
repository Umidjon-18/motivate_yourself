import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:motivate_yourself/pages/home_page.dart';
import 'package:motivate_yourself/pages/text_list_page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/Constants.dart';
import '../services/db_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const String id = 'text_list_page';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with Constants {
  late TextEditingController animationTextController;
  late TextEditingController textfieldController;
  late TextEditingController fontSizeController;
  late Color currentColor;

  DateTime pre_backpress = DateTime.now();
  @override
  void initState() {
    super.initState();
    animationTextController = TextEditingController();
    textfieldController = TextEditingController();
    fontSizeController = TextEditingController();
    fontSizeController.text = DbServices().getStyle().fontSize.toString();
    currentColor = DbServices().getStyle().color ?? Colors.white;
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
            margin: EdgeInsets.symmetric(horizontal: size.width * 10 / 375),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, HomePage.id);
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(
                      color: Color(0xff007AFF),
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.4,
                      fontSize: 17,
                    ),
                  ).tr(),
                ),
                const Text(
                  'settings',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ).tr(),
                TextButton(
                  onPressed: () {
                    var tempSize = double.parse(fontSizeController.text);
                    tempSize = tempSize < 15
                        ? 15.0
                        : tempSize > 60
                            ? 60.0
                            : tempSize;
                    DbServices().storeStyle(
                        tempSize,
                        currentColor.toString().substring(6, 16),
                        checkedFontStyle.value);

                    Navigator.pushReplacementNamed(context, HomePage.id);
                  },
                  child: const Text(
                    'save',
                    style: TextStyle(
                      color: Color(0xff007AFF),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      fontSize: 17,
                    ),
                  ).tr(),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'motivation_text',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white),
                ).tr(),
                const SizedBox(height: 2),
                Container(
                  width: double.infinity,
                  height: size.height * 0.22,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.22,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        autofocus: false,
                        autocorrect: false,
                        controller: animationTextController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 8,
                        decoration: InputDecoration.collapsed(
                            hintText: "textfield_hint".tr(),
                            hintStyle: TextStyle(color: Colors.grey[500])),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      // #select animation
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return ValueListenableBuilder(
                                  builder: (BuildContext context, value,
                                      Widget? child) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        color: Colors.blueGrey[900],
                                        height: size.height * 0.6,
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: ListView.builder(
                                          itemCount: animationTypes.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                checkedAnimation.value = index;
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: size.height * 0.08,
                                                margin: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: checkedAnimation
                                                                    .value ==
                                                                index
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                                size:
                                                                    size.width *
                                                                        0.1,
                                                              )
                                                            : null,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 7,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left:
                                                              size.width * 0.03,
                                                        ),
                                                        child: DefaultTextStyle(
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.06,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          child:
                                                              AnimatedTextKit(
                                                            animatedTexts: [
                                                              animationTypes[
                                                                  index],
                                                            ],
                                                            repeatForever: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  valueListenable: checkedAnimation,
                                );
                              });
                        },
                        child: Container(
                          width: double.infinity,
                          height: size.height * 0.05,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.style,
                                    color: Colors.green[500],
                                    size: size.height * 0.03,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'select_animation',
                                    style: TextStyle(color: Colors.white),
                                  ).tr(),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey[500],
                                size: size.height * 0.018,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      GestureDetector(
                        onTap: () {
                          try {
                            var tempText = animationTextController.text.trim();
                            if (tempText.isNotEmpty) {
                              DbServices().storeAnimationText(
                                  tempText, checkedAnimation.value);
                              animationTextController.text = '';
                              checkedAnimation.value = 0;
                              setState(() {});
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.LEFTSLIDE,
                                headerAnimationLoop: false,
                                dialogType: DialogType.SUCCES,
                                title: 'success'.tr(),
                                desc: 'success_text'.tr(),
                                btnOkIcon: Icons.check_circle,
                              ).show();
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                headerAnimationLoop: false,
                                animType: AnimType.TOPSLIDE,
                                closeIcon:
                                    const Icon(Icons.close_fullscreen_outlined),
                                title: 'warning'.tr(),
                                desc: 'warning_text'.tr(),
                                btnOkText: 'ok'.tr(),
                                btnOkOnPress: () {},
                              ).show();
                            }
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.RIGHSLIDE,
                              headerAnimationLoop: true,
                              title: 'error'.tr(),
                              desc: 'error_text'.tr(),
                              btnOkOnPress: () {},
                              btnOkColor: Colors.red,
                            ).show();
                          }
                        },
                        child: Container(
                          height: size.height * 0.06,
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.add_to_photos,
                                color: Colors.green[400],
                                size: size.height * 0.03,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'add_text',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ).tr(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // #language change
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Container(
                              color: Colors.blueGrey[900],
                              height: size.height * 0.3,
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: ListView(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .setLocale(const Locale('uz', 'UZ'));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: size.height * 0.08,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                    'assets/images/ic_uzb2.png'),
                                                width: size.height * 0.03,
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                'language_one',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22),
                                              ).tr(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .setLocale(const Locale('ru', 'RU'));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: size.height * 0.08,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                    'assets/images/ic_rus2.png'),
                                                width: size.height * 0.03,
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                'language_two',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22),
                                              ).tr(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .setLocale(const Locale('en', 'US'));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: size.height * 0.08,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                    'assets/images/ic_usa2.png'),
                                                width: size.height * 0.03,
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                'language_three',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22),
                                              ).tr(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.05,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                              CupertinoIcons.globe,
                              color: Colors.grey[400],
                              size: size.height * 0.03,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'change_language',
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[500],
                          size: size.height * 0.018,
                        ),
                      ],
                    ),
                  ),
                ),
                // #background image change
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ValueListenableBuilder(
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      child: Container(
                                        width: double.infinity,
                                        height: size.height * 0.04,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.green[400],
                                              size: size.height * 0.03,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'add_image',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: size.width * 0.04,
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.blueGrey[900],
                                      height: size.height * 0.45,
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: GridView.builder(
                                        itemCount: bgImagesList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              DbServices().storeImage(
                                                  bgImagesList[index]);
                                              checkedBgImage.value = index;
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      bgImagesList[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: checkedBgImage.value ==
                                                      index
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.green[800],
                                                      size: size.width * 0.15,
                                                    )
                                                  : null,
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            valueListenable: checkedBgImage,
                          );
                        });
                  },
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.05,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                              Icons.image,
                              color: Colors.blue[400],
                              size: size.height * 0.03,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'change_background_image',
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[500],
                          size: size.height * 0.018,
                        ),
                      ],
                    ),
                  ),
                ),

                // #change font style
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ValueListenableBuilder(
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return SingleChildScrollView(
                                child: Container(
                                  color: Colors.grey[900],
                                  height: size.height * 0.55,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.lock),
                                        title: Text(
                                          'Font Size',
                                          style: TextStyle(
                                              fontSize: size.width * 0.05,
                                              color: Colors.white),
                                        ),
                                        trailing: SizedBox(
                                          width: size.width * 0.25,
                                          child: TextField(
                                            controller: fontSizeController,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.width * 0.04,
                                            ),
                                            decoration: const InputDecoration(
                                              labelText: "Size",
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            MaterialIcons.format_color_text),
                                        title: Text(
                                          'Font Style',
                                          style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: Colors.white),
                                        ),
                                        trailing: SizedBox(
                                          width: size.width * 0.25,
                                          child: DropdownButton(
                                            dropdownColor: Colors.black,
                                            value: checkedFontStyle.value,
                                            style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                color: Colors.white),
                                            iconSize: 0,
                                            items: dropdownItems
                                                .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text(item),
                                                    ))
                                                .toList(),
                                            onChanged: (String? value) {
                                              checkedFontStyle.value = value!;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(MaterialIcons.palette),
                                        title: Text(
                                          'Color',
                                          style: TextStyle(
                                              fontSize: size.width * 0.05,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: size.width * 0.03,
                                            right: size.width * 0.03,
                                            top: size.width * 0.03,
                                            bottom: size.width * 0.2,
                                          ),
                                          width: size.width,
                                          child: MaterialPicker(
                                            pickerColor: currentColor,
                                            onColorChanged: (Color value) {
                                              currentColor = value;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            valueListenable: checkedFontStyle,
                          );
                        });
                  },
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.05,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                              MaterialCommunityIcons.format_color_fill,
                              color: Colors.red[500],
                              size: size.height * 0.03,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'change_font_style',
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[500],
                          size: size.height * 0.018,
                        ),
                      ],
                    ),
                  ),
                ),
                // #list of texts
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, TextListPage.id);
                  },
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.05,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                            const Text(
                              'text_list',
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[500],
                          size: size.height * 0.018,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
