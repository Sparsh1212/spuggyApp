import 'package:flutter/material.dart';
import 'brain.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Comments extends StatelessWidget {
  final brainObj = Brain();
  final String token;
  final int issueId;
  final dynamic issue;
  final commentTextHandler = TextEditingController();
  Comments(
      {@required this.token, @required this.issueId, @required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
        future: brainObj.fetchComments(token, issueId),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return Column(
              children: [
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
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
                                      Icon(Icons.person),
                                      SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        snapshot.data[index]['commented_by'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0.0, 0.0, 10.0),
                                  child: Text(
                                    snapshot.data[index]['comment_text'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: TextField(
                            controller: commentTextHandler,
                            decoration: InputDecoration(
                              labelText: 'Add a Comment',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                var obj = {
                                  'comment_project': issue['issue_project'],
                                  'comment_issue': issue['id'],
                                  'comment_text': commentTextHandler.text
                                };
                                var responseCode =
                                    await brainObj.addComment(token, obj);
                                if (responseCode == 201) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Success'),
                                            content: Text(
                                                'Comment successfully added'),
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Oops'),
                                            content: Text(
                                                'Sorry, something went wrong'),
                                          ));
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError == true) {
            return Center(
              child: Text('Error Fetching Comments'),
            );
          }
          return Center(
            child: SpinKitWave(
              color: Colors.purple,
            ),
          );
        },
      ),
    );
  }
}
