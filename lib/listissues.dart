import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'newissue.dart';
import 'common.dart';

class ListIssues extends StatefulWidget {
  final project; // new
  final int projectId;
  final String token;
  final profile;
  ListIssues(
      {@required this.token,
      @required this.projectId,
      @required this.project, // new
      @required this.profile});

  @override
  _ListIssuesState createState() => _ListIssuesState();
}

class _ListIssuesState extends State<ListIssues> {
  final brainObj = Brain();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Issues',
          style: whiteBold,
        ),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle_outline,
          size: 50.0,
        ),
        backgroundColor: Colors.blue[900],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewIssue(
                      token: widget.token,
                      projectId: widget.projectId))).then((v) {
            setState(() {});
          });
        },
      ),
      body: FutureBuilder(
        future: brainObj.fetchIssues(widget.token, widget.projectId),
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
                                      token: widget.token,
                                      issue: snapshot.data[index],
                                      project: widget.project,
                                      profile: widget.profile,
                                    ))).then((d) {
                          setState(() {});
                        });
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
                                  horizontal: 10.0, vertical: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.report,
                                    size: 20.0,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.0),
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
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 20.0,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(snapshot.data[index]['created_by'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15.0)),
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
            child: SpinKitFadingGrid(
              color: Colors.blue[900],
            ),
          );
        },
      ),
    );
  }
}
