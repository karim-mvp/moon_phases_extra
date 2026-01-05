import 'package:flutter/material.dart';
import 'package:moon_phases_extra/moon_phases_extra.dart';

void main() {
  initMoonPhasesLanguage("en");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AppMoonWidget(),
    );
  }
}
