import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'brain.dart';

class EditMember extends StatefulWidget {
  final String token;
  final dynamic member;
  EditMember({@required this.token, @required this.member});
  @override
  _EditMemberState createState() =>
      _EditMemberState(token: token, member: member);
}

class _EditMemberState extends State<EditMember> {
  var brainObj = Brain();
  final String token;
  final dynamic member;
  bool x = false;
  var y = 'Normal';
  _EditMemberState({@required this.token, @required this.member});
  @override
  void initState() {
    super.initState();

    x = member['isBlocked'];
    y = member['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Access Permissions'),
      ),
      body: Center(
        child: Container(
          height: 600.0,
          width: 300.0,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                    tag: member['id'],
                    child: Text(
                      member['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    )),
                Text(' @${member['username']}'),
                Text('Current Year:  ${member['current_year']}'),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text('Branch:  ${member['branch']}')),
                Text('Current Status:  ${member['status']}'),
                Container(
                  width: 200.0,
                  child: CheckboxListTile(
                    title: Text('Block User ?'),
                    value: x,
                    onChanged: (bool value) {
                      setState(() {
                        x = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: DropDownFormField(
                    onChanged: (value) {
                      setState(() {
                        y = value;
                      });
                    },
                    value: y,
                    titleText: 'Change Status to',
                    hintText: 'Please choose one',
                    dataSource: [
                      {
                        "display": "Admin",
                        "value": "Admin",
                      },
                      {
                        "display": "Normal",
                        "value": "Normal",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                FlatButton(
                  color: Colors.purple,
                  child: Text(
                    'Update Access Details',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    var obj = {
                      "name": member['name'],
                      "branch": member['branch'],
                      "status": y,
                      "isBlocked": x,
                      "user": member['user']
                    };

                    var responseCode = await brainObj.updateMemberAccess(
                        token, obj, member['id']);
                    if (responseCode == 200) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Success'),
                                content: Text(
                                    'Member Permissions Successfully Updated'),
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Oops'),
                                content: Text('Something Went Wrong'),
                              ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
