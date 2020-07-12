import 'package:flutter/material.dart';
import 'login.dart';

import 'brain.dart';
import 'mybottom.dart';

var brainObj = Brain();

class Decider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: brainObj.checkToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['token'] != '') {
                if (snapshot.data['profile'][0]['isBlocked'] == true) {
                  return Login(
                    logout: false,
                    blocked: true,
                  );
                }
                return MyBottomNavigation(
                  token: snapshot.data['token'],
                  profile: snapshot.data['profile'],
                );
              } else {
                return Login(
                  logout: false,
                  blocked: false,
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching Token Storage Details'),
              );
            }
            return Scaffold(
              backgroundColor: Colors.blue[900],
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bug_report,
                        color: Colors.white,
                        size: 70.0,
                      ),
                      Text(
                        'Spuggy',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50.0,
                            fontFamily: 'Galada'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    'Bug Tracking is now simple',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
