import 'package:flutter/material.dart';
import 'package:spuggyflutter/common.dart';
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
        centerTitle: true,
        title: Text(
          'Assigned Issues',
          style: whiteBold,
        ),
        backgroundColor: Colors.blue[900],
        actions: [popupObj.popupList(profile)],
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IssueDetail(
                                    token: token,
                                    issue: snapshot.data[index],
                                    project: null,
                                    profile: profile,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue[900],
                                blurRadius: 6.0,
                                offset: Offset(1, 5)),
                          ],
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [Colors.blue[300], Colors.blue[800]],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            child: Text(
                              snapshot.data[index]['issue_title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.report,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(snapshot.data[index]['issue_status'],
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15.0)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.0),
                                Text(snapshot.data[index]['created_by'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15.0)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 12.0),
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
                                    child: Icon(
                                      Icons.mode_edit,
                                      color: Colors.white,
                                    ),
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
                                        setState(() {});
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError == true) {
            return Center(
              child: Text('Error Fetching Issues'),
            );
          }
          return Center(
            child: SpinKitFadingGrid(
              color: Colors.blue[900],
            ),
          );
        },
      ),
    );
  }
}
