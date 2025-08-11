import 'package:flutter/widgets.dart';
import 'package:weather_app/utils/colors.dart';

class AdditionalInfoSun extends StatelessWidget {
  final IconData icon;
  final String label;
  final String data;
  const AdditionalInfoSun({
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
        Icon(icon, size: 30, color: twhite),
        Text(label, style: TextStyle(fontSize: 16, color: twhite)),
        Text(
          data,
          style: TextStyle(fontWeight: FontWeight.bold, color: twhite),
        ),
      ],
    );
  }
}
