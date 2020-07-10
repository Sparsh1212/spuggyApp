import 'package:flutter/material.dart';
import 'brain.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'common.dart';

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
        centerTitle: true,
        title: Text(
          'Comments',
          style: whiteBold,
        ),
        backgroundColor: Colors.brown,
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
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 15.0,
                                        backgroundImage: NetworkImage(
                                            'https://api.adorable.io/avatars/283/${snapshot.data[index]['commented_by']}@adorable.png'),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(snapshot.data[index]['commented_by'],
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
                    padding: const EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: TextField(
                            controller: commentTextHandler,
                            decoration: textFieldDecoration.copyWith(
                                hintText: 'Add a comment',
                                prefixIcon: Icon(Icons.tag_faces),
                                fillColor: Colors.grey[200]),
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
            child: SpinKitFadingGrid(
              color: Colors.brown[900],
            ),
          );
        },
      ),
    );
  }
}
