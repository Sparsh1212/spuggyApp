import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'brain.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'editmember.dart';
import 'bottomnavigator.dart';
import 'popupButton.dart';
import 'membersearch.dart';
import 'common.dart';

class Members extends StatefulWidget {
  final String token;
  final dynamic profile;
  Members({@required this.token, @required this.profile});

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final popupObj = PopupButton();

  final bottomNavObj = BottomNavigator();

  final brainObj = Brain();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: brainObj.fetchProfiles(widget.token),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text('All Members', style: whiteBold),
              backgroundColor: Colors.blue[900],
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: snapshot.hasData
                        ? () {
                            showSearch(
                                context: context,
                                delegate: MemberSearch(
                                    token: widget.token,
                                    membersList: snapshot.data));
                          }
                        : null),
                popupObj.popupList(widget.profile)
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
                                          token: widget.token,
                                          member: snapshot.data[index],
                                        ))).then((ea) {
                              setState(() {});
                            });
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
                                          radius: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.025,
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
