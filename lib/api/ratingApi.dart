import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../allNotifier/ratingNotifier.dart';
import '../models/rating_model.dart';

ratingAdd(String idItem, String email, int rating) async {
  try {
    Firestore.instance.collection("rating").add({
      'idItem': idItem,
      'email': email,
      'rating': rating,
    });

    return rating.toString();
  } catch (e) {
    return null;
  }
}

Future<int> getValidRating(String email, String idItem) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('rating')
      .where('email', isEqualTo: email)
      .where('idItem', isEqualTo: idItem)
      .limit(1)
      .getDocuments();
  int banyakData = snapshot.documents.length;
  // print("hasil :" + banyakData.toString());
  return banyakData;
}

Future<double> getAllrating(String idItem) async {
  List total = [];
  var result;
  var rat = await Firestore.instance
      .collection('rating')
      .where('idItem', isEqualTo: idItem)
      .getDocuments()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.documents.forEach((doc) {
      print('hasil data: ' + doc["rating"].toString());
      // var tot = doc["rating"];
      total.add(doc['rating']);
      var grandTot = total.reduce((a, b) => a + b);
      // print("" + grandTot.toString());
      result = grandTot / total.length;
    });

    return result;
  });

  print("rating :" + rat.toString());
  double grantot = double.parse((rat).toStringAsFixed(1));
  return grantot;
}
