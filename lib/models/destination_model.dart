import 'package:lobardestination/models/activity_model.dart';

class Destination {
  String idItem;
  String emailUser;
  String name;
  String country;
  String village;
  String description;
  String status;
  String image;
  String longitude;
  String latitude;
  // String city;
  // String country;
  // String description;

  Destination();

  Destination.fromMap(Map<String, dynamic> data) {
    idItem = data['idItem'];
    emailUser = data['emailUser'];
    name = data['name'];
    country = data['country'];
    village = data['village'];
    description = data['description'];
    status = data['status'];
    image = data['image'];
    longitude = data['longitude'];
    latitude = data['latitude'];
  }

  Map<String, dynamic> toMap() {
    return {
      'idItem': idItem,
      'emailUser': emailUser,
      'name': name,
      'country': country,
      'village': village,
      'description': description,
      'status': status,
      'image': image,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
