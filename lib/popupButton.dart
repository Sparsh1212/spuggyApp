import 'package:flutter/material.dart';
import 'brain.dart';
import 'login.dart';

var brainObj = Brain();

class PopupButton {
  Widget popupList(
    String name,
    String branch,
    String username,
    String status,
    int currentYear,
  ) {
    return PopupMenuButton(
      color: Colors.purple[200],
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Container(
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Hello $name',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  branch,
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 15.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      '@$username',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 15.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Status:  $status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  'Current Year:  $currentYear',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: FlatButton(
            color: Colors.purple,
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
                            message: 'You have been Successfully logged out',
                          )));
            },
          ),
        ),
      ],
    );
  }
}
