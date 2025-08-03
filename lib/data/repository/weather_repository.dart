import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final weatherData = await WeatherDataProvider().getWeather(cityName);
      final data = jsonDecode(weatherData);

      if (data['cod'] != '200') {
        throw 'Un expected Error Occured';
      }
      return WeatherModel.fromMap(data);
    } catch (e) {
      throw 'Error Occured';
    }
  }
}
