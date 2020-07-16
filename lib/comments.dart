import 'package:flutter/material.dart';
import 'brain.dart';
import 'common.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  bool isLoading = true;
  bool isEmpty = false;

  List<Widget> commentsList = [];
  ScrollController _scrollController = new ScrollController();
  bool reverse = false;

  String makeDate(String s) {
    String date = s.substring(0, 10);

    String time = s.substring(11, 16);

    return (time + '  ' + date);
  }

  void fillComments() async {
    List<dynamic> list = [];
    list = await brainObj.fetchComments(token, issueId);
    if (list.length == 0) {
      setState(() {
        isLoading = false;
        isEmpty = true;
      });
    } else {
      setState(() {
        isLoading = false;

        commentsList = list.map<Widget>((comment) {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
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
                            width: 8.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment['commented_by'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  )),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 5.0, 0.0, 0.0),
                                child: Text(makeDate(comment['comment_date'])),
                              ),
                            ],
                          )
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
      body: isLoading
          ? Center(
              child: SpinKitFadingGrid(
                color: Colors.blue[900],
              ),
            )
          : Column(
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    reverse: reverse,
                    child: isEmpty
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.40),
                            child: Center(
                              child: Text(
                                'No comments',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Column(
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
                              controller: commentTextHandler,
                              decoration: InputDecoration(
                                hintText: 'Add a comment',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                filled: true,
                                fillColor: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                if (commentTextHandler.text != '') {
                                  commentsList.add(Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 3.0),
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 15.0,
                                                    backgroundImage: NetworkImage(
                                                        'https://api.adorable.io/avatars/283/${widget.profile[0]['username']}@adorable.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          widget.profile[0]
                                                              ['username'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0,
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0.0,
                                                                5.0,
                                                                0.0,
                                                                0.0),
                                                        child: Text('Just Now'),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15.0, 5.0, 0.0, 10.0),
                                              child: Text(
                                                commentTextHandler.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )));

                                  setState(() {
                                    reverse = true;
                                  });
                                  _scrollController.animateTo(0.0,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 300));

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
