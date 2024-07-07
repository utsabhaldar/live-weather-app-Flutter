import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_weather_app_flutter/Constants/api_key.dart';
import 'package:live_weather_app_flutter/Widgets/additional_info.dart';
import 'package:live_weather_app_flutter/Widgets/hourly_weather_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  final String city;
  const WeatherScreen({super.key, required this.city});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  late String cityName;

  Future<Map<String, dynamic>> getCurrentWeatherStatus() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred!\nPlease Enter a valid city name!';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    cityName = widget.city;
    weather = getCurrentWeatherStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
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
              setState(() {
                weather = getCurrentWeatherStatus();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text(
                      "Live weather data loaded",
                    ),
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.grey,
                ),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            final data = snapshot.data!;

            final currentData = data['list'][0];

            final currentTemp = currentData['main']['temp'] - 270;
            final currentPressure = currentData['main']['pressure'];
            final currentHumidity = currentData['main']['humidity'];
            final currentFeelsLike = currentData['main']['feels_like'] - 270;
            final currentSeaLevel = currentData['main']['sea_level'];
            final currentGroundLevel = currentData['main']['grnd_level'];
            final currentWindSpeed = currentData['wind']['speed'];
            final currentSky = currentData['weather'][0]['main'];

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      cityName,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                                  '${currentTemp.toStringAsFixed(0)}°C',
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  currentSky == 'Clouds'
                                      ? Icons.cloud
                                      : currentSky == 'Rain'
                                          ? Icons.cloudy_snowing
                                          : Icons.wb_sunny_rounded,
                                  size: 70,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
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
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        itemCount: 9,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hourlyForecast = data['list'][index + 1];
                          final hourlySky =
                              data['list'][index + 1]['weather'][0]['main'];
                          final time = DateTime.parse(
                              hourlyForecast['dt_txt'].toString());

                          return HourlyWeatherCard(
                            time: DateFormat.j().format(time),
                            temperature:
                                '${(hourlyForecast['main']['temp'] - 270).toStringAsFixed(0)}°C',
                            icon: hourlySky == 'Clouds'
                                ? Icons.cloud
                                : hourlySky == 'Rain'
                                    ? Icons.cloudy_snowing
                                    : Icons.wb_sunny_rounded,
                          );
                        }),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.sunny,
                        label: 'Feels Like',
                        value: '${currentFeelsLike.toStringAsFixed(0)}°C',
                      ),
                      AdditionalInfo(
                        icon: Icons.water,
                        label: 'Sea Level',
                        value: currentSeaLevel.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.filter_hdr_rounded,
                        label: 'Ground level',
                        value: currentGroundLevel.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.line_weight_outlined,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
