import 'package:flutter/material.dart';
import 'brain.dart';
import 'listissues.dart';
import 'mycreatedissues.dart';
import 'assignedissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login.dart';
import 'package:flutter_html/flutter_html.dart';
import 'members.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ListProjects extends StatelessWidget {
  final brainObj = Brain();
  final String token;
  final dynamic profile;
  ListProjects({@required this.token, @required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('All Projects'),
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
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
                        'Hello ${profile[0]['name']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        profile[0]['branch'],
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
                            '@${profile[0]['username']}',
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
                            'Status:  ${profile[0]['status']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Current Year:  ${profile[0]['current_year']}',
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ),
            ],
          )
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Hello ${profile[0]['name']}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      profile[0]['branch'],
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          '@${profile[0]['username']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Status:  ${profile[0]['status']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Current Year:  ${profile[0]['current_year']}',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('All Projects'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListProjects(
                                token: token,
                                profile: profile,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.report_problem),
                title: Text('Raised Issues'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyCreatedIssues(
                                token: token,
                                profile: profile,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.work),
                title: Text('Assigned Issues'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssignedIssues(
                                token: token,
                                profile: profile,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Members'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Members(
                                token: token,
                                profile: profile,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_forward_ios),
                title: Text('Logout'),
                onTap: () async {
                  await brainObj.logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: brainObj.fetchProjs(token),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              snapshot.data[index]['project_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'TESTING PROCEDURE',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Html(
                              data: snapshot.data[index]['testing_procedure'],
                            ),
                            //Text(snapshot.data[index]['testing_procedure']),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: FlatButton(
                                child: Text(
                                  'View Details',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListIssues(
                                                token: token,
                                                projectId: snapshot.data[index]
                                                    ['id'],
                                              )));
                                }),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError == true) {
            return Center(
              child: Text('Error Fetching Projects'),
            );
          }
          return Center(
            child: SpinKitWave(
              color: Colors.purple,
            ),
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        color: Colors.purple,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.purple,
        index: 0,
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
      ),
    );
  }
}
