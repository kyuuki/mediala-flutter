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
        primarySwatch: Colors.indigo,

        // https://qiita.com/ko2ic/items/88bc9eee52e16560529e#inputdecorationtheme-focusedborder
        // 入力フォームが入力中の文字が見にくいので変更
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: Colors.black54,
          )
        ),
      ),
      //darkTheme: ThemeData.dark(),

      //home: MedicineNewPage(),
      home: MedicineListPage(),
    );
  }

  // http://mcg.mbitson.com/#!?mcgpalette0=%23e6e6fa
  static const MaterialColor myMaterialColor = MaterialColor(
    _myPrimaryValue,
    <int, Color>{
      50: Color(0xFFFCFCFE),
      100: Color(0xFFF8F8FE),
      200: Color(0xFFF3F3FD),
      300: Color(0xFFEEEEFC),
      400: Color(0xFFEAEAFB),
      500: Color(_myPrimaryValue),
      600: Color(0xFFE3E3F9),
      700: Color(0xFFDFDFF9),
      800: Color(0xFFDBDBF8),
      900: Color(0xFFD5D5F6),
    },
  );
  static const int _myPrimaryValue = 0xFFE6E6FA;
  //static const int _myPrimaryValue = 0xFFE1BEE7;
}
