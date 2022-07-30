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

  Future<String> geoCodeLocationFromCoordinates(double lat, double lon) async {
    String location = "NO DATA";
    try {
      var response =
          await Dio().get('https://geocode.maps.co/reverse?lat=$lat&lon=$lon');
      var geocode = (response.data['address'] as Map<String, dynamic>).values;
      var addressLines = List.from(geocode);
      location = addressLines[0].toString() + ", " + addressLines[1].toString();
    } catch (e) {
      print(e);
    }
    return location;
  }
}
