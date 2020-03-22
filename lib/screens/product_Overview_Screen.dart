import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/product_grid.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductState();
  }
}

class ProductState extends State<ProductOverviewScreen> {
  bool isFav = false;
  bool isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      isLoading = true;
      Provider.of<Products>(context, listen: false).fetchandset().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      await Provider.of<Products>(context, listen: false).fetchandset();
    }

    // TODO: implement build
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 0,
                child: Text('Show Favourites'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Show All'),
              ),
            ],
            onSelected: (int value) {
              setState(() {
                if (value == 0) {
                  isFav = true;
                } else {
                  isFav = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (context, cartItem, child) {
              return Badge(child: child, value: cartItem.itemCount.toString());
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.supervised_user_circle),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 0,
                child: Text('Sign Out'),
              ),
            ],
            onSelected: (int value) {
              setState(() {
                Provider.of<Auth>(context, listen: false).signout();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ProductGrid(isFav),
              ),
      ),
    );
  }
}
