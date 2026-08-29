import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/constants/app_color.dart';

class GetLocation {
  double longitude = 0;
  double latitude = 0;
  Future<void> getLocationData() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      // service enabled null kina xaina ? because :
      // serviceEnabled = await Geolocator.isLocationServiceEnabled(); immediately sun bhairaxa

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // or bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // print("Location service not available");
        return; // exit the program
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission(); // request once
        if (permission == LocationPermission.denied) {
          // print("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // print(
        //   'Location permissions are permanently denied, we cannot request permissions.',
        // );
        return;
      }

      Position currentPosition = await Geolocator.getCurrentPosition();

      longitude = currentPosition.longitude;
      latitude = currentPosition.latitude;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching location",
        backgroundColor: AppColor.errorColor,
      );
    }
  }
}
