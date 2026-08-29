import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/constants/app_color.dart';
import 'package:weatherapp/screens/home_screen.dart';
import 'package:weatherapp/services/weather_service.dart';

class SearchCityName extends StatelessWidget {
  const SearchCityName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/city.jpg"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hint: const Text(
                      "Search City",
                      style: TextStyle(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppColor.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppColor.focusedColor),
                    ),
                  ),
                  onSubmitted: (text) async {
                    WeatherService weatherDataResponse = WeatherService();
                    var weatherData = await weatherDataResponse
                        .getWeatherDataByCityName(text);

                    final String cityName =
                        weatherData?['name'] ?? 'city not found';
                    final String weatherDescription =
                        weatherData?['weather'][0]['description'] ?? ' ';
                    final double temperature =
                        weatherData?['main']['temp'] ?? 0;
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
                  },
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Get Weather by City name",
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
