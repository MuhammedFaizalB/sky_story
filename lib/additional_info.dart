import 'package:flutter/material.dart';

class AdditonalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String data;
  const AdditonalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Icon(icon, size: 30, color: Colors.blue[500]),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.blue[500])),
        Text(
          data,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[500],
          ),
        ),
      ],
    );
  }
}
