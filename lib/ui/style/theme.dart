import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import 'app.colors.dart';

class AppTheme {
  AppTheme._();
  String fontFamily;
AppTheme(String fontFamily){
  this.fontFamily=fontFamily;
}


  ThemeData lightModeTheme=ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.primaryColorDark,
    textTheme: AppTheme.lightTextTheme,
    fontFamily: Root.fontFamily,
    cursorColor: AppColors.primaryColor,
    backgroundColor:Colors.white,
    primaryColorDark: AppColors.primaryColorDark,
    cardColor: Colors.white,
    canvasColor:AppColors.lightCanvasColor,
    disabledColor: AppColors.customGreyLevels[100],
    brightness: Brightness.light,
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: AppColors.primaryColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(10),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor, width: 1)),
      errorStyle: lightTextTheme.subtitle2.copyWith(color: Colors.red),
    ),
  );


  ThemeData darkModeTheme=ThemeData(
    scaffoldBackgroundColor: AppColors.primaryColorDark,
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.primaryColorDark,
    textTheme: AppTheme.darkTextTheme,
    fontFamily: Root.fontFamily,
    cursorColor: AppColors.primaryColor,
    backgroundColor: AppColors.primaryColorDark,
    cardColor: AppColors.darkCardColor,
   primaryColorDark: AppColors.primaryColorDark,
   canvasColor:AppColors.darkCanvasColor,
    brightness: Brightness.dark,
    disabledColor: AppColors.white,
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: AppColors.primaryColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(10),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
      ),
      errorStyle: lightTextTheme.subtitle2.copyWith(color: Colors.red),
    ),
  );


  static TextTheme lightTextTheme = TextTheme(
    headline1: headline1.copyWith(color: AppColors.primaryColorDark),
    headline2: headline2.copyWith(color: AppColors.customGreyLevels[100]),
    headline3: headline3.copyWith(color: AppColors.customGreyLevels[100]),
    headline4: headline4.copyWith(color: AppColors.customGreyLevels[100]),
    headline5: headline5.copyWith(color: AppColors.customGreyLevels[100]),
    button: button.copyWith(color: AppColors.customGreyLevels[100]),
    caption: caption.copyWith(color: AppColors.customGreyLevels[100]),
    bodyText1: body.copyWith(color: AppColors.customGreyLevels[100]),
    bodyText2: bodySmall.copyWith(color: AppColors.customGreyLevels[100]),
    subtitle1: input.copyWith(color: AppColors.customGreyLevels[100]),
    subtitle2: smallText.copyWith(color: AppColors.customGreyLevels[100]),
  );

  static TextTheme darkTextTheme = TextTheme(
    headline1: headline1.copyWith(color: AppColors.white),
    headline2: headline2.copyWith(color: AppColors.white),
    headline3: headline3.copyWith(color: AppColors.customGreyLevels[100]),
    headline4: headline4.copyWith(color: AppColors.customGreyLevels[100]),
    headline5: headline5.copyWith(color: AppColors.customGreyLevels[100]),
    button: button.copyWith(color: AppColors.customGreyLevels[100]),
    caption: caption.copyWith(color: AppColors.customGreyLevels[100]),
    bodyText1: body.copyWith(color: AppColors.customGreyLevels[100]),
    bodyText2: bodySmall.copyWith(color: AppColors.customGreyLevels[100]),
    subtitle1: input.copyWith(color: AppColors.customGreyLevels[100]),
    subtitle2: smallText.copyWith(color: AppColors.customGreyLevels[100]),
  );

  static Color attendanceColor(String status){
    switch(status){
      case "pending":
        return AppColors.primaryColor;
      case "checked_in":
      case "checked_out":
        return AppColors.successColor;
      case "missed":
        return AppColors.simpleWarningColor;
      case "work_hours_not_completed":
        return AppColors.warningColor;
      case "not_accepted":
      case "absented":
        return AppColors.failedColor;
      default:
        return AppColors.failedColor;
    }
  }


  static IconData attendanceCircleIcon(String status){
    switch(status){
      case "checked_in":
      case "checked_out":
        return FontAwesomeIcons.solidCheckCircle;
      case "missed":
      case "work_hours_not_completed":
        return FontAwesomeIcons.exclamationCircle;
      case "not_accepted":
      case "absented":
        return FontAwesomeIcons.solidTimesCircle;
      default:
        return FontAwesomeIcons.solidTimesCircle;
    }
  }


  static TextStyle headline1 = TextStyle(
    fontWeight: FontWeight.w700,
//    color: AppColors.primaryColors[200],
    fontSize: 24,
  );

  static TextStyle headline2 = TextStyle(
    fontWeight: FontWeight.w700,
//    color: AppColors.primaryColors[200],
    fontSize: 16,
  );

  static TextStyle headline3 = TextStyle(
    fontWeight: FontWeight.w700,
//    color: AppColors.primaryColors[200],
    fontSize: 12,
  );

  static TextStyle headline4 = TextStyle(
    fontWeight: FontWeight.w400,
//    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle headline5 = TextStyle(
    fontWeight: FontWeight.w500,
//    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle button = TextStyle(
    fontWeight: FontWeight.w400,
//    color: AppColors.primaryColors[200],
    fontSize: 16,
  );

  static TextStyle caption = TextStyle(
    fontWeight: FontWeight.w300,
//    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle input = TextStyle(
    fontWeight: FontWeight.w300,
//    color: AppColors.primaryColors[200],
    fontSize: 14,
  );

  static TextStyle body = TextStyle(
    fontWeight: FontWeight.w400,
//    color: AppColors.primaryColors[200],
    fontSize: 12,
  );

  static TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.w300,
//    color: AppColors.primaryColors[200],
    fontSize: 12,
  );

  static TextStyle smallText = TextStyle(
    fontWeight: FontWeight.w300,
//    color: AppColors.primaryColors[200],
    fontSize: 11,
  );
}
