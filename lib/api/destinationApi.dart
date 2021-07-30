import 'package:cloud_firestore/cloud_firestore.dart';
import '../allNotifier/destinationNotifier.dart';
import '../allNotifier/newDestNotifier.dart';
import '../models/destination_model.dart';

getDestinations(DestinationNotifier destinationNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Tourisms')
      .where('status', isEqualTo: 'accepted')
      .getDocuments();

  List<Destination> _destinationList = [];

  snapshot.documents.forEach((document) {
    Destination destination = Destination.fromMap(document.data);
    _destinationList.add(destination);
  });

  destinationNotifier.destinationList = _destinationList;
}

getNewDestinations(NewDestNotifier newDestNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Tourisms')
      .where('status', isEqualTo: 'accepted')
      .orderBy('acceptedAt', descending: true)
      .getDocuments();

  List<Destination> _newDestinationList = [];

  snapshot.documents.forEach((document) {
    Destination destination = Destination.fromMap(document.data);
    _newDestinationList.add(destination);
  });

  newDestNotifier.newDestinationList = _newDestinationList;
}
