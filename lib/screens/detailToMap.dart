import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/loadingScreen.dart';

class DetailToMap extends StatefulWidget {
  DetailToMap({@required this.idItem});
  final String idItem;
  @override
  _DetailToMapState createState() => _DetailToMapState();
}

class _DetailToMapState extends State<DetailToMap> {
  bool mapToggle = false;
  bool clientToggle = false;
  var currentLocation;
  var tourisms = [];
  double lat;
  double long;

  GoogleMapController mapController;
  CameraPosition cameraPosition;
  Map<MarkerId, Marker> _markers = Map();

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        populateClient();
      });
    });
    // print(lat);
  }

  populateClient() {
    tourisms = [];
    Firestore.instance
        .collection('Tourisms')
        .where('idItem', isEqualTo: widget.idItem)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          clientToggle = true;
        });
        for (int i = 0; i < docs.documents.length; i++) {
          tourisms.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
        }
      }
    });
  }

  Widget boxDestination(tourim) {
    return GestureDetector(
      onTap: () {
        zoomInMarker(tourim);
      },
      child: Container(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  height: MediaQuery.of(context).size.height - 5.0,
                  width: 130.0,
                  image: NetworkImage(tourim['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: <Widget>[
                Text(
                  tourim['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  tourim['village'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  // color: Colors.grey,
                  width: 220,
                  child: Text(
                    tourim['description'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  initMarker(tourim) {
    final markerId = MarkerId(tourim['name']);
    final markers = Marker(
      markerId: markerId,
      position: LatLng(tourim['lating'].latitude, tourim['lating'].longitude),
      infoWindow:
          InfoWindow(title: tourim['name'], snippet: tourim['description']),
    );
    setState(() {
      _markers[markerId] = markers;
    });
  }

  zoomInMarker(tourim) {
    LatLng latLng =
        new LatLng(tourim['lating'].latitude, tourim['lating'].longitude);
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 14.5);
    mapController.animateCamera(cameraUpdate);
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: mapToggle
                ? GoogleMap(
                    onMapCreated: onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(-8.3739, 116.2777), zoom: 10.0),
                    markers: Set.of(_markers.values),
                  )
                : Loading(),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: (MediaQuery.of(context).size.height * 1 / 4) - 10,
              // color: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: clientToggle
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(8.0),
                      children: tourisms.map((element) {
                        return boxDestination(element);
                      }).toList(),
                    )
                  : Container(
                      height: 1.0,
                      width: 1.0,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
