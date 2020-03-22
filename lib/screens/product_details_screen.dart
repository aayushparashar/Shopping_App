import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments;
    product loadedProduct =
        Provider.of<Products>(context, listen: false).searchById(mealId);
    // TODO: implement build
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProduct.title, textAlign: TextAlign.center,),
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Text(
                    '\$${loadedProduct.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  flatButton(loadedProduct),
                  SizedBox(height: 800,),
                ],
              ),
            ),
          ],

    ));
  }
}

class flatButton extends StatelessWidget {
  final _selected;

  flatButton(this._selected);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
        hoverColor: Theme.of(context).accentColor,
        onPressed: () {
          Provider.of<Cart>(context, listen: false)
              .addItem(_selected.id, _selected.price, _selected.title);
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Added to the cart'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                Provider.of<Cart>(context, listen: false)
                    .removeSingleItem(_selected.id);
              },
            ),
          ));
        },
        child: Text(
          'Buy Now',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ));
  }
}
