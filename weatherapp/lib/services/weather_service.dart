import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http; // http lai object jsto banauxa
import 'package:weatherapp/constants/app_color.dart';
import 'package:weatherapp/constants/app_constants.dart';
import 'package:weatherapp/services/location_service.dart';

class WeatherService {
  Future<Map<String, dynamic>?> getWeatherData() async {
    try {
      GetLocation location = GetLocation();
      await location.getLocationData();

      // hit API
      http.Response response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=${AppConstants.apiKey}&units=metric&lang=en#',
        ),
      );
      // print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode <= 300) {
        // print(location.latitude);
        var responseAsMap = jsonDecode(response.body) as Map<String, dynamic>;
        return responseAsMap;
      }

      if (response.statusCode < 200 || response.statusCode > 399) {
        throw ();
      }

      // print(response.body);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching weather data",
        backgroundColor: AppColor.errorColor,
      );
    }
    return null;
  }

  Future<Map<String, dynamic>?> getWeatherDataByCityName(
    String cityName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${AppConstants.apiKey}&units=metric&lang=en#',
        ),
      );
      if (response.statusCode == 200 || response.statusCode <= 300) {
        var responseAsMap = jsonDecode(response.body) as Map<String, dynamic>;
        return responseAsMap;
      }
      if (response.statusCode < 200 || response.statusCode > 399) {
        throw ();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "City not found",
        backgroundColor: AppColor.errorColor,
      );
    }
    return null;
  }
}
