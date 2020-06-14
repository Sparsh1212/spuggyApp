import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'listproj.dart';
import 'mycreatedissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class AssignedIssues extends StatefulWidget {
  final String token;
  final dynamic profile;
  AssignedIssues({@required this.token, @required this.profile});

  @override
  _AssignedIssuesState createState() =>
      _AssignedIssuesState(token: token, profile: profile);
}

class _AssignedIssuesState extends State<AssignedIssues> {
  final String token;
  final dynamic profile;
  _AssignedIssuesState({@required this.token, @required this.profile});
  final brainObj = Brain();
  var x = 'Assigned';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Assigned Issues'),
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
                                token: widget.token,
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
                                token: widget.token,
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
                                token: widget.token,
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
        future: brainObj.fetchAssignedIssues(widget.token),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: DropDownFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        x = value;
                                      });
                                    },
                                    value: x,
                                    titleText: 'Update Status',
                                    hintText: 'Please choose one',
                                    dataSource: [
                                      {
                                        "display": "Created",
                                        "value": "Created",
                                      },
                                      {
                                        "display": "Open",
                                        "value": "Open",
                                      },
                                      {
                                        "display": "Rejected",
                                        "value": "Rejected",
                                      },
                                      {
                                        "display": "Assigned",
                                        "value": "Assigned",
                                      },
                                      {
                                        "display": "Resolved",
                                        "value": "Resolved",
                                      },
                                    ],
                                    textField: 'display',
                                    valueField: 'value',
                                  ),
                                ),
                                Expanded(
                                  child: FlatButton(
                                    child: Icon(Icons.mode_edit),
                                    onPressed: () async {
                                      var obj = {
                                        'issue_title': snapshot.data[index]
                                            ['issue_title'],
                                        'issue_project': snapshot.data[index]
                                            ['issue_project'],
                                        'issue_status': x
                                      };
                                      var responseCode =
                                          await brainObj.updateIssue(token, obj,
                                              snapshot.data[index]['id']);
                                      if (responseCode == 200) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text('Success'),
                                                  content: Text(
                                                      'Status Successfully Updated'),
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text('Oops'),
                                                  content: Text(
                                                      'Sorry, something went wrong'),
                                                ));
                                      }
                                    },
                                  ),
                                )
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
                                            token: widget.token,
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
