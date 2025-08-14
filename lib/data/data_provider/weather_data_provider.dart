import 'package:weather_app/secret.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider {
  Future<String> getLiveWeather(double lat, double lot) async {
    try {
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lot&appid=$weatherApiKey',
        ),
      );

      return result.body;
    } catch (e) {
      throw 'UnExpected Error Occured';
    }
  }

  Future<String> getWeather(String cityName) async {
    try {
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherApiKey',
        ),
      );

      return result.body;
    } catch (e) {
      throw 'Error Occured';
    }
  }
}
