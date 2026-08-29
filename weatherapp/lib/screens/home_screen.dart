import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/constants/app_color.dart';
import 'package:weatherapp/screens/search_city_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.cityName,
    required this.weatherDescription,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.wind,
    required this.clouds,
  });
  final String cityName;
  final String weatherDescription;
  final double temperature;
  final int humidity;
  final double pressure;
  final double wind;
  final int clouds;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageSelect(int clouds) {
    // if (clouds > 20 && clouds < 50) {
    //   return "cloudy.png";
    // } else if (clouds>50){
    //   return "rainy.png";
    // } else{
    //   return "sunny.png";

    return clouds > 20 && clouds <= 60
        ? "cloudy.png"
        : clouds > 60
        ? "rainy.png"
        : "sunny.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchCityName();
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.themeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                // textAlign: TextAlign.center,
                widget.cityName,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000749),
                ),
              ),
              Text(
                // textAlign: TextAlign.center,
                widget.weatherDescription,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000749),
                ),
              ),

              Expanded(
                child: Image.asset(
                  "assets/images/${imageSelect(widget.clouds)}",
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '${widget.temperature}°C',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000749),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset("assets/icons/humidity.png", height: 25),
                      Text(
                        '${widget.humidity}%',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000749),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/icons/atm_pressure.png", height: 25),
                      Text(
                        '${widget.pressure.toStringAsFixed(1)}atm',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000749),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/icons/wind.png", height: 25),
                      Text(
                        '${widget.wind}m/s',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000749),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
