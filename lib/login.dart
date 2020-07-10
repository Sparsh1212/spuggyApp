import 'brain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'listproj.dart';
import 'webview.dart';
import 'common.dart';

class Login extends StatefulWidget {
  final String message;
  Login({@required this.message});
  @override
  _LoginState createState() => _LoginState(message: message);
}

class _LoginState extends State<Login> {
  final String message;
  _LoginState({this.message});
  void loginFailure() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('Please Try again with the correct credentials'),
            ));
  }

  final storage = FlutterSecureStorage();
  Brain brainObj = Brain();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Login',
            style: whiteBold,
          ),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: usernameController,
                  decoration: textFieldDecoration.copyWith(
                      hintText: 'Username', prefixIcon: Icon(Icons.person)),
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
                      style: TextStyle(color: Colors.blue[900], fontSize: 20.0),
                    ),
                    onPressed: () async {
                      var username = usernameController.text;
                      var password = passwordController.text;
                      var token = await brainObj.fetchToken(username, password);
                      if (token != null) {
                        var profile = await brainObj.fetchProfile(token);
                        if (profile[0]['isBlocked'] == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login(
                                        message: 'Your access is blocked !',
                                      )));
                        } else {
                          await storage.write(key: 'token', value: token);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListProjects(
                                        token: token,
                                        profile: profile,
                                      )));
                        }
                      } else {
                        loginFailure();
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
                      style: TextStyle(color: Colors.purple, fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WebView()));
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
            )
          ],
        ));
  }
}
