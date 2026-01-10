import 'package:flutter/material.dart';
import 'package:upvia/screens/edit_habit_screen.dart';
import 'package:upvia/screens/habits_month_screen.dart';
import 'package:upvia/screens/habits_screen.dart';
import 'package:upvia/screens/home_screen.dart';
import 'package:upvia/screens/new_habit_screen.dart';
import 'package:upvia/screens/tabs_screen.dart';

class Constants {
  static final routes = {
    '/home': (context) => HomeScreen(),
    '/habits/add': (context) => const NewHabitScreen(),
    '/habits/edit': (context) => const EditHabitScreen(),
    '/habits/month': (context) => const HabitsMonthScreen(),
    '/tabs': (context) => TabsScreen(),
  };

  static final List<String> colors = [
    "#DC7171",
    "#F19956",
    "#E4B249",
    "#E5D448",
    "#95C84D",
    "#6DC18A",
    "#58B9C9",
    "#5193E2",
    "#5956E3",
    "#7D4EDF",
    "#A65ED7",
    "#CF61B8",
  ];

  static const Color primaryColor = Colors.black;
  static Color shadeColor = Colors.black;
  static ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor,
    dividerColor: primaryColor,
    // appBarTheme: const AppBarTheme(
    //   toolbarTextStyle: TextStyle(color: Colors.white),
    //   backgroundColor: primaryColor,
    //   iconTheme: IconThemeData(color: Colors.white),
    //   titleTextStyle: TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 20,
    //   ),
    // ),
    // checkboxTheme: CheckboxThemeData(
    //   side: const BorderSide(color: Colors.white, width: 1.2),
    //   fillColor: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) return shadeColor;
    //     return Colors.transparent;
    //   }),
    // ),
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    //   backgroundColor: primaryColor,
    //   foregroundColor: Colors.white,
    //   shape: CircleBorder(),
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: primaryColor,
    //     foregroundColor: Colors.white,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   ),
    // ),
    // textSelectionTheme: TextSelectionThemeData(cursorColor: shadeColor),
    // textTheme: const TextTheme(
    //   headlineSmall: TextStyle(
    //     color: Colors.white, // will be applied in DrawerHeader
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    tabBarTheme: TabBarThemeData(
      labelColor: shadeColor,
      unselectedLabelColor: shadeColor.withAlpha(255 * 60 ~/ 100),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: shadeColor, width: 2.0),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor, // Changes the blinking cursor color
      selectionColor: Colors.black12, // Changes the highlight color
      selectionHandleColor: primaryColor, // Changes the bubble/handle color
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: shadeColor),
      // hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: shadeColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: shadeColor),
      ),
    ),
  );
}
