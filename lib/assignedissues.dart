import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'bottomnavigator.dart';
import 'popupButton.dart';

final bottomNavObj = BottomNavigator();
final popupObj = PopupButton();

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
        actions: [
          popupObj.popupList(
              profile[0]['name'],
              profile[0]['branch'],
              profile[0]['username'],
              profile[0]['status'],
              profile[0]['current_year'])
        ],
      ),
      bottomNavigationBar:
          bottomNavObj.bottomNavigator(token, profile, 2, context),
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
                                            project: null,
                                            profile: profile,
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
