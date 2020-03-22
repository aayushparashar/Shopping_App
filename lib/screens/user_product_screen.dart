import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_input_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh(BuildContext context) async {
      await Provider.of<Products>(context, listen: false).fetchandset(true);
    }

    final productData = Provider.of<Products>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, EditInputScreen.routeName);
              }),
        ],
      ),
      drawer: drawer(),
      body: FutureBuilder(
          future: _refresh(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refresh(context),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: productData.items.length ==0 ? Center(child: Text('You have added no products till now!')):ListView.builder(
                          itemBuilder: (ctx, idx) {
                            return UserProductItem(
                                productData.items[idx].id,
                                productData.items[idx].title,
                                productData.items[idx].imageUrl);
                          },
                          itemCount: productData.items.length,
                        ),
                      ),
                    )),
    );
  }
}
