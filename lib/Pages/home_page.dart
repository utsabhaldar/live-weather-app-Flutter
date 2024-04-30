import 'package:flutter/material.dart';
import 'package:live_weather_app_flutter/Constants/api_key.dart';
import 'package:live_weather_app_flutter/Widgets/additional_info.dart';
import 'package:live_weather_app_flutter/Widgets/hourly_weather_card.dart';
import 'package:live_weather_app_flutter/Widgets/main_weather_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future getCurrentWeatherStatus() async {
    String cityName = 'Dehradun';
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$apiKey',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Checker',
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
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainWeatherCard(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Weather forecast",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
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
            SizedBox(
              height: 20,
            ),
            Text(
              "Additional info",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
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
