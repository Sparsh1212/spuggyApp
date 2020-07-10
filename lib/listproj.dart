import 'package:flutter/material.dart';
import 'package:spuggyflutter/common.dart';
import 'brain.dart';
import 'listissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'popupButton.dart';
import 'bottomnavigator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'common.dart';

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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'All Projects',
          style: whiteBold,
        ),
        backgroundColor: Colors.purple,
        actions: [popupObj.popupList(profile)],
      ),
      body: FutureBuilder(
        future: brainObj.fetchProjs(token),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return CarouselSlider(
              height: MediaQuery.of(context).size.height * 0.8,
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
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.02),
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
                              height: MediaQuery.of(context).size.height * 0.01,
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
            child: SpinKitFadingGrid(
              color: Colors.purple[900],
            ),
          );
        },
      ),
      bottomNavigationBar: bottomNavObj.bottomNavigator(
          token, profile, 0, context, Colors.purple[700]),
    );
  }
}
