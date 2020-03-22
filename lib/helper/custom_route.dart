import 'package:flutter/material.dart';

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if (settings.isInitialRoute) {
      return child;
    } else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}
class CustomPageTransitionBuilder extends PageTransitionsBuilder{

  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if (route.settings.isInitialRoute) {
      return child;
    } else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}
