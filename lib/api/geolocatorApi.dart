// import 'dart:math';
// import 'package:geolocator/geolocator.dart';

// final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
// Position _currentPosition;

// _getCurrentLocation() async {
//   geolocator
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//       .then((Position position) {
//     _currentPosition = position;
//   }).catchError((e) {
//     print(e);
//   });
// }

// String _haversine(String latDe, String longD) {
//   double latUser = _currentPosition?.latitude ?? 0;
//   double longUser = _currentPosition?.longitude ?? 0;

//   double latDest = double.parse(latDe);
//   double longDest = double.parse(longD);

//   print('latde:' + latDe);
//   print('longDe:' + longD);

//   double radianLatUser = latUser * (0.0174532925);
//   double radianLonUser = longUser * (0.0174532925);
//   double radianLatDes = latDest * (0.0174532925);
//   double radianLonDes = longDest * (0.0174532925);

//   double x =
//       (radianLonDes - radianLonUser) * cos((radianLatUser + radianLatDes) / 2);
//   double y = radianLatDes - radianLatUser;

//   double distance = sqrt((x * x) + (y * y)) * (6371);
//   double finalDistance = double.parse((distance).toStringAsFixed(2));

//   print('jarak:' + finalDistance.toString());

//   // setState(() {
//   //   _distance = finalDistance;
//   // });

//   if (finalDistance != null) {
//     return finalDistance.toString();
//   }
//   return '0';

//   // print(latUser);
//   // print(longUser);
// }
