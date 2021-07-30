import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/loadingScreen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool mapToggle = false;
  bool clientToggle = false;
  var currentLocation;

  var clients = [];

  GoogleMapController mapController;
  BitmapDescriptor destinationIcon;

  Map<MarkerId, Marker> _markers = Map();

  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        populateClient();
      });
    });
  }

  createMarker(context) {
    if (destinationIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/point_natural.png')
          .then((icons) {
        setState(() {
          destinationIcon = icons;
        });
      });
    }
  }

  populateClient() {
    clients = [];
    Firestore.instance
        .collection('Tourisms')
        .where("status", isEqualTo: "accepted")
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          clientToggle = true;
        });
        for (int i = 0; i < docs.documents.length; i++) {
          clients.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
        }
      }
    });
  }

  initMarker(client) {
    final markerId = MarkerId(client['name']);
    final markers = Marker(
      markerId: markerId,
      position: LatLng(client['lating'].latitude, client['lating'].longitude),
      infoWindow:
          InfoWindow(title: client['name'], snippet: client['description']),
    );
    setState(() {
      _markers[markerId] = markers;
    });
  }

  Widget clientCard(client) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, top: 20.0),
      child: GestureDetector(
        onTap: () {
          zoomInMarker(client);
        },
        child: Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white70),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      height: 180.0,
                      width: 100.0,
                      image: NetworkImage(client['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.0,
                ),
                Container(
                  height: 80.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        client['name'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                      Text(
                        client['village'],
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  zoomInMarker(client) {
    LatLng latLng =
        new LatLng(client['lating'].latitude, client['lating'].longitude);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 14.0);
    mapController.animateCamera(cameraUpdate);
  }

  setPosition() {
    LatLng latLng =
        new LatLng(currentLocation.latitude, currentLocation.longitude);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 14.0);
    mapController.animateCamera(cameraUpdate);
  }

  @override
  Widget build(BuildContext context) {
    createMarker(context);
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: mapToggle
                ? GoogleMap(
                    onMapCreated: onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(-8.3739, 116.2777), zoom: 10.0),
                    markers: Set.of(_markers.values),
                  )
                : Loading(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height - 240.0,
            left: 10.0,
            child: Container(
              height: 150.0,
              width: MediaQuery.of(context).size.width,
              child: clientToggle
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(8.0),
                      children: clients.map((element) {
                        return clientCard(element);
                      }).toList(),
                    )
                  : Container(
                      height: 1.0,
                      width: 1.0,
                    ),
            ),
          ),
          mapToggle
              ? Positioned(
                  top: MediaQuery.of(context).size.height - 120.0,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      setPosition();
                    },
                    child: Container(
                      height: 50,
                      width: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[700],
                      ),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
