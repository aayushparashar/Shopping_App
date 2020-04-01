import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stickmanservices/providers/auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthState();
  }
}

class _AuthState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  Size deviceSize;
  bool login = true;
  bool _isLoading = false;
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didChangeDependencies() {
    deviceSize = MediaQuery.of(context).size;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      reverseDuration: Duration(milliseconds: 300),
      duration: Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // TODO: implement initState
    super.initState();
  }

  var _form = GlobalKey<FormState>();
  Map<String, String> details = {
    'email': null,
    'password': null,
    'nickname': null,
  };

  void toggle() {
    if (login) {
      _controller.forward();
      setState(() {
        login = !login;
      });
    } else {
      _controller.reverse();
      setState(() {
        login = !login;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> submit() async {
    bool valid = _form.currentState.validate();

    if (!login && _pickedImage == null) {
      _showErrorDialog('Image not chosen');
    }
    if (!valid || (!login && _pickedImage == null)) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });
    try {
      if (login) {
        await Provider.of<Authenticate>(context, listen: false)
            .signin(details['email'], details['password'], details['nickname']);
      } else {
        await Provider.of<Authenticate>(context, listen: false).signup(
            details['email'],
            details['password'],
            details['nickname'],
            _pickedImage);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> pickImage() async {
    var _currImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = _currImage;
    });
  }

  File _pickedImage;
  var _pwdcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Image.asset(
              'images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                padding: EdgeInsets.all(10),
                height:
                    login ? deviceSize.height * 0.78 : deviceSize.height * 0.88,
                width: deviceSize.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        'images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Form(
                      key: _form,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter the email'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                details['email'] = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nickname',
                                hintText: 'Enter your nickname',
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Nickname cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                details['nickname'] = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter the password'),
                              keyboardType: TextInputType.text,
                              controller: _pwdcontroller,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                details['password'] = value;
                              },
                            ),
                            SizedBox(height: 10),
                            AnimatedContainer(
                              padding: EdgeInsets.only(top: 10),
                              curve: Curves.easeIn,
                              constraints: BoxConstraints(
                                minHeight: login ? 0 : 60,
                                maxHeight: login ? 0 : 120,
                              ),
                              duration: Duration(milliseconds: 300),
                              child: FadeTransition(
                                  opacity: animation,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                        ),
                                        child: _pickedImage == null
                                            ? Image.asset(
                                                'images/placeholder.jpg',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                _pickedImage,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      FlatButton.icon(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 15,
                                        ),
                                        label: Text('Pick An Image'),
                                        color: Theme.of(context).accentColor,
                                        onPressed: pickImage,
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: submit,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              login ? 'Login' : 'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                      color: Theme.of(context).primaryColor,
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: toggle,
                      child: Text(login ? 'Signup instead' : 'Login instead'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
