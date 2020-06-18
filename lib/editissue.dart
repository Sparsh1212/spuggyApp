import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'brain.dart';

final brainObj = Brain();

class EditIssue extends StatefulWidget {
  final String token;
  final dynamic issue;
  EditIssue({@required this.issue, @required this.token});
  @override
  _EditIssueState createState() => _EditIssueState(issue: issue, token: token);
}

class _EditIssueState extends State<EditIssue> {
  var membersList = [];
  var x = 'Created';
  var y;
  final dynamic issue;
  final String token;
  _EditIssueState({@required this.issue, @required this.token});
  @override
  void initState() {
    super.initState();
    x = issue['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Issue'),
      ),
      body: Center(
        child: Container(
          height: 400.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      value: y,
                      onChanged: (value) {
                        setState(() {
                          y = value;
                        });
                      },
                      titleText: 'Assign User',
                      hintText: 'Please choose one',
                      dataSource: snapshot.data
                          .map((user) => {
                                'display': user['username'],
                                'value': user['id']
                              })
                          .toList(),
                      textField: 'display',
                      valueField: 'value',
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error in Fetching Members');
                  }
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: FlatButton(
                  onPressed: () async {
                    var responseCode =
                        await brainObj.deleteIssue(token, issue['id']);
                    if (responseCode == 204) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Success'),
                                content: Text('Issue Successfully Deleted'),
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Oops'),
                                content: Text('Sorry, something went wrong'),
                              ));
                    }
                  },
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Delete Issue',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: FlatButton(
                    color: Colors.teal[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Update Issue Status',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
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
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Success'),
                                  content: Text('Issue Successfully Updated'),
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Oops'),
                                  content: Text('Sorry, something went wrong'),
                                ));
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
