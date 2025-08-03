class HourlyForecastModel {
  final double forecastTemp;
  final String forecastSky;
  final DateTime dateTime;

  HourlyForecastModel({
    required this.forecastTemp,
    required this.forecastSky,
    required this.dateTime,
  });

  factory HourlyForecastModel.fromMap(Map<String, dynamic> map) {
    return HourlyForecastModel(
      forecastTemp: map['main']['temp'] - 273.15,
      forecastSky: map['weather'][0]['main'],
      dateTime: DateTime.parse(map['dt_txt']),
    );
  }
}
