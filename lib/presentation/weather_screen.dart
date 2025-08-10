import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/widgets/additional_info.dart';
import 'package:weather_app/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/utils/colors.dart';

// ignore: must_be_immutable
class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  String cityName = "Palakkad";

  @override
  Widget build(BuildContext context) {
    context.read<WeatherBloc>().add(WeatherFetched(cityName: cityName));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return Center(child: Lottie.asset('assets/images/Animation.json'));
          }
          if (state is! WeatherSuccess) {
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
                    cityName = "Palakkad";
                    context.read<WeatherBloc>().add(
                      WeatherFetched(cityName: cityName),
                    );
                  },
                  child: Text("Retry"),
                ),
              ],
            );
          }

          final data = state.weatherModel;
          final locationName = data.locationName;
          final currentTemp = data.currentTemp;
          final currentSky = data.currentSky;
          final currentHumidity = data.currentHumidity;
          final currentWindSpeed = data.currentWindSpeed;
          final currentPressure = data.currentPressure;
          final feelLike = data.feelLike;
          final minTemp = data.minTemp;
          final maxTemp = data.maxtemp;
          final forecast = data.hourlyForecast;

          dataSky() {
            if (currentSky == 'Sunny') {
              return 'assets/images/Sunny.json';
            } else if (currentSky == 'Rain') {
              return 'assets/images/Rain.json';
            } else if (currentSky == 'Clear') {
              return 'assets/images/clear_cloud.json';
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
                            cityName = val;
                            context.read<WeatherBloc>().add(
                              WeatherFetched(cityName: cityName),
                            );
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
                          context.read<WeatherBloc>().add(
                            WeatherFetched(cityName: cityName),
                          );
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
                          locationName,
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
                            forecast[index + 1].dateTime.toString(),
                          );

                          final forecastSky = forecast[index + 1].forecastSky;

                          forcastSky() {
                            if (forecastSky == 'Sunny') {
                              return Icons.sunny;
                            } else if (forecastSky == 'Rain') {
                              return Icons.cloudy_snowing;
                            } else {
                              return Icons.cloud;
                            }
                          }

                          final forecastTemp = forecast[index + 1].forecastTemp;

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
                                icon: Icons.upcoming_outlined,
                                label: "SunRise",
                                data: currentHumidity,
                              ),
                              AdditonalInfo(
                                icon: Icons.upcoming_rounded,
                                label: "SunSet",
                                data: currentWindSpeed,
                              ),
                            ],
                          ),
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
