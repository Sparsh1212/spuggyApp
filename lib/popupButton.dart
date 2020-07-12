import 'package:flutter/material.dart';
import 'package:spuggyflutter/profile.dart';
import 'brain.dart';
import 'login.dart';
import 'profile.dart';

var brainObj = Brain();

class PopupButton {
  Widget popupList(dynamic profile) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              profile: profile,
                            )));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        'https://api.adorable.io/avatars/283/${profile[0]['username']}@adorable.png'),
                    radius: 20.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Text('My Profile'),
                ],
              ),
            )),
        PopupMenuItem(
          value: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: FlatButton(
              color: Colors.blue[900],
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await brainObj.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login(
                              logout: true,
                              blocked: false,
                            )));
              },
            ),
          ),
        ),
      ],
    );
  }
}
