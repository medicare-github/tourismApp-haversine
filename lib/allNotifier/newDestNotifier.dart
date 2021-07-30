import 'dart:collection';

import 'package:flutter/cupertino.dart';
import '../models/destination_model.dart';

class NewDestNotifier with ChangeNotifier {
  List<Destination> _newDestinationList = [];
  Destination _currentNewDest;

  UnmodifiableListView<Destination> get newDestinationList =>
      UnmodifiableListView(_newDestinationList);
  Destination get currentNewDest => _currentNewDest;

  set newDestinationList(List<Destination> newDestList) {
    _newDestinationList = newDestList;
    notifyListeners();
  }

  set currentNewDest(Destination destination) {
    _currentNewDest = destination;
    notifyListeners();
  }
}
