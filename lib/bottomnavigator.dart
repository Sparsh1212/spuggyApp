import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'listproj.dart';
import 'mycreatedissues.dart';
import 'assignedissues.dart';
import 'members.dart';

class BottomNavigator {
  Widget bottomNavigator(
      String token, dynamic profile, int index, BuildContext context) {
    return CurvedNavigationBar(
      height: 50.0,
      color: Colors.purple,
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.purple,
      index: index,
      items: <Widget>[
        Icon(
          Icons.folder,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.bug_report,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.work,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.people,
          size: 30,
          color: Colors.white,
        ),
      ],
      animationDuration: Duration(milliseconds: 200),
      onTap: (int index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ListProjects(
                        token: token,
                        profile: profile,
                      )));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyCreatedIssues(
                        token: token,
                        profile: profile,
                      )));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AssignedIssues(
                        token: token,
                        profile: profile,
                      )));
        } else if (index == 3) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Members(
                        token: token,
                        profile: profile,
                      )));
        }
      },
    );
  }
}
