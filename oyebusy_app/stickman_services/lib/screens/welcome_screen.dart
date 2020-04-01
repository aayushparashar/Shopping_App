import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickmanservices/providers/auth.dart';

class WelcomeScreen extends StatelessWidget {
  final FirebaseUser user;
  String imageurl;
  String nickname;

  Future<void> setValues() async {
    print('Seting values: ');
    imageurl = await FirebaseStorage.instance
        .ref()
        .child(user.uid.toString())
        .getDownloadURL();
    print(imageurl);
    final extractedData = await FirebaseDatabase.instance
        .reference()
        .child('userProfile')
        .child(user.uid.toString())
        .once();

    print(extractedData.value);
    nickname = extractedData.value['nickname'];
    print(nickname);
  }

  WelcomeScreen(this.user);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Stickman Services'),
        ),
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            Container(
              height: 300,
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'STICKMAN SERVICES',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                Provider.of<Authenticate>(context, listen: false).logout();
              },
            ),
            Divider(),
          ],
        )),
        body: FutureBuilder(
          future: setValues(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Color.fromRGBO(250, 0, 100, 1),
                      ],
                      stops: [0, 1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                    height: deviceSize.height * 0.9,
                    width: deviceSize.width,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 120,
                            backgroundImage: NetworkImage(imageurl),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            'Hi $nickname!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 50,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            'Welcome to Stickman Services!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ))
                        ],
                      ),
                    ));
          },
        ));
  }
}
