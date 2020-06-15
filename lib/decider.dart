import 'package:flutter/material.dart';
import 'login.dart';
import 'listproj.dart';
import 'brain.dart';

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
                  return Login(message: 'Your access has been blocked');
                }
                return ListProjects(
                  token: snapshot.data['token'],
                  profile: snapshot.data['profile'],
                );
              } else {
                return Login(
                  message: '',
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching Token Storage Details'),
              );
            }
            return Scaffold(
              backgroundColor: Colors.purple,
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
                        'SPUGGY',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '- The best bug tracker application',
                    style: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                  )
                ],
              ),
            );
          }),
    );
  }
}
