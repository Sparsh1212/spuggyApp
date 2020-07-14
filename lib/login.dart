import 'package:spuggyflutter/mybottom.dart';

import 'brain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'webview.dart';
import 'common.dart';

class Login extends StatefulWidget {
  final bool logout;
  final bool blocked;
  Login({@required this.logout, @required this.blocked});
  @override
  _LoginState createState() => _LoginState(logout: logout, blocked: blocked);
}

class _LoginState extends State<Login> {
  final bool logout;
  final bool blocked;
  _LoginState({@required this.logout, @required this.blocked});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final storage = FlutterSecureStorage();
  Brain brainObj = Brain();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final snackloginattempt = SnackBar(
    duration: const Duration(seconds: 3),
    content: Row(
      children: [
        CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
        SizedBox(
          width: 15.0,
        ),
        Text('Attempting Login'),
      ],
    ),
  );

  final loginSuccessful = SnackBar(
    duration: const Duration(seconds: 1),
    content: Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.green[400],
          size: 25.0,
        ),
        SizedBox(
          width: 15.0,
        ),
        Text('Login Successful')
      ],
    ),
  );

  final snackaccessBlocked = SnackBar(
    duration: const Duration(seconds: 1),
    content: Row(
      children: [
        Icon(
          Icons.not_interested,
          color: Colors.red[900],
          size: 25.0,
        ),
        SizedBox(
          width: 15.0,
        ),
        Text('Access Blocked')
      ],
    ),
  );

  final invalid_credentials = SnackBar(
    duration: const Duration(seconds: 1),
    content: Row(
      children: [
        Icon(
          Icons.cancel,
          color: Colors.red[900],
          size: 25.0,
        ),
        SizedBox(
          width: 15.0,
        ),
        Text('Invalid Credentials')
      ],
    ),
  );

  final logoutSuccess = SnackBar(
    duration: const Duration(seconds: 1),
    content: Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.green[500],
          size: 25.0,
        ),
        SizedBox(
          width: 15.0,
        ),
        Text('Logout Successful')
      ],
    ),
  );

  void displayLogoutSnack(bool l) {
    if (l) {
      _scaffoldKey.currentState.showSnackBar(logoutSuccess);
    } else if (blocked) {
      _scaffoldKey.currentState.showSnackBar(snackaccessBlocked);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => displayLogoutSnack(logout));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Login',
            style: whiteBold,
          ),
          backgroundColor: Colors.blue[900],
        ),
        body: Builder(
            builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: usernameController,
                          decoration: textFieldDecoration.copyWith(
                              hintText: 'Username',
                              prefixIcon: Icon(Icons.person)),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: passwordController,
                        decoration: textFieldDecoration.copyWith(
                            hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue[900])),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.blue[900], fontSize: 15.0),
                            ),
                            onPressed: () async {
                              Scaffold.of(context)
                                  .showSnackBar(snackloginattempt);
                              var username = usernameController.text;
                              var password = passwordController.text;
                              var token =
                                  await brainObj.fetchToken(username, password);
                              if (token != null) {
                                var profile =
                                    await brainObj.fetchProfile(token);
                                if (profile[0]['isBlocked'] == true) {
                                  Scaffold.of(context)
                                      .showSnackBar(snackaccessBlocked);
                                  await new Future.delayed(
                                      const Duration(seconds: 3));
                                } else {
                                  Scaffold.of(context)
                                      .showSnackBar(loginSuccessful);
                                  await Future.delayed(
                                      const Duration(seconds: 3));
                                  await storage.write(
                                      key: 'token', value: token);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyBottomNavigation(
                                                token: token,
                                                profile: profile,
                                              )));
                                }
                              } else {
                                Scaffold.of(context)
                                    .showSnackBar(invalid_credentials);
                              }
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.purple)),
                            child: Text(
                              'Omniport Login',
                              style: TextStyle(
                                  color: Colors.purple, fontSize: 15.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebView()));
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )));
  }
}
