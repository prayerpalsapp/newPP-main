import 'package:flutter/material.dart'; // borrowed code - not implemented,need to do more research

ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xff1f655d),
    textTheme: const TextTheme(
        headline6: TextStyle(color: Color(0xff40bf7a)),
        subtitle2: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Color(0xff40bf7a))),
    appBarTheme: const AppBarTheme(color: Color(0xff1f655d)));

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.lightBlue[200],
  textTheme: const TextTheme(
      headline6: TextStyle(color: Colors.black54),
      subtitle2: TextStyle(color: Colors.grey),
      subtitle1: TextStyle(color: Colors.white)),
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
      height: 2.0,
      fontSize: 30.0,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.lightBlue[200]),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
);
