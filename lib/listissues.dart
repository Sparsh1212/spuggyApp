import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'newissue.dart';

class ListIssues extends StatelessWidget {
  final brainObj = Brain();
  final int projectId;
  final String token;
  ListIssues({
    @required this.token,
    @required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issues'),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle_outline,
          size: 50.0,
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewIssue(token: token, projectId: projectId)));
        },
      ),
      body: FutureBuilder(
        future: brainObj.fetchIssues(token, projectId),
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
