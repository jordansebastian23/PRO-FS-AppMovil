import 'package:latlong2/latlong.dart';

class AppConstants {
  static String mapBoxAccessToken = 'pk.eyJ1Ijoiam9yZGFuczMiLCJhIjoiY20yZTNxZW1kMWlzMDJrcHNteGtmODlvOSJ9.EY27KDTG2q0ynThRiljRFQ';
  static String urlTemplate = 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapBoxAccessToken';
  static String mapBoxStyleDarkid = 'mapbox/dark-v11';
  static String mapBoxStyleLightid = 'mapbox/light-v10';
  static String mapBoxStyleStreetsid = 'mapbox/streets-v11';

  static const mylocation = LatLng(51.5, -0.09);
}
