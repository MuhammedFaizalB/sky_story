import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
    'Thrissur',
    'Kochi',
    'Kozhikode',
    'Trivandrum',
    'Coimbatore',
    'Chennai',
    'Bangalore',
    'Mumbai',
    'Delhi',
  ];
  late String cityName = cityList.elementAt(0);

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
      // appBar: AppBar(
      //   title: Text(cityName, style: TextStyle(fontWeight: FontWeight.bold)),
      //   centerTitle: false,
      //   actions: [
      //     Icon(Icons.location_on),
      //     SizedBox(width: 8),
      //     DropdownButton(
      //       menuMaxHeight: 180,
      //       value: cityName,
      //       dropdownColor: Colors.blue[400],

      //       style: TextStyle(color: Colors.white, fontSize: 18),
      //       icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),

      //       onChanged: (value) {
      //         setState(() {
      //           cityName = value.toString();
      //         });
      //       },
      //       items:
      //           cityList.map((e) {
      //             return DropdownMenuItem(value: e, child: Text(e));
      //           }).toList(),
      //     ),
      //     IconButton(
      //       onPressed: () {
      //         setState(() {});
      //       },
      //       icon: Icon(Icons.refresh),
      //     ),
      //   ],
      //   actionsPadding: EdgeInsets.all(12),
      // ),
      body: FutureBuilder(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/images/Animation.json'));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error Ocurred While Fetching Data"));
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

          // final sunRise = DateTime.parse(currentWeatherData['sys']['sunrise'].toString());

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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(135, 206, 235, 1),
                      Color.fromRGBO(96, 125, 139, 1),
                      Color.fromRGBO(38, 50, 56, 1),
                    ],
                  ),
                ),
              ),
              Lottie.asset(
                dataSky(),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton(
                          menuMaxHeight: 180,
                          value: cityName,
                          dropdownColor: Colors.transparent,
                          underline: SizedBox(),

                          style: TextStyle(color: Colors.white70, fontSize: 18),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                          ),

                          onChanged: (value) {
                            setState(() {
                              cityName = value.toString();
                            });
                          },
                          items:
                              cityList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.refresh),
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
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            "${currentTemp.toStringAsFixed(2)}°",

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //Icon(color: Colors.white, dataSky(), size: 60),
                          Text(
                            currentSky,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            DateFormat.jm().format(DateTime.now()),
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            DateFormat.MMMMEEEEd().format(DateTime.now()),
                            style: TextStyle(color: Colors.white70),
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
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 13),
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
                              if (forecastSky == 'Clear' ||
                                  forecastSky == 'Sunny') {
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
                        color: Colors.grey,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
