import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Story',
      theme: ThemeData.light(useMaterial3: true),
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
