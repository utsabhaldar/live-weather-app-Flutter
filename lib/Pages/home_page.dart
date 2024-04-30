import 'package:flutter/material.dart';
import 'package:live_weather_app_flutter/Widgets/additional_info.dart';
import 'package:live_weather_app_flutter/Widgets/hourly_weather_card.dart';
import 'package:live_weather_app_flutter/Widgets/main_weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
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
            onPressed: () {},
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
                  HourlyWeatherCard(),
                  HourlyWeatherCard(),
                  HourlyWeatherCard(),
                  HourlyWeatherCard(),
                  HourlyWeatherCard(),
                  HourlyWeatherCard(),
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
                AdditionalInfo(),
                AdditionalInfo(),
                AdditionalInfo(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
