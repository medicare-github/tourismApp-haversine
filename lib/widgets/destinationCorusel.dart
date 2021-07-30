import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../allNotifier/authNotifier.dart';
import '../screens/destinationScreen.dart';
import '../allNotifier/destinationNotifier.dart';
import 'package:provider/provider.dart';
import '../api/geolocatorApi.dart';

class DestinationCarousel extends StatefulWidget {
  @override
  _DestinationCarouselState createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  void initState() {
    // getLocation();
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  String _haversine(String latDe, String longD) {
    double latUser = _currentPosition?.latitude ?? 0;
    double longUser = _currentPosition?.longitude ?? 0;

    double latDest = double.parse(latDe);
    double longDest = double.parse(longD);

    // print('latde:' + latDe);
    // print('longDe:' + longD);

    double radianLatUser = latUser * (0.0174532925);
    double radianLonUser = longUser * (0.0174532925);
    double radianLatDes = latDest * (0.0174532925);
    double radianLonDes = longDest * (0.0174532925);

    double x = (radianLonDes - radianLonUser) *
        cos((radianLatUser + radianLatDes) / 2);
    double y = radianLatDes - radianLatUser;

    double distance = sqrt((x * x) + (y * y)) * (6371);
    double finalDistance = double.parse((distance).toStringAsFixed(2));

    // print('jarak:' + finalDistance.toString());

    if (finalDistance != null) {
      return finalDistance.toString();
    }
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    DestinationNotifier destinationNotifier =
        Provider.of<DestinationNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    String email = authNotifier.user.email;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Nearby Destinations",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    letterSpacing: 1.0),
              )
            ],
          ),
        ),
        Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinationNotifier.destinationList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  destinationNotifier.currentDestination =
                      destinationNotifier.destinationList[index];
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return DestinationScreen(
                      emailAddress: email,
                      idItem: destinationNotifier.destinationList[index].idItem,
                    );
                  }));
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 180,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                        bottom: 18.0,
                        child: Container(
                          height: 100,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  destinationNotifier
                                      .destinationList[index].name,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  destinationNotifier
                                      .destinationList[index].description,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                height: 170.0,
                                width: 150.0,
                                image: NetworkImage(
                                  destinationNotifier
                                              .destinationList[index].image !=
                                          null
                                      ? destinationNotifier
                                          .destinationList[index].image
                                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 10.0,
                              bottom: 10.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    destinationNotifier
                                        .destinationList[index].name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.locationArrow,
                                        size: 10.0,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        _haversine(
                                              destinationNotifier
                                                  .destinationList[index]
                                                  .latitude,
                                              destinationNotifier
                                                  .destinationList[index]
                                                  .longitude,
                                            ) +
                                            " Kilometer",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
