import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/auth.dart';
import 'package:oyebusyapp/providers/students.dart';
import 'package:oyebusyapp/screens/bottom_navifation_bar.dart';
import 'package:oyebusyapp/screens/email_verification_screen.dart';
import 'package:oyebusyapp/screens/verification_screen.dart';
import 'screens/authscreen.dart';
import 'package:oyebusyapp/screens/edit_student_details.dart';
import 'package:oyebusyapp/screens/email_input.dart';
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
          update: (context, auth, previousData) => StudentList(auth.userId),
        ),
      ],
      child: MaterialApp(
        routes: {
          EditStudentScreen.routeName: (ctx) => EditStudentScreen(),
          VerificationScreen.routeName: (ctx) => VerificationScreen(),
          EmailVerification.routeName: (ctx) => EmailVerification(),
        },
        debugShowCheckedModeBanner: false,
        title: 'OyeBusy',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.white,
          textSelectionColor: Colors.white,
        ),
        home: Consumer<Authenticate>(builder: (context, auth, _) {
          return auth.auth
              ?
            auth.user.email==null
                    ? EmailScreen()
                    : auth.emailverified ? Navigation() : EmailVerification()
              : AuthScreen();
        }),
      ),
    );
  }
}
