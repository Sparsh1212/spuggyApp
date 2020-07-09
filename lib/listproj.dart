import 'package:flutter/material.dart';
import 'brain.dart';
import 'listissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'popupButton.dart';
import 'bottomnavigator.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
            return CarouselSlider(
              height: 600.0,
              items: snapshot.data.map<Widget>((project) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListIssues(
                                      token: token,
                                      projectId: project['id'],
                                      project: project,
                                      profile: profile,
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.purple[900],
                                blurRadius: 6.0,
                                offset: Offset(1, 5)),
                          ],
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [Colors.purple[200], Colors.purple[800]],
                          ),
                          color: Colors.green,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: Text(project['project_name'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'TESTING PROCEDURE',
                                style: TextStyle(
                                    color: Colors.pink[100],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20.0),
                              child: Html(
                                data: project['testing_procedure'],
                                style: {
                                  "html":
                                      Style(backgroundColor: Colors.pink[100]),
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              enlargeCenterPage: true,
              viewportFraction: 0.9,
            );
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

// temp

// Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Text(
//                               snapshot.data[index]['project_name'],
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 30.0),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               'TESTING PROCEDURE',
//                               style: TextStyle(
//                                 color: Colors.purple,
//                                 fontWeight: FontWeight.bold,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Html(
//                               data: snapshot.data[index]['testing_procedure'],
//                             ),
//                             //Text(snapshot.data[index]['testing_procedure']),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15.0, vertical: 5.0),
//                             child: FlatButton(
//                                 child: Text(
//                                   'View Details',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ListIssues(
//                                                 token: token,
//                                                 projectId: snapshot.data[index]
//                                                     ['id'],
//                                                 project: snapshot.data[index],
//                                                 profile: profile,
//                                               )));
//                                 }),
//                           )
//                         ],
//                       )
