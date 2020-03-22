import 'package:flutter/material.dart';
import 'package:shop_app/helper/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_input_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_Overview_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, previousData) => Products(
              auth.token,
              auth.userId,
              previousData == null ? [] : previousData.items,
            ),
//            value: Products(),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, auth, previous) => Order(auth.token, auth.userId,
                previous == null ? [] : previous.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, data, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Shop App',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),

                })
              ),
              home: data.auth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: data.autoLogin(),
                      builder: (ctx, snapShot) =>
                          snapShot.connectionState == ConnectionState.waiting
                              ? Scaffold(
                                  appBar: AppBar(title: Text('Shop')),
                                  body: Center(child: Text('Loading')),
                                )
                              : AuthScreen()),
              routes: {
                ProductDetails.routeName: (ctx) => ProductDetails(),
                CartScreen.routeName: (_) => CartScreen(),
                OrderScreen.routeName: (_) => OrderScreen(),
                UserProductScreen.routeName: (_) => UserProductScreen(),
                EditInputScreen.routeName: (_) => EditInputScreen(),
              },
            );
          },
        ));
  }
}
