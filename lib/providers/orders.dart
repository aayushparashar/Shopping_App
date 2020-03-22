import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems({this.id, this.amount, this.products, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItems> orders = [];
  final String token;
  final String userId;
  Order(this.token, this.userId, this.orders);

  Future<void> addOrder(List<CartItem> list, double total) async{
    final url = 'https://flutter-shopapp-6b5e0.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      final response = await http.post(url, body: json.encode({
        'amount': total,
        'products': list.map((cd)=> {
          'title': cd.title,
          'id': cd.id,
          'quantity': cd.quantity,
          'price': cd.price
        }).toList(),
        'dateTime': DateTime.now().toIso8601String(),
      }));
      orders.insert(
          0,
          OrderItems(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: DateTime.now(),
            products: list,
          ));
    }catch(error){
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchandset() async{

    final url = 'https://flutter-shopapp-6b5e0.firebaseio.com/orders/$userId.json?auth=$token';
    try{
      final response = await http.get(url);

      List<OrderItems> ll = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if(data==null){
        return;
      }
      data.forEach((id, orderData){
        List<CartItem> temp = [];
        orderData['products'].forEach((map){
            temp.add(CartItem(
            id: map['id'],
            price: map['price'],
            title: map['title'],
            quantity: map['quantity'],
          ));
        });
        ll.insert(0, OrderItems(
          id: id,
          dateTime: DateTime.parse(orderData['dateTime']),
          amount: orderData['amount'],
          products: temp,
        ));
      });
      this.orders = ll;
      notifyListeners();
    }catch(error){
      throw error;
    }



  }

  List<OrderItems> get Orders{
    return [...orders];
  }
}
