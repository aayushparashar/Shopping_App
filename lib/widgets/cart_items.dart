import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  String id;
  String productId;
  String title;
  double price;
  int quantity;

  CartItems({this.id, this.productId, this.title, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
        background: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          color: Theme.of(context).errorColor,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) {
          return showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to delete current product?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                );
              });
        },
        onDismissed: (_) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        key: ValueKey(id),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: EdgeInsets.all(2),
              child: FittedBox(
                child: Text('\$${price}'),
              ),
            )),
            title: Text('$title'),
            subtitle: Text('\$${(quantity * price)}'),
            trailing: Text('$quantity x'),
          ),
        ));
  }
}
