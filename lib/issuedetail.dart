import 'package:flutter/material.dart';
import 'package:spuggyflutter/editissue.dart';
import 'comments.dart';
import 'editissue.dart';
import 'common.dart';

class IssueDetail extends StatefulWidget {
  final dynamic project;
  final String token;
  final dynamic issue;
  final profile;
  IssueDetail(
      {@required this.token,
      @required this.issue,
      @required this.project,
      @required this.profile});

  @override
  _IssueDetailState createState() => _IssueDetailState();
}

class _IssueDetailState extends State<IssueDetail> {
  @override
  Widget build(BuildContext context) {
    bool checkIfEditAllowed() {
      if (widget.project == null) {
        return false;
      }
      if (widget.profile[0]['status'] == 'Admin') {
        return true;
      } else if (widget.project['created_by'] ==
          widget.profile[0]['username']) {
        return true;
      }
      for (int i = 0; i < widget.project['team_members'].length; i++) {
        if (widget.project['team_members'][i] == widget.profile[0]['user']) {
          return true;
        }
      }

      return false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text(
          'Issue Details',
          style: whiteBold,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Text(widget.issue['issue_title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.grey[700], Colors.grey[700]]),
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: Colors.white))),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                          child: Text(
                            widget.issue['issue_description'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.stars,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    widget.issue['issue_tag'],
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.report,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(widget.issue['issue_status'],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                        colors: [Colors.grey[700], Colors.grey[700]]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Creator',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(widget.issue['created_by'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text('Assigned To',
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    widget.issue['currently_assigned_to'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Visibility(
                    visible: checkIfEditAllowed(),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.green)),
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.green, fontSize: 22.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditIssue(
                                      token: widget.token,
                                      issue: widget.issue,
                                      project: widget.project,
                                    )));
                      },
                    ),
                  ),
                  Visibility(
                    visible: checkIfEditAllowed(),
                    child: SizedBox(
                      width: 10.0,
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(color: Colors.red)),
                    child: Text(
                      'Comments',
                      style: TextStyle(color: Colors.red, fontSize: 22.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Comments(
                                    token: widget.token,
                                    issueId: widget.issue['id'],
                                    issue: widget.issue,
                                  )));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
