import 'package:music_player/widget/home.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Music Player',
        theme: ThemeData(scaffoldBackgroundColor: Colors.grey[900]),
        home: Home(title: 'Music Player'),
      );
    });
  }
}