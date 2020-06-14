import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'brain.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: titleHandler,
                decoration: InputDecoration(
                    labelText: 'Issue Title',
                    hintText: 'Enter the title',
                    border: OutlineInputBorder()),
              ),
              TextField(
                controller: descriptionHandler,
                decoration: InputDecoration(
                  labelText: 'Issue Description (Optional)',
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
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
              FlatButton(
                color: Colors.purple,
                child: Text(
                  'Raise Issue',
                  style: TextStyle(color: Colors.white),
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
