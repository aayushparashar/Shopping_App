import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthState();
  }
}

class _AuthState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  var _form = GlobalKey<FormState>();
  var _pwd = TextEditingController();
  Animation<double> animation;
  AnimationController _controller;
  bool login = true;
  Map<String, String> details = {
    'email': null,
    'password': null,
  };

  void toggle() {
    if (login) {
      setState(() {
        login = !login;
      });
      _controller.forward();
    } else {
      setState(() {
        login = !login;
      });
      _controller.reverse();
    }
  }

  bool _isLoading = false;
  bool _googleLoading = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
    // TODO: implement initState
    super.initState();
  }

  Future<void> authenticate() async {
    _form.currentState.validate();
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (login) {
        await Provider.of<Authenticate>(context, listen: false)
            .signin(details['email'], details['password']);
      } else {
        await Provider.of<Authenticate>(context, listen: false)
            .signUp(details['email'], details['password']);
      }
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/background.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: login ? deviceSize.height * 0.75 : deviceSize.height * 0.85,
            width: deviceSize.width * 0.8,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email cannot be empty.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            details['email'] = value;
                          },
                        ),
                        TextFormField(
                          controller: _pwd,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password cannot be empty.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            details['password'] = value;
                          },
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          constraints: BoxConstraints(
                            maxHeight: login ? 0 : 120,
                            minHeight: login ? 0 : 80,
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Enter your password',
                              ),
                              validator: (value) {
                                if (!login && value.isEmpty) {
                                  return 'Password cannot be empty.';
                                }
                                if (value != _pwd.text) {
                                  return 'Password is not same.';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: authenticate,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(login ? 'Login' : 'Sign Up')),
                  Divider(),
                  FlatButton(
                    onPressed: toggle,
                    child: Text(
                      !login ? 'Login Instead' : 'Sign-up instead',
                    ),
                  ),
                  FlatButton.icon(
                    icon: Image(
                      image: AssetImage(
                        'images/google.png',
                      ),
                      fit: BoxFit.contain,
                      height: 30,
                      width: 30,
                    ),
                    label: _googleLoading
                        ? CircularProgressIndicator()
                        : Text('Sign-in With Google'),
                    onPressed: () async {
                      setState(() {
                        _googleLoading = true;
                      });
                      await Provider.of<Authenticate>(context, listen: false)
                          .google_signin()
                          .catchError((error) {
                        print('** $error');
                      });
                      setState(() {
                        _googleLoading = false;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
