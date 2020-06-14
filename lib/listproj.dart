import 'package:flutter/material.dart';
import 'brain.dart';
import 'listissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'popupButton.dart';
import 'bottomnavigator.dart';

class ListProjects extends StatelessWidget {
  final bottomNavObj = BottomNavigator();
  final brainObj = Brain();
  final String token;
  final dynamic profile;
  final popupObj = PopupButton();
  ListProjects({@required this.token, @required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('All Projects'),
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
      body: FutureBuilder(
        future: brainObj.fetchProjs(token),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              snapshot.data[index]['project_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'TESTING PROCEDURE',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Html(
                              data: snapshot.data[index]['testing_procedure'],
                            ),
                            //Text(snapshot.data[index]['testing_procedure']),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: FlatButton(
                                child: Text(
                                  'View Details',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListIssues(
                                                token: token,
                                                projectId: snapshot.data[index]
                                                    ['id'],
                                              )));
                                }),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError == true) {
            return Center(
              child: Text('Error Fetching Projects'),
            );
          }
          return Center(
            child: SpinKitWave(
              color: Colors.purple,
            ),
          );
        },
      ),
      bottomNavigationBar:
          bottomNavObj.bottomNavigator(token, profile, 0, context),
    );
  }
}
