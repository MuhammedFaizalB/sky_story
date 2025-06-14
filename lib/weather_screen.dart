import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
        actionsPadding: EdgeInsets.all(10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            //Mian card
            SizedBox(
              width: double.infinity,
              height: 220,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        spacing: 14,
                        children: [
                          Text(
                            "102.67 °F",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.cloud, size: 60),
                          Text("Rain", style: TextStyle(fontSize: 28)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Weather forecast
            Text(
              "Weather Forecaser",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecast(time: "09:00", temperature: "102.67"),
                  HourlyForecast(time: "10:00", temperature: "103"),
                  HourlyForecast(time: "11:00", temperature: "103.62"),
                  HourlyForecast(time: "12:00", temperature: "105"),
                  HourlyForecast(time: "13:00", temperature: "105.32"),
                ],
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
                    data: "96",
                  ),
                  AdditonalInfo(
                    icon: Icons.air,
                    label: "Wind Speed",
                    data: "7.67",
                  ),
                  AdditonalInfo(
                    icon: Icons.beach_access,
                    label: "Pressure",
                    data: "1006",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
