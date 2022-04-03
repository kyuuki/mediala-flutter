import 'package:flutter/material.dart';
import 'ui/medicine_list_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = '20220226';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,  // What is this (https://stackoverflow.com/questions/50615006/flutter-where-is-the-title-of-material-app-used)

      theme: ThemeData(
        //primarySwatch: myMaterialColor,
        primarySwatch: Colors.blue,
      ),
      //darkTheme: ThemeData.dark(),

      //home: MedicineNewPage(),
      home: MedicineListPage(),
    );
  }

  static const MaterialColor myMaterialColor = MaterialColor(
    _myPrimaryValue,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(_myPrimaryValue),
      600: Color(0xFF8E24AA),
      700: Color(0xFF7B1FA2),
      800: Color(0xFF6A1B9A),
      900: Color(0xFF4A148C),
    },
  );
  //static const int _myPrimaryValue = 0xFFE6E6FA;
  static const int _myPrimaryValue = 0xFFE1BEE7;
}
