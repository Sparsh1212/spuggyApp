import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'mycreatedissues.dart';
import 'assignedissues.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'listproj.dart';
import 'editmember.dart';

class Members extends StatelessWidget {
  final brainObj = Brain();
  final String token;
  final dynamic profile;
  Members({@required this.token, @required this.profile});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: brainObj.fetchProfiles(token),
      builder: (context, snapshot) {
        return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              index: 3,
              height: 50.0,
              color: Colors.purple,
              backgroundColor: Colors.white,
              buttonBackgroundColor: Colors.purple,
              items: <Widget>[
                Icon(
                  Icons.folder,
                  size: 30,
                  color: Colors.white,
                ),
                Icon(
                  Icons.bug_report,
                  size: 30,
                  color: Colors.white,
                ),
                Icon(
                  Icons.work,
                  size: 30,
                  color: Colors.white,
                ),
                Icon(
                  Icons.people,
                  size: 30,
                  color: Colors.white,
                ),
              ],
              animationDuration: Duration(milliseconds: 200),
              onTap: (int index) {
                if (index == 0) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListProjects(
                                token: token,
                                profile: profile,
                              )));
                } else if (index == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyCreatedIssues(
                                token: token,
                                profile: profile,
                              )));
                } else if (index == 2) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssignedIssues(
                                token: token,
                                profile: profile,
                              )));
                } else if (index == 3) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Members(
                                token: token,
                                profile: profile,
                              )));
                }
              },
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('All Members'),
              backgroundColor: Colors.purple,
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: snapshot.hasData
                        ? () {
                            showSearch(
                                context: context,
                                delegate: MemberSearch(
                                    token: token, membersList: snapshot.data));
                          }
                        : null),
                PopupMenuButton(
                  color: Colors.purple[200],
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Container(
                        height: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Hello ${profile[0]['name']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              profile[0]['branch'],
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 15.0,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  '@${profile[0]['username']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified_user,
                                  size: 15.0,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'Status:  ${profile[0]['status']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              'Current Year:  ${profile[0]['current_year']}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: FlatButton(
                        color: Colors.purple,
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await brainObj.logout();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            endDrawer: Drawer(
              child: SafeArea(
                child: ListView(
                  padding: EdgeInsets.all(0.0),
                  children: [
                    DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Hello ! ${profile[0]['name']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            profile[0]['branch'],
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                '@${profile[0]['username']}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_user),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                'Status:  ${profile[0]['status']}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            'Current Year:  ${profile[0]['current_year']}',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.folder),
                      title: Text('All Projects'),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListProjects(
                                      token: token,
                                      profile: profile,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.report_problem),
                      title: Text('Raised Issues'),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCreatedIssues(
                                      token: token,
                                      profile: profile,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.work),
                      title: Text('Assigned Issues'),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssignedIssues(
                                      token: token,
                                      profile: profile,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Members'),
                    ),
                    ListTile(
                      leading: Icon(Icons.arrow_forward_ios),
                      title: Text('Logout'),
                      onTap: () async {
                        await brainObj.logout();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    )
                  ],
                ),
              ),
            ),
            body: snapshot.hasData
                ? ListView.builder(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Hero(
                                      tag: snapshot.data[index]['id'],
                                      child: Text(
                                        snapshot.data[index]['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                child: Text(
                                  '@${snapshot.data[index]['username']}',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  '${snapshot.data[index]['branch']}',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user,
                                      size: 15.0,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      'Status: ${snapshot.data[index]['status']}',
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: snapshot.data[index]['isBlocked'],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5.0),
                                  child: Text(
                                    'Access is currently blocked',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: FlatButton(
                                  color: Colors.blue,
                                  child: Text(
                                    'Edit Access',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditMember(
                                                  token: token,
                                                  member: snapshot.data[index],
                                                )));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : snapshot.hasError
                    ? Center(
                        child: Text('Error Fetching Members'),
                      )
                    : Center(
                        child: SpinKitWave(
                          color: Colors.purple,
                        ),
                      ));
      },
    );
  }
}

class MemberSearch extends SearchDelegate {
  final String token;
  final List membersList;
  MemberSearch({@required this.token, @required this.membersList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final resultsList = membersList
        .where((member) =>
            member['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: resultsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          resultsList[index]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      '@${resultsList[index]['username']}',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      '${resultsList[index]['branch']}',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 15.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Status: ${resultsList[index]['status']}',
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: resultsList[index]['isBlocked'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Text(
                        'Access is currently blocked',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FlatButton(
                      color: Colors.blue,
                      child: Text(
                        'Edit Access',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditMember(
                                      token: token,
                                      member: resultsList[index],
                                    )));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final displayList = membersList
        .where((member) =>
            member['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: displayList.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(displayList[index]['name']),
              onTap: () {
                showResults(context);
              },
            ));
  }
}
