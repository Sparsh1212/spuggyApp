import 'package:flutter/material.dart';
import 'common.dart';

class Profile extends StatelessWidget {
  final dynamic profile;

  Profile({@required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal[400],
        title: Text('My Profile', style: whiteBold),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            overflow: Overflow.visible,
            children: [
              Container(
                color: Colors.purple[200],
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://api.adorable.io/avatars/283/${profile[0]['username']}@adorable.png'),
                  radius: 60.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 60.0,
          ),
          Center(
            child: Text(
              'Sparsh Agrawal',
              style: TextStyle(fontSize: 35.0, fontFamily: 'Galada'),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Username:   ${profile[0]['username']}',
              style: blackBold,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Branch:   ${profile[0]['branch']}',
              style: blackBold,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Year: ${profile[0]['current_year']}',
              style: blackBold,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Status:   ${profile[0]['status']}',
              style: blackBold,
            ),
          ),
        ],
      ),
    );
  }
}
