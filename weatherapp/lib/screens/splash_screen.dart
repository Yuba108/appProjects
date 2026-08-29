import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/constants/app_color.dart';
import 'package:weatherapp/screens/home_screen.dart';
import 'package:weatherapp/services/weather_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void init() async {
    WeatherService weatherDataResponse = WeatherService();
    var weatherData = await weatherDataResponse.getWeatherData();

    final String cityName = weatherData?['name'] ?? 'city not found';
    final String weatherDescription =
        weatherData?['weather'][0]['description'] ?? ' ';
    final double temperature = weatherData?['main']['temp'] ?? 0;
    final int humidity = weatherData?['main']['humidity'] ?? 0;
    final int pressure = weatherData?['main']['pressure'] ?? 0;
    final double wind = weatherData?['wind']['speed'] ?? 0;
    final int clouds = weatherData?['clouds']['all'] ?? 0;

    final double atmPressure = pressure / 1013.25;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen(
            cityName: cityName,
            weatherDescription: weatherDescription,
            temperature: temperature,
            humidity: humidity,
            pressure: atmPressure,
            wind: wind,
            clouds: clouds,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // getLocationData();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(color: AppColor.loadingColor, size: 70, itemCount: 7),
          SizedBox(height: 10),
          Text(
            "Getting Weather Data",
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
