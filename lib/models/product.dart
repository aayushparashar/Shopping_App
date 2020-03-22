import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class product with ChangeNotifier {
  String id;
  String description;
  String title;
  String imageUrl;
  double price;
  bool isFavourite;

  void toggleFavourite(String token, String userId) async {
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-shopapp-6b5e0.firebaseio.com/favourites/$userId/$id.json?auth=$token';
    final response = await http.put(url,
        body: json.encode(
          this.isFavourite,
        ));
    if (response.statusCode >= 400) {
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }

  product(
      {@required this.id,
      @required this.description,
      @required this.title,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false});
}
