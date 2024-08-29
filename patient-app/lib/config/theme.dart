

import 'package:flutter/material.dart';

import 'strings.dart';

class AppTheme {

  static const Color mainColor = Color(0xFF313ca2);
  static const Color darkColor = Color(0xff314cda);
  static const Color ascentColor = Color(0xFFec04a2);

  static ThemeData lightTheme = ThemeData(
    primaryColor: mainColor,
    hintColor: ascentColor,
      fontFamily: 'Poppins',
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: mainColor, // Or a different color for dark theme
        unselectedItemColor: mainColor.withOpacity(0.6), // Optional
      ),
    scaffoldBackgroundColor:Colors.white,
      iconTheme: const IconThemeData(
        color: mainColor, // Or a different color for dark theme
      ),
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      centerTitle: true, // Center the title
      titleTextStyle: TextStyle(
        fontSize: 16.0, // Set font size
        fontWeight: FontWeight.bold,
        color: Colors.white, // Set text color
      ),
    )
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: mainColor,
    hintColor: ascentColor,
    scaffoldBackgroundColor: Colors.white,
  );
}