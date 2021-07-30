import 'dart:collection';

import 'package:flutter/cupertino.dart';
import '../models/destination_model.dart';

class DestinationNotifier with ChangeNotifier {
  List<Destination> _destinationList = [];
  Destination _currentDestination;

  UnmodifiableListView<Destination> get destinationList =>
      UnmodifiableListView(_destinationList);
  Destination get currentDestination => _currentDestination;

  set destinationList(List<Destination> destinationList) {
    _destinationList = destinationList;
    notifyListeners();
  }

  set currentDestination(Destination destination) {
    _currentDestination = destination;
    notifyListeners();
  }
}
