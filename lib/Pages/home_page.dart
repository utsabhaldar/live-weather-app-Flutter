import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:live_weather_app_flutter/Constants/api_key.dart';
import 'package:live_weather_app_flutter/Widgets/additional_info.dart';
import 'package:live_weather_app_flutter/Widgets/hourly_weather_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  @override
  void initState() {
    super.initState();
    getCurrentWeatherStatus();
  }

  Future getCurrentWeatherStatus() async {
    try {
      String cityName = 'Dehradun';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$apiKey',
        ),
      );
      final data = jsonDecode(res.body);
      // if (data['cod'] != '200') {
      //   throw 'An unexpected error occured!';
      // }

      setState(() {
        temp = (data['main']['temp']);
        temp = temp - 270;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Live',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print('a');
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            temp != 270 ? '${temp.toStringAsFixed(2)}°C' : '0',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Icon(
                            Icons.cloud,
                            size: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Rain',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Weather forecast",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyWeatherCard(
                    time: '03:00',
                    temperature: '300K',
                    icon: Icons.cloud,
                  ),
                  HourlyWeatherCard(
                    time: '04:00',
                    temperature: '300K',
                    icon: Icons.cloud,
                  ),
                  HourlyWeatherCard(
                    time: '05:00',
                    temperature: '300K',
                    icon: Icons.cloud,
                  ),
                  HourlyWeatherCard(
                    time: '06:00',
                    temperature: '300K',
                    icon: Icons.cloud,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Additional info",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfo(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '91',
                ),
                AdditionalInfo(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '8.5',
                ),
                AdditionalInfo(
                  icon: Icons.water_drop,
                  label: 'Pressure',
                  value: '1020',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
