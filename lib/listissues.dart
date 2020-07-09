import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'newissue.dart';
import 'common.dart';

class ListIssues extends StatelessWidget {
  final project; // new
  final brainObj = Brain();
  final int projectId;
  final String token;
  final profile;
  ListIssues(
      {@required this.token,
      @required this.projectId,
      @required this.project, // new
      @required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Issues',
          style: whiteBold,
        ),
        backgroundColor: Colors.pink[400],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle_outline,
          size: 50.0,
        ),
        backgroundColor: Colors.pink,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IssueDetail(
                                      token: token,
                                      issue: snapshot.data[index],
                                      project: project,
                                      profile: profile,
                                    )));
                      },
                      child: Container(
                        // height: 180.0,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red[900],
                                  blurRadius: 6.0,
                                  offset: Offset(1, 5)),
                            ],
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [Colors.pink[300], Colors.red[300]],
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
                                  RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.report,
                                      size: 30.0,
                                    ),
                                    shape: CircleBorder(),
                                  ),
                                  Text(snapshot.data[index]['issue_status'],
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17.0)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      size: 30.0,
                                    ),
                                    shape: CircleBorder(),
                                  ),
                                  Text(snapshot.data[index]['created_by'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 17.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
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
