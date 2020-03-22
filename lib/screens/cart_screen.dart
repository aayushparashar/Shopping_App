import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart_details = Provider.of<Cart>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.title,
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(
                    '\$${cart_details.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OrderWidget(cart_details),
              ],
            ),
          )),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, idx) {
              return CartItems(
                id: cart_details.items.values.toList()[idx].id,
                title: cart_details.items.values.toList()[idx].title,
                quantity: cart_details.items.values.toList()[idx].quantity,
                price: cart_details.items.values.toList()[idx].price,
                productId: cart_details.items.keys.toList()[idx],
              );
            },
            itemCount: cart_details.items.length,
          ))
        ],
      ),

    );
  }
}

class OrderWidget extends StatefulWidget {
  final cart_details;

  OrderWidget(this.cart_details);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderState();
  }
}

class OrderState extends State<OrderWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
        onPressed: widget.cart_details.totalAmount <= 0
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });

                await Provider.of<Order>(context, listen: false).addOrder(
                    widget.cart_details.items.values.toList(),
                    widget.cart_details.totalAmount);

                setState(() {
                  _isLoading = false;
                });
                widget.cart_details.clear();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Order Now!',
                style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontWeight: FontWeight.bold,
                ),
              ));
  }
}
