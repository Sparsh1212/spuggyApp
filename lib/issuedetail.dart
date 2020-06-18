import 'package:flutter/material.dart';
import 'package:spuggyflutter/editissue.dart';
import 'comments.dart';
import 'editissue.dart';

class IssueDetail extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool checkIfEditAllowed() {
      if (project == null) {
        return false;
      }
      if (profile[0]['status'] == 'Admin') {
        return true;
      } else if (project['created_by'] == profile[0]['username']) {
        return true;
      }
      for (int i = 0; i < project['team_members'].length; i++) {
        if (project['team_members'][i] == profile[0]['user']) {
          return true;
        }
      }

      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Container(
          height: 500.0,
          width: 300.0,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    issue['issue_title'],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Description: ${issue['issue_description']}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Creator: ${issue['created_by']}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Assigned To: ${issue['currently_assigned_to']}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Issue Tag: ${issue['issue_tag']}',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Issue Status: ${issue['issue_status']}',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
                Visibility(
                  visible: checkIfEditAllowed(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: FlatButton(
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mode_edit,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditIssue(
                                      token: token,
                                      issue: issue,
                                      project: project,
                                    )));
                      },
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'View Comments',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Comments(
                                  token: token,
                                  issueId: issue['id'],
                                  issue: issue,
                                )));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
