import 'package:flutter/material.dart';
import 'editmember.dart';

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
    if (query == '') {
      return Text('');
    }
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
