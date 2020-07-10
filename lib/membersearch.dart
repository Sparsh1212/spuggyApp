import 'package:flutter/material.dart';
import 'editmember.dart';
import 'common.dart';

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
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditMember(
                              token: token,
                              member: resultsList[index],
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.indigo[900],
                          blurRadius: 6.0,
                          offset: Offset(1, 6)),
                    ],
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                      colors: [Colors.blue[500], Colors.indigo[400]],
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Hero(
                            tag: resultsList[index]['id'],
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  'https://api.adorable.io/avatars/283/${resultsList[index]['username']}@adorable.png'),
                              radius: 15.0,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            resultsList[index]['name'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontFamily: 'Galada'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Text(
                        '@${resultsList[index]['username']}',
                        style: whiteSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('${resultsList[index]['branch']}',
                          style: whiteSmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 15.0,
                            color: Colors.pink[100],
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Status: ${resultsList[index]['status']}',
                            style: TextStyle(
                                color: Colors.pink[100], fontSize: 15.0),
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
                          style: TextStyle(color: Colors.red[100]),
                        ),
                      ),
                    ),
                  ],
                ),
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
