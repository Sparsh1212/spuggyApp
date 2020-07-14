import 'package:flutter/material.dart';
import 'brain.dart';
import 'common.dart';
import 'package:toast/toast.dart';

class Comments extends StatefulWidget {
  final String token;
  final int issueId;
  final dynamic issue;
  final dynamic profile;

  Comments(
      {@required this.token,
      @required this.issueId,
      @required this.issue,
      @required this.profile});

  @override
  _CommentsState createState() =>
      _CommentsState(token: token, issue: issue, issueId: issueId);
}

class _CommentsState extends State<Comments> {
  final String token;
  final int issueId;
  final dynamic issue;
  _CommentsState(
      {@required this.token, @required this.issueId, @required this.issue});

  final brainObj = Brain();

  final commentTextHandler = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  List<Widget> commentsList = [];

  void fillComments() async {
    List<dynamic> list = [];
    list = await brainObj.fetchComments(token, issueId);
    setState(() {
      commentsList = list.map<Widget>((comment) {
        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15.0,
                          backgroundImage: NetworkImage(
                              'https://api.adorable.io/avatars/283/${comment['commented_by']}@adorable.png'),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(comment['commented_by'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
                    child: Text(
                      comment['comment_text'],
                    ),
                  ),
                ],
              ),
            ));
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fillComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Comments',
          style: whiteBold,
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: commentsList,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter some text';
                          }
                        },
                        controller: commentTextHandler,
                        decoration: textDecoration2.copyWith(
                            hintText: 'Add a comment',
                            prefixIcon: Icon(Icons.tag_faces),
                            fillColor: Colors.grey[200]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            commentsList.add(Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  'https://api.adorable.io/avatars/283/${widget.profile[0]['username']}@adorable.png'),
                                            ),
                                            SizedBox(
                                              width: 12.0,
                                            ),
                                            Text(widget.profile[0]['username'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15.0, 5.0, 0.0, 10.0),
                                        child: Text(
                                          commentTextHandler.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                )));

                            setState(() {});

                            var obj = {
                              'comment_project': issue['issue_project'],
                              'comment_issue': issue['id'],
                              'comment_text': commentTextHandler.text
                            };
                            commentTextHandler.clear();
                            var responseCode =
                                await brainObj.addComment(token, obj);

                            if (responseCode == 201) {
                            } else {
                              setState(() {
                                commentsList.removeLast();
                              });

                              Toast.show("Unable to add comment", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.TOP);
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
