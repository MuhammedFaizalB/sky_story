import 'package:weather_app/models/hourly_forecast_model.dart';

class WeatherModel {
  final double currentTemp;
  final String currentSky;
  final double currentHumidity;
  final double currentWindSpeed;
  final double currentPressure;
  final double feelLike;
  final double minTemp;
  final double maxtemp;
  final String locationName;
  final List<HourlyForecastModel> hourlyForecast;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherModel({
    required this.currentTemp,
    required this.currentSky,
    required this.currentHumidity,
    required this.currentWindSpeed,
    required this.currentPressure,
    required this.feelLike,
    required this.minTemp,
    required this.maxtemp,
    required this.hourlyForecast,
    required this.locationName,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    final currentWeatherData = map['list'][0];
    final String locationName = map['city']['name'];
    final sunrise = DateTime.fromMillisecondsSinceEpoch(
      map['city']['sunrise'] * 1000,
    );
    final sunset = DateTime.fromMillisecondsSinceEpoch(
      map['city']['sunset'] * 1000,
    );
    final List<dynamic> forecastJsonList = map['list'];

    final forecastList =
        forecastJsonList
            .map((forecastJson) => HourlyForecastModel.fromMap(forecastJson))
            .toList();

    return WeatherModel(
      currentTemp: currentWeatherData['main']['temp'] - 273.15,
      currentSky: currentWeatherData['weather'][0]['main'],
      currentHumidity: currentWeatherData['main']['humidity'] - 0.toDouble(),
      currentWindSpeed: currentWeatherData['wind']['speed'] - 0.toDouble(),
      currentPressure: currentWeatherData['main']['pressure'] - 0.toDouble(),
      feelLike: currentWeatherData['main']['feels_like'] - 273.15.toDouble(),
      minTemp: currentWeatherData['main']['temp_min'] - 273.15.toDouble(),
      maxtemp: currentWeatherData['main']['temp_max'] - 273.15.toDouble(),
      hourlyForecast: forecastList,
      locationName: locationName,
      sunrise: sunrise,
      sunset: sunset,
    );
  }
}
