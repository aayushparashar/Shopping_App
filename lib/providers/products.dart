import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<product> _items = [ ];

  List<product> get items {
    return [..._items];
  }

  List<product> get FavouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  final String token;
  final String userId;
  Products(this.token, this.userId, this._items);
  Future<void> fetchandset([bool sortByUser = false]) async {
    String fetchUser = sortByUser ? 'orderBy="creatorId"&equalTo="$userId"': '';

    var url = 'https://flutter-shopapp-6b5e0.firebaseio.com/products.json?auth=$token&$fetchUser';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<product> loadedData = [];

      url =  'https://flutter-shopapp-6b5e0.firebaseio.com/favourites/$userId.json?auth=$token';
      final fav = await http.get(url);
      final favData = json.decode(fav.body);

      extractedData.forEach((proId, prodData) {
        loadedData.add(product(id: proId,
          description: prodData['description'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavourite: favData ==null? false: favData[proId]?? false,));
      });
      _items = loadedData;
    } catch (error) {
      throw error;
    }
  }

  product searchById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(product Product) async {
    final url = 'https://flutter-shopapp-6b5e0.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': Product.title,
            'description': Product.description,
            'imageUrl': Product.imageUrl,
            'isFavourite': Product.isFavourite,
            'price': Product.price,
            'creatorId': userId,
          }));

      product newPro = product(
          title: Product.title,
          id: json.decode(response.body)['name'],
          price: Product.price,
          description: Product.description,
          imageUrl: Product.imageUrl,
          isFavourite: Product.isFavourite);
      _items.add(newPro);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, product Product) async{
    int idx = _items.indexWhere((prod) => prod.id == id);
    final url = 'https://flutter-shopapp-6b5e0.firebaseio.com/products/$id.json?auth=$token';
    await http.patch(url, body: json.encode({
      'title': Product.title,
      'description': Product.description,
      'imageUrl': Product.imageUrl,
      'price': Product.price,
    }));
    _items[idx] = Product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://flutter-shopapp-6b5e0.firebaseio.com/products/$id.json?auth=$token';
    final idx = _items.indexWhere((prod)=> prod.id == id);
    var pro = _items[idx];
    _items.removeAt(idx);

    final response = await http.delete(url);

    if(response.statusCode>=400){
      _items.insert(idx, pro);
      throw Exception('Cannot delete');
    }

    pro = null;
    notifyListeners();
  }
}
