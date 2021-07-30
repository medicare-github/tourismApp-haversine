class Rating {
  String idItem;
  String email;
  int rating;

  Rating();

  Rating.forMap(Map<String, dynamic> data) {
    idItem = data['idItem'];
    email = data['email'];
    rating = data['rating'];
  }
  Map<String, dynamic> toMap() {
    return {
      'idItem': idItem,
      'email': email,
      'rating': rating,
    };
  }
}
