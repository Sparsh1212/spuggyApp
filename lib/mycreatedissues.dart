import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'popupButton.dart';
import 'common.dart';

class MyCreatedIssues extends StatelessWidget {
  final popupObj = PopupButton();
  final brainObj = Brain();
  final String token;
  final dynamic profile;
  MyCreatedIssues({@required this.token, @required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Raised Issues',
          style: whiteBold,
        ),
        backgroundColor: Colors.blue[900],
        actions: [popupObj.popupList(profile)],
      ),
      body: FutureBuilder(
        future: brainObj.fetchMyCreatedIssues(token),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
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
                                  blurRadius: 3.0,
                                  offset: Offset(1, 3)),
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
                                  horizontal: 10.0, vertical: 8.0),
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
                                          fontSize: 17.0)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
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
            child: SpinKitFadingGrid(
              color: Colors.blue[900],
            ),
          );
        },
      ),
    );
  }
}
