import 'dart:collection';
import 'package:flutter/cupertino.dart';
import '../models/rating_model.dart';

class RatingNotifier with ChangeNotifier {
  List<Rating> _ratingList = [];
  Rating _currentrating;

  UnmodifiableListView<Rating> get ratingList =>
      UnmodifiableListView(_ratingList);
  Rating get currentRating => _currentrating;

  set ratingList(List<Rating> ratingList) {
    _ratingList = ratingList;
    notifyListeners();
  }

  set currentRating(Rating rating) {
    _currentrating = rating;
    notifyListeners();
  }

  addRating(Rating rating) {
    _ratingList.insert(0, rating);
    notifyListeners();
  }
}
