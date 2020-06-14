import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Brain {
  final loginUrl = 'https://24e2ac541d70.ngrok.io/login';
  final profileUrl = 'https://24e2ac541d70.ngrok.io/spuggy/api/UserProfile/';
  final allProjsUrl = 'https://24e2ac541d70.ngrok.io/spuggy/api/Projects/';
  final allIssuesUrl = 'https://24e2ac541d70.ngrok.io/spuggy/api/Issues/';

  final allCommentsUrl = 'https://24e2ac541d70.ngrok.io/spuggy/api/Comments/';
  final myCreatedIssuesUrl =
      'https://24e2ac541d70.ngrok.io/spuggy/api/MyCreatedIssues/';
  final assignedIssuesUrl =
      'https://24e2ac541d70.ngrok.io/spuggy/api/MyAssignedIssues/';
  final profilesUrl = 'https://24e2ac541d70.ngrok.io/spuggy/api/Profiles/';
  Future<String> fetchToken(String username, String password) async {
    print('token ka call to aay tha');
    http.Response response = await http.post(
      loginUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );
    dynamic obj = jsonDecode(response.body);
    if (obj['token'] != null) {
      return obj['token'];
    } else {
      return null;
    }
  }

  Future<dynamic> fetchProfile(String token) async {
    print('profile ka call aay tha');
    http.Response response = await http.get(
      profileUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic userProfile = jsonDecode(response.body);
    print('profile ka call success bhi hua tha');
    return userProfile;
  }

  Future<List<dynamic>> fetchProjs(String token) async {
    http.Response response = await http.get(
      allProjsUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic projectsList = jsonDecode(response.body);
    return projectsList;
  }

  Future<List<dynamic>> fetchIssues(String token, int projectId) async {
    http.Response response = await http.get(
      allIssuesUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic allIssues = jsonDecode(response.body);
    dynamic targetIssueList = allIssues
        .where((issue) => issue['issue_project'] == projectId)
        .toList();
    return targetIssueList;
  }

  Future<List<dynamic>> fetchComments(String token, int issueId) async {
    http.Response response = await http.get(
      allCommentsUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic allComments = jsonDecode(response.body);
    dynamic targetCommentsList = allComments
        .where((comment) => comment['comment_issue'] == issueId)
        .toList();
    return targetCommentsList;
  }

  Future<List<dynamic>> fetchMyCreatedIssues(String token) async {
    http.Response response = await http.get(
      myCreatedIssuesUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic myCreatedIssuesList = jsonDecode(response.body);
    return myCreatedIssuesList;
  }

  Future<List<dynamic>> fetchAssignedIssues(String token) async {
    http.Response response = await http.get(
      assignedIssuesUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic assignedIssuesList = jsonDecode(response.body);
    return assignedIssuesList;
  }

  Future<void> logout() async {
    var storage = FlutterSecureStorage();
    await storage.deleteAll();
  }

  Future<int> raiseIssue(String token, dynamic obj) async {
    http.Response response = await http.post(allIssuesUrl,
        headers: {
          HttpHeaders.authorizationHeader: 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(obj));
    dynamic newCreatedIssue = jsonDecode(response.body);
    print(newCreatedIssue);
    return (response.statusCode);
  }

  Future<int> addComment(String token, dynamic obj) async {
    http.Response response = await http.post(allCommentsUrl,
        headers: {
          HttpHeaders.authorizationHeader: 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(obj));
    dynamic newComment = jsonDecode(response.body);
    print(newComment);
    return (response.statusCode);
  }

  Future<int> updateIssue(String token, dynamic obj, int id) async {
    http.Response response = await http.put(
        'https://24e2ac541d70.ngrok.io/spuggy/api/Issues/' +
            id.toString() +
            '/',
        headers: {
          HttpHeaders.authorizationHeader: 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(obj));
    dynamic updatedIssue = jsonDecode(response.body);
    print(updatedIssue);
    return (response.statusCode);
  }

  Future<dynamic> fetchProfiles(String token) async {
    http.Response response = await http.get(
      profilesUrl,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic profilesList = jsonDecode(response.body);
    return profilesList;
  }

  Future<int> updateMemberAccess(String token, dynamic obj, int id) async {
    http.Response response = await http.put(
        'https://24e2ac541d70.ngrok.io/spuggy/api/Profiles/' +
            id.toString() +
            '/',
        headers: {
          HttpHeaders.authorizationHeader: 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(obj));
    dynamic updatedIssue = jsonDecode(response.body);
    print(updatedIssue);
    return (response.statusCode);
  }
}
