import 'package:flutter/material.dart';
import 'listproj.dart';
import 'mycreatedissues.dart';
import 'assignedissues.dart';
import 'members.dart';

class MyBottomNavigation extends StatefulWidget {
  final String token;
  final dynamic profile;
  MyBottomNavigation({@required this.token, @required this.profile});
  @override
  _MyBottomNavigationState createState() =>
      _MyBottomNavigationState(token: token, profile: profile);
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  final String token;
  final dynamic profile;
  _MyBottomNavigationState({@required this.token, @required this.profile});
  int _selectedIndex = 0;
  List<Widget> _Screens = [Center(child: Text('Login Successful'))];
  @override
  void initState() {
    super.initState();

    _Screens = [
      ListProjects(
        token: token,
        profile: profile,
      ),
      MyCreatedIssues(
        token: token,
        profile: profile,
      ),
      AssignedIssues(
        token: token,
        profile: profile,
      ),
      Members(
        token: token,
        profile: profile,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.blue[900],
              icon: Icon(Icons.folder),
              title: Text('Projects')),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue[900],
              icon: Icon(Icons.bug_report),
              title: Text('My Issues')),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue[900],
              icon: Icon(Icons.work),
              title: Text('Assigned Issues')),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue[900],
              icon: Visibility(
                  visible: profile[0]['status'] == 'Admin',
                  child: Icon(Icons.people)),
              title: Text('Members'))
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
