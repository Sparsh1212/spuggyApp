import 'package:flutter/material.dart';
import 'comments.dart';

class IssueDetail extends StatelessWidget {
  final String token;
  final dynamic issue;
  IssueDetail({@required this.token, @required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Container(
          height: 600.0,
          width: 300.0,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  issue['issue_title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
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
