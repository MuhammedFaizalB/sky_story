import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/pages/responsive_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Story',
      theme: ThemeData(brightness: Brightness.dark),
      home: Responsive(),
      debugShowCheckedModeBanner: false,
    );
  }
}
