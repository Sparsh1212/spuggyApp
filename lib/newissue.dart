import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'brain.dart';
import 'common.dart';

class NewIssue extends StatefulWidget {
  final String token;
  final int projectId;
  NewIssue({@required this.token, @required this.projectId});
  @override
  _NewIssueState createState() =>
      _NewIssueState(token: token, projectId: projectId);
}

class _NewIssueState extends State<NewIssue> {
  var brainObj = Brain();
  var titleHandler = TextEditingController();
  var descriptionHandler = TextEditingController();
  final String token;
  final int projectId;
  _NewIssueState({this.token, this.projectId});
  var x = 'Bug';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raise a new Issue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          height: 500.0,
          child: Column(
            children: [
              TextField(
                controller: titleHandler,
                decoration: textFieldDecoration,
              ),
              SizedBox(
                height: 25.0,
              ),
              TextField(
                controller: descriptionHandler,
                decoration: textFieldDecoration.copyWith(
                    hintText: 'Description (Optional)',
                    prefixIcon: Icon(Icons.description)),
              ),
              SizedBox(
                height: 25.0,
              ),
              DropDownFormField(
                onChanged: (value) {
                  setState(() {
                    x = value;
                  });
                },
                value: x,
                titleText: 'ISSUE TYPE',
                hintText: 'Please choose one',
                dataSource: [
                  {
                    "display": "UI",
                    "value": "UI",
                  },
                  {
                    "display": "Bug",
                    "value": "Bug",
                  },
                ],
                textField: 'display',
                valueField: 'value',
              ),
              SizedBox(
                height: 25.0,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.purple)),
                //color: Colors.purple,
                child: Text(
                  'Raise Issue',
                  style: TextStyle(color: Colors.purple, fontSize: 20.0),
                ),
                onPressed: () async {
                  var obj = {
                    'issue_title': titleHandler.text,
                    'issue_description': descriptionHandler.text,
                    'issue_project': projectId,
                    'issue_tag': x
                  };
                  var responseCode = await brainObj.raiseIssue(token, obj);
                  if (responseCode == 201) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Success'),
                              content: Text('Issue Successfully Raised'),
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Something Went Wrong'),
                              content: Text(
                                  'Looks like you missed something important'),
                            ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
