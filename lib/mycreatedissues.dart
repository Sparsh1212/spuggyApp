import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'bottomnavigator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'popupButton.dart';
import 'common.dart';

class MyCreatedIssues extends StatelessWidget {
  final bottomNavObj = BottomNavigator();
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
        backgroundColor: Colors.green[500],
        actions: [popupObj.popupList(profile)],
      ),
      bottomNavigationBar: bottomNavObj.bottomNavigator(
          token, profile, 1, context, Colors.green[700]),
      body: FutureBuilder(
        future: brainObj.fetchMyCreatedIssues(token),
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
                                  color: Colors.green[900],
                                  blurRadius: 6.0,
                                  offset: Offset(1, 5)),
                            ],
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [Colors.green[300], Colors.green[700]],
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
            child: SpinKitFadingGrid(
              color: Colors.green[900],
            ),
          );
        },
      ),
    );
  }
}
