import 'package:animated_splash/animated_splash.dart';
import 'package:flutter/material.dart';
import 'package:stickmanservices/providers/auth.dart';
import 'package:stickmanservices/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:stickmanservices/screens/welcome_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Authenticate(),
      child: MaterialApp(
        title: 'StickMan Services',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber,
        ),
        home: AnimatedSplash(
          home: Consumer<Authenticate>(
              builder: (context, auth, _) =>
                  auth.auth ? WelcomeScreen(auth.user) : AuthScreen()),
          imagePath: 'images/logo.png',
          duration: 2500,
          type: AnimatedSplashType.StaticDuration,
        ),
      ),
    );
  }
}
