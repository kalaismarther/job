// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

/// This AppTheme class is used for providing theme for entire application.
class AppTheme {
  // static const int _primary = 0xff061D61;
  static final lightTheme = ThemeData(
    fontFamily: 'Poppins',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    }),
    colorScheme: const ColorScheme.light()
        .copyWith(primary: primary, surfaceTint: Colors.transparent),
    appBarTheme: AppBarTheme(
      backgroundColor: AppTheme.primary,
      systemOverlayStyle: SystemUiOverlayStyle(
        // statusBarColor: Color(_primary),
        statusBarColor: HexColor("#565BDB"),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    // scaffoldBackgroundColor: const Color(0xffF4F6FA),
    scaffoldBackgroundColor: Colors.white,
    // primaryColor: const Color(_primary),
    primaryColor: HexColor("#565BDB"),

    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTheme.TextFormFieldBac,
        hintStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 8.0)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              const Size(0, 50),
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all(AppTheme.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )))),
  );

  static Color primary = HexColor("#565BDB");
  static const Color white = Colors.white;
  static const Color black = Color(0xff1e1e1e);
  static const Color hint = Color(0xff757575);
  static const Color amber = Color(0xFFFFBF00);
  static const Color darkHint = Color(0xFF616161);
  static const Color lightHint = Color(0xff989898);
  static const Color tab = Color(0xffdfe5ed);
  static const Color border = Color(0xffd6e5f2);
  static const Color tabUnselect = Color(0x6B1E1E1E);
  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color gray = Color(0xffC4C4C4);
  static const Color graylight = Color(0xffe5e2e2);
  static const Color txtgray = Color(0xffb0aeae);
  static const Color themecolor = Color(0xff0b519a);
  static const Color lightblue = Color(0xffD9ECFF);
  static const Color bankingprimary = Color(0xffFF5353);
  static const Color bankingbg = Color(0xffF6F6F6);
  static const Color grayDark = Color(0xff757575);
  static const Color bankingprimarylight = Color(0xffFFE6E2);
  static const Color tabgrey = Color(0xffE5E5E5);
  static const Color background = Color(0xffF4F6FA);
  static const Color ash = Color(0xff606060);
  static const Color bottomNavUnselected = Color(0xFFBEBEBE);
  static const Color dashboardCardView = Color(0xfff4f4f4);
  static const Color planBorderColor = Color(0xffd8e4ef);
  static const Color blue = Color(0xff3580ff);

  //survey
  static const Color surveyPrimary = Color(0xff0b2d50);
  static const Color successGreen = Color(0xff20C594);
  static const Color surveyTxtHint = Color(0xff8b8b8b);
  static const Color surveyTxtTitle = Color(0xff003366);
  static const Color txtRadioSurvey = Color(0xff606060);
  static const Color colorOrange = Color(0xffFFA500);
  static const Color borderColor = Color(0xff1DA9F4);
  static const Color borderColorSurvey = Color(0xffD6D6D6);

  //App ****

  static Color TextLite = HexColor("#92929D");
  static Color TextBoldLite = HexColor("#696974");
  static Color TextFormFieldBac = HexColor("#EEEEEE");
  static Color primary_light = HexColor("#dddef8");
  static Color success = HexColor("#39A058");
  static Color success_light = HexColor("#d3f0d3");
  static Color danger = HexColor("#E24141");
  static Color danger_light = HexColor("#f9d9d9");
  static Color app_yellow = HexColor("#FFB836");
  static Color app_yellow_lite = HexColor("#fdf3eb");
}
