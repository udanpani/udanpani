import 'package:dio/dio.dart';

class RestServices {
  Future<String> geoCodeFromCoordinates(double lat, double lon) async {
    String location = "NO DATA";
    try {
      var response =
          await Dio().get('https://geocode.maps.co/reverse?lat=$lat&lon=$lon');
      location = response.data['display_name'];
    } catch (e) {
      print(e);
    }
    return location;
  }
}
