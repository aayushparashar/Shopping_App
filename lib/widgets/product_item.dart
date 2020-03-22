import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<product>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);
    // TODO: implement build
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            leading: Consumer<product>(
                builder: (ctx, product, child) => IconButton(
                      icon: Icon(_product.isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        _product.toggleFavourite(_auth.token, _auth.userId);
                      },
                      color: _product.isFavourite ? Colors.red : Colors.white,
                    )),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                _cart.addItem(_product.id, _product.price, _product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to the cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      _cart.removeSingleItem(_product.id);
                    },
                  ),
                ));
              },
            ),
            title: Text(_product.title),
            backgroundColor: Colors.black54,
          ),
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProductDetails.routeName,
                    arguments: _product.id);
              },
              child: Hero(
                tag: _product.id,
                child: FadeInImage(
                  placeholder: AssetImage('images/product-placeholder.png'),
                  image: NetworkImage(_product.imageUrl),
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.easeIn,
                ),
              )),
        ));
  }
}
