import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  toggleTheme(bool isDark) {
    // _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
        _themeMode = isDark ? ThemeMode.light : ThemeMode.light;

    notifyListeners();
  }
}

const primaryColor = Color(0xFF000080);
//const primaryColor = Color(0xFFFF7F00);
const lightTitleColor = Color(0xFF1A1A1A);
// const lightGreyTextColor = Color(0xFF484848);
const lightGreyTextColor = Color(0xFF7F7F7F);
const darkTitleColor = Color(0xFFFFFFFF);
const darkGreyTextColor = Color(0xFFACACAC);
const darkContainer = Color(0xff323241);
const darkContainerColor = Color(0xFF181824);
const lightContainerColor = Color(0xFFF4F4F4);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.light,
    //primary: const Color(0xFFFF7F00),
    primary: const Color(0xFF000080),
    primaryContainer: const Color(0xffFFFFFF),
    background: const Color(0xffF1F2F6),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.grey),
    thumbColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.dark,
   // primary: const Color(0xFFFF7F00),
    primary: const Color(0xFF000080),
    primaryContainer: const Color(0xff181824),
    background: const Color(0xff000000),
  ),
);
