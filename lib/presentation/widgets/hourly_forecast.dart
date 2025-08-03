import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final double temperature;
  const HourlyForecast({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    String temp = temperature.toStringAsFixed(2);
    return Container(
      width: 110,
      color: Colors.transparent,
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        children: [
          Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: twhite,
            ),
          ),
          Icon(icon, color: twhite),
          Text("$temp °C", style: TextStyle(fontSize: 16, color: twhite)),
        ],
      ),
    );
  }
}
