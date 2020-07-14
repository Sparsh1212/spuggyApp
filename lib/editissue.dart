import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:spuggyflutter/common.dart';
import 'brain.dart';
import 'common.dart';

final brainObj = Brain();

class EditIssue extends StatefulWidget {
  final dynamic project;
  final String token;
  final dynamic issue;
  EditIssue(
      {@required this.issue, @required this.token, @required this.project});
  @override
  _EditIssueState createState() =>
      _EditIssueState(issue: issue, token: token, project: project);
}

class _EditIssueState extends State<EditIssue> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var membersList = [];
  var x = 'Created';
  var y;
  final dynamic project;
  final dynamic issue;
  final String token;
  _EditIssueState(
      {@required this.issue, @required this.token, @required this.project});
  final issueUpdateFailure = SnackBar(
    duration: const Duration(seconds: 3),
    content: Row(
      children: [
        Text(
          'Something went wrong.',
          style: TextStyle(fontSize: 15.0),
        )
      ],
    ),
  );
  @override
  void initState() {
    super.initState();
    x = issue['issue_status'];
    if (issue['currently_assigned_to'] != 'No one') {
      y = issue['assigned_to'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: Text(
          'Edit Issue',
          style: whiteBold,
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.37,
          width: MediaQuery.of(context).size.width * 0.8, //300.0
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropDownFormField(
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
              FutureBuilder(
                future: brainObj.fetchUsers(token),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropDownFormField(
                      onChanged: (value) {
                        setState(() {
                          y = value;
                        });
                      },
                      titleText: 'Assign User',
                      hintText: 'Please choose one',
                      dataSource: snapshot.data
                          .where((user) =>
                              project['team_members'].contains(user['id']) ||
                              project['created_by'] == user['username'])
                          .toList()
                          .map((user) => {
                                'display': user['username'],
                                'value': user['id']
                              })
                          .toList(),
                      value: y,
                      textField: 'display',
                      valueField: 'value',
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error in Fetching Members');
                  }
                  return Container();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.teal[400])),
                      child: Text(
                        'Update Issue',
                        style:
                            TextStyle(color: Colors.teal[400], fontSize: 18.0),
                      ),
                      onPressed: () async {
                        var obj = y != null
                            ? {
                                'issue_title': issue['issue_title'],
                                'issue_project': issue['issue_project'],
                                'issue_status': x,
                                'assigned_to': y
                              }
                            : {
                                'issue_title': issue['issue_title'],
                                'issue_project': issue['issue_project'],
                                'issue_status': x
                              };

                        var responseCode =
                            await brainObj.updateIssue(token, obj, issue['id']);
                        if (responseCode == 200) {
                          Navigator.pop(context, true);
                        } else {
                          _scaffoldKey.currentState
                              .showSnackBar(issueUpdateFailure);
                        }
                      }),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () async {
                      var responseCode =
                          await brainObj.deleteIssue(token, issue['id']);
                      if (responseCode == 204) {
                        Navigator.pop(context, true);
                      } else {
                        _scaffoldKey.currentState
                            .showSnackBar(issueUpdateFailure);
                      }
                    },
                    child: Text(
                      'Delete Issue',
                      style: TextStyle(color: Colors.red, fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
