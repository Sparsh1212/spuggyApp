import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'editmember.dart';
import 'bottomnavigator.dart';
import 'popupButton.dart';
import 'membersearch.dart';
import 'common.dart';

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
            bottomNavigationBar: bottomNavObj.bottomNavigator(
                token, profile, 3, context, Colors.blue[900]),
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text('All Members', style: whiteBold),
              backgroundColor: Colors.indigo[900],
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
                popupObj.popupList(profile)
              ],
            ),
            body: snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditMember(
                                          token: token,
                                          member: snapshot.data[index],
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
                                  colors: [
                                    Colors.blue[500],
                                    Colors.indigo[400]
                                  ],
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
                                        tag: snapshot.data[index]['id'],
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              'https://api.adorable.io/avatars/283/${snapshot.data[index]['username']}@adorable.png'),
                                          radius: 20.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        snapshot.data[index]['name'],
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
                                    '@${snapshot.data[index]['username']}',
                                    style: whiteSmall,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                      '${snapshot.data[index]['branch']}',
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
                                        'Status: ${snapshot.data[index]['status']}',
                                        style: TextStyle(
                                            color: Colors.pink[100],
                                            fontSize: 15.0),
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
                                      style: TextStyle(color: Colors.red[100]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : snapshot.hasError
                    ? Center(
                        child: Text('Error Fetching Members'),
                      )
                    : Center(
                        child: SpinKitFadingGrid(
                          color: Colors.indigo[900],
                        ),
                      ));
      },
    );
  }
}
