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
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text(
          'Raise Issue',
          style: whiteBold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          //height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              TextFormField(
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please add a title';
                  }
                },
                controller: titleHandler,
                decoration: textDecoration2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextField(
                controller: descriptionHandler,
                decoration: textDecoration2.copyWith(
                    hintText: 'Description (Optional)',
                    prefixIcon: Icon(Icons.description)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
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
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue[700])),
                //color: Colors.purple,
                child: Text(
                  'Raise Issue',
                  style: TextStyle(color: Colors.blue[700], fontSize: 20.0),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
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
                      titleHandler.clear();
                      descriptionHandler.clear();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Something Went Wrong'),
                              ));
                    }
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
