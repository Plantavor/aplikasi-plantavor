import 'package:flutter/material.dart';
import 'package:plantavor/constant/color.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:terature/constant/color.dart';

class AppTheme extends GetxController {
  var isDarkMode = Get.isDarkMode.obs;
  var themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = _getTheme();
    firstInitialization();
    // ignore: avoid_print
    print('inisialisasi theme');
  }

  get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColor.darkBackgroundColor,
        dialogBackgroundColor: AppColor.darkBackgroundColor,
        appBarTheme: const AppBarTheme(
            // brightness: Brightness.dark,
            titleTextStyle: TextStyle(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColor.darkAppbarColor),
        primaryColor: Colors.black,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        brightness: Brightness.dark,
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //   primary: Colors.grey[850],
        //   shape: RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(30.0),
        //   ),
        //   shadowColor: Colors.black,
        //   minimumSize: Size(200, 50),
        // )),
      );

  get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColor.lightBackgroundColor,
        // primaryColor: Colors.white,
        primaryTextTheme:
            const TextTheme(titleLarge: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          // brightness: Brightness.light,
          backgroundColor: AppColor.lightAppbarColor,
          iconTheme: IconThemeData(color: Colors.grey[700]),
          titleTextStyle: TextStyle(color: Colors.grey[700]),
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //   primary: Colors.white,
        //   elevation: 6,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(30.0),
        //   ),
        //   minimumSize: Size(200, 50),
        // )),
        brightness: Brightness.light,
      );

  Future<void> firstInitialization() async {
    final box = GetStorage();

    if (box.read('darkMode') != null) {
      isDarkMode.value = box.read('darkMode');
    } else {
      isDarkMode.value = Get.isDarkMode;
    }
  }

  void changeTheme() {
    final box = GetStorage();

    if (isDarkMode.value) {
      // Get.changeTheme(AppTheme().lightTheme);
      isDarkMode.value = false;
      box.write('darkMode', false);
      themeMode.value = ThemeMode.light;
    } else {
      // Get.changeTheme(AppTheme().darkTheme);
      isDarkMode.value = true;
      box.write('darkMode', true);
      themeMode.value = ThemeMode.dark;
    }
  }

  ThemeMode _getTheme() {
    final box = GetStorage();

    if (box.read('darkMode') != null) {
      if (box.read('darkMode')) {
        // ignore: avoid_print
        print('${box.read('darkMode')}ini themenya');
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }
    } else {
      return ThemeMode.light;
    }
  }
}
