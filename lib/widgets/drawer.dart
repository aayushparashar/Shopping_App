import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            height: 200,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('MY SHOP',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ))),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
             Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/');
             Provider.of<Auth>(context, listen: false).signout();
            },
          )
        ],
      ),
    );
  }
}
