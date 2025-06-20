import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:weather_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List cityList = [
    'Dubai',
    'Palakkad',
    'Coimbatore',
    'Thrissur',
    'Kochi',
    'Chennai',
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Kozhikode',
    'Trivandrum',
  ];
  late String cityName = cityList.elementAt(1);
  // ignore: prefer_typing_uninitialized_variables
  late var data;
  Future<Map<String, dynamic>> getWeather() async {
    try {
      final result = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherAPIKey',
        ),
      );
      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw 'Un expected Error Occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          Icon(Icons.location_on),
          SizedBox(width: 8),
          DropdownButton(
            menuMaxHeight: 180,
            value: cityName,
            dropdownColor: Colors.blue[400],

            style: TextStyle(color: Colors.white, fontSize: 18),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),

            onChanged: (value) {
              setState(() {
                cityName = value.toString();
              });
            },
            items:
                cityList.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
        actionsPadding: EdgeInsets.all(12),
      ),
      body: FutureBuilder(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            data = snapshot.data;
          }

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentPressure = currentWeatherData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                //Mian card
                SizedBox(
                  width: double.infinity,

                  child: Card(
                    color: Colors.blue[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            spacing: 14,
                            children: [
                              Text(
                                "${currentTemp.toStringAsFixed(2)} °C",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                color: Colors.white,
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 60,
                              ),
                              Text(
                                currentSky,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //Weather forecast
                Text(
                  "Hourly Forecaser",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (var i = 1; i < 39; i++)
                //         HourlyForecast(
                //           time: data['list'][i]['dt'].toString(),
                //           data:
                //               data['list'][i]['weather'][0]['main'] ==
                //                           'Clouds' ||
                //                       data['list'][i]['weather'][0]['main'] ==
                //                           'Rain'
                //                   ? Icons.cloud
                //                   : Icons.sunny,

                //           temperature:
                //               data['list'][i]['main']['temp'] -
                //               273.15.toDouble(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 35,
                    itemBuilder: (context, index) {
                      final forecastTime = DateTime.parse(
                        data['list'][index + 1]['dt_txt'],
                      );

                      final forecastSky =
                          data['list'][index + 1]['weather'][0]['main'];

                      forcastSky() {
                        if (forecastSky == 'Clear' || forecastSky == 'Sunny') {
                          return Icons.sunny;
                        } else if (forecastSky == 'Rain') {
                          return Icons.cloudy_snowing;
                        } else {
                          return Icons.cloud;
                        }
                      }

                      final forecastTemp =
                          data['list'][index + 1]['main']['temp'] -
                          273.15.toDouble();

                      return HourlyForecast(
                        time: DateFormat.jm().format(forecastTime),
                        icon: forcastSky(),
                        temperature: forecastTemp,
                      );
                    },
                  ),
                ),
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditonalInfo(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        data: currentHumidity.toString(),
                      ),
                      AdditonalInfo(
                        icon: Icons.air,
                        label: "Wind Speed",
                        data: currentWindSpeed.toString(),
                      ),
                      AdditonalInfo(
                        icon: Icons.wind_power,
                        label: "Pressure",
                        data: currentPressure.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
