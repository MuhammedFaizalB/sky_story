import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/pages/widgets/additional_info.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/pages/widgets/hourly_forecast.dart';
import 'package:weather_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "Palakkad";

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
      throw 'Error Occured';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/images/Animation.json'));
          }
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 24,
              children: [
                const SizedBox(width: double.infinity),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset('assets/images/Location.json'),
                ),
                const Text(
                  "Location not found. Please try a different location.",
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cityName = "Palakkad";
                    });
                  },
                  child: Text("Retry"),
                ),
              ],
            );
          }
          if (snapshot.hasData) {
            data = snapshot.data;
          }

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity =
              currentWeatherData['main']['humidity'] - 0.toDouble();
          final currentWindSpeed =
              currentWeatherData['wind']['speed'] - 0.toDouble();
          final currentPressure =
              currentWeatherData['main']['pressure'] - 0.toDouble();
          final feelLike =
              currentWeatherData['main']['feels_like'] - 273.15.toDouble();
          final minTemp =
              currentWeatherData['main']['temp_min'] - 273.15.toDouble();
          final maxTemp =
              currentWeatherData['main']['temp_max'] - 273.15.toDouble();

          dataSky() {
            if (currentSky == 'Sunny') {
              return 'assets/images/Sunny.json';
            } else if (currentSky == 'Rain') {
              return 'assets/images/Rain.json';
            } else {
              return 'assets/images/Clouds.json';
            }
          }

          return Stack(
            children: [
              Lottie.asset(
                dataSky(),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),

              ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (val) {
                            setState(() {
                              cityName = val;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search_outlined,
                              color: twhite,
                            ),
                            hintText: "Search Location ...",
                            hintStyle: TextStyle(color: twhite, fontSize: 20),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.refresh, color: twhite),
                      ),
                    ],
                  ),
                  SizedBox(height: 13),

                  //Mian card
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: EdgeInsets.all(14),

                    child: Column(
                      spacing: 8,
                      children: [
                        Text(
                          cityName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: twhite,
                          ),
                        ),
                        Text(
                          "${currentTemp.toStringAsFixed(2)}°",

                          style: TextStyle(
                            color: twhite,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentSky,
                          style: TextStyle(fontSize: 22, color: twhite),
                        ),
                        Text(
                          DateFormat.jm().format(DateTime.now()),
                          style: TextStyle(color: twhite),
                        ),
                        Text(
                          DateFormat.MMMMEEEEd().format(DateTime.now()),
                          style: TextStyle(color: twhite),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 13),

                  //Weather forecast
                  Text(
                    "Hourly Forecaser",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: hwhite,
                    ),
                  ),
                  SizedBox(height: 13),

                  Material(
                    elevation: 2,
                    shadowColor: Colors.lightBlue[100],
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
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
                            if (forecastSky == 'Sunny') {
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
                  ),
                  SizedBox(height: 13),
                  Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: hwhite,
                    ),
                  ),
                  SizedBox(height: 13),
                  Material(
                    elevation: 2,

                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        spacing: 22,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdditonalInfo(
                                icon: Icons.water_rounded,
                                label: "Humidity",
                                data: currentHumidity,
                              ),
                              AdditonalInfo(
                                icon: Icons.air,
                                label: "Wind Speed",
                                data: currentWindSpeed,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdditonalInfo(
                                icon: Icons.wind_power,
                                label: "Pressure",
                                data: currentPressure,
                              ),
                              AdditonalInfo(
                                icon: Icons.thermostat_sharp,
                                label: "Feel Like",
                                data: feelLike,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdditonalInfo(
                                icon: Icons.arrow_downward_outlined,
                                label: "Mini Temp",
                                data: minTemp,
                              ),
                              AdditonalInfo(
                                icon: Icons.arrow_upward_outlined,
                                label: "Maxi Temp",
                                data: maxTemp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
