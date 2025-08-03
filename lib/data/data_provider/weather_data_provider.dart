import 'package:weather_app/secret.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider {
  Future<String> getWeather(String cityName) async {
    try {
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherAPIKey',
        ),
      );

      return result.body;
    } catch (e) {
      throw 'Error Occured';
    }
  }
}
