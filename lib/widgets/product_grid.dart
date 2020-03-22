import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {

  final bool _isFavourite;
  ProductGrid(this._isFavourite);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    final _prolist = _isFavourite? product.FavouriteItems: product.items;

    // TODO: implement build
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            value: _prolist[index],
            child: ProductItem());
      },
      itemCount: _prolist.length,
    );
  }
}
