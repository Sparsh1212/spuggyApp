import 'brain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'listproj.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
          title: Text('Login to Spuggy'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter Username',
                    border: OutlineInputBorder(),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FlatButton(
                color: Colors.blue,
                child: Text('Login'),
                onPressed: () async {
                  var username = usernameController.text;
                  var password = passwordController.text;
                  var token = await brainObj.fetchToken(username, password);
                  if (token != null) {
                    await storage.write(key: 'token', value: token);

                    var profile = await brainObj.fetchProfile(token);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListProjects(
                                  token: token,
                                  profile: profile,
                                )));
                  } else {
                    loginFailure();
                  }
                },
              ),
            )
          ],
        ));
  }
}
