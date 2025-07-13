import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

class AdditonalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final double data;
  const AdditonalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    String val = data.toStringAsFixed(2);
    return Column(
      spacing: 8,
      children: [
        Icon(icon, size: 30, color: twhite),
        Text(label, style: TextStyle(fontSize: 16, color: twhite)),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: twhite)),
      ],
    );
  }
}
