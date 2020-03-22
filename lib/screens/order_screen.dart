import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: drawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
            future: Provider.of<Order>(context, listen: false).fetchandset(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return RefreshIndicator(
                  onRefresh: () {
                    return Provider.of<Order>(context, listen: false)
                        .fetchandset();
                  },
                  child: Consumer<Order>(builder: (ctx, orders, child) {
                    return orders.orders.length ==0 ? Center(child: Text('You have ordered nothing till now!')): ListView.builder(
                      itemBuilder: (context, index) {
                        return OrderItem(orders.Orders[index]);
                      },
                      itemCount: orders.Orders.length,
                    );
                  }),
                );
              }
            }));
  }
}
