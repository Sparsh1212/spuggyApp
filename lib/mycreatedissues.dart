import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'listproj.dart';
import 'assignedissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login.dart';

class MyCreatedIssues extends StatelessWidget {
  final brainObj = Brain();
  final String token;
  final dynamic profile;
  MyCreatedIssues({@required this.token, @required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Raised Issues'),
        backgroundColor: Colors.purple,
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: [
              DrawerHeader(
                child: Center(
                    child: Text(
                  'Hello User',
                  style: TextStyle(color: Colors.white),
                )),
                decoration: BoxDecoration(
                  color: Colors.purple[900],
                ),
              ),
              ListTile(
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
                title: Text('My Raised Issues'),
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
                title: Text('Issues Assigned To me'),
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
                title: Text('Members'),
              ),
              ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    await brainObj.logout();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  })
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: brainObj.fetchMyCreatedIssues(token),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data[index]['issue_title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Status: ${snapshot.data[index]['issue_status']}',
                              style: TextStyle(
                                color: Colors.orange[900],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(snapshot.data[index]['created_by']),
                              ],
                            ),
                          ),
                          FlatButton(
                            color: Colors.blue,
                            child: Text(
                              'View Details',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IssueDetail(
                                            token: token,
                                            issue: snapshot.data[index],
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError == true) {
            return Center(
              child: Text('Error Fetching Issues'),
            );
          }
          return Center(
            child: SpinKitWave(
              color: Colors.purple,
            ),
          );
        },
      ),
    );
  }
}
