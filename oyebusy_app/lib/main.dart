import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/auth.dart';
import 'package:oyebusyapp/providers/students.dart';
import 'package:oyebusyapp/screens/auth_screen.dart';
import 'package:oyebusyapp/screens/edit_student_details.dart';
import 'package:oyebusyapp/screens/student_list_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider.value(
          value: Authenticate(),
        ),
        ChangeNotifierProxyProvider<Authenticate, StudentList>(
          update: (context, auth, previousData)=> StudentList(auth.userId),
        ),
      ],
      child: MaterialApp(
          routes: {
            EditStudentScreen.routeName: (ctx) => EditStudentScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'OyeBusy',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.pinkAccent,
          ),
          home: Consumer<Authenticate>(
            builder: (context, auth, _) =>
                auth.auth ? StudentListScreen() : AuthScreen(),
          )),
    );
  }
}
