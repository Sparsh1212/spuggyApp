import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'editmember.dart';
import 'bottomnavigator.dart';
import 'popupButton.dart';

class Members extends StatelessWidget {
  final popupObj = PopupButton();
  final bottomNavObj = BottomNavigator();
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
            bottomNavigationBar:
                bottomNavObj.bottomNavigator(token, profile, 3, context),
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
                popupObj.popupList(
                    profile[0]['name'],
                    profile[0]['branch'],
                    profile[0]['username'],
                    profile[0]['status'],
                    profile[0]['current_year'])
              ],
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
