import 'package:flutter/material.dart';
import 'brain.dart';
import 'issuedetail.dart';
import 'bottomnavigator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'popupButton.dart';

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
        title: Text('My Raised Issues'),
        backgroundColor: Colors.purple,
        actions: [
          popupObj.popupList(
              profile[0]['name'],
              profile[0]['branch'],
              profile[0]['username'],
              profile[0]['status'],
              profile[0]['current_year'])
        ],
      ),
      bottomNavigationBar:
          bottomNavObj.bottomNavigator(token, profile, 1, context),
      body: FutureBuilder(
        future: brainObj.fetchMyCreatedIssues(token),
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
