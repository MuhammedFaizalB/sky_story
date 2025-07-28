import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_screen.dart';
import 'package:weather_app/utils/colors.dart';

class Responsive extends StatelessWidget {
  const Responsive({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * .3,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: bgcolor,
              ),
            ),
            child: WeatherScreen(),
          );
        }
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgcolor,
            ),
          ),
          child: WeatherScreen(),
        );
      },
    );
  }
}
