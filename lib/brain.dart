import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Brain {
  final base = 'http://spuggy.herokuapp.com/';
  final loginEndPoint = 'login';
  final profileEndPoint = 'spuggy/api/UserProfile/';
  final allProjsEndPoint = 'spuggy/api/Projects/';
  final allIssuesEndPoint = 'spuggy/api/Issues/';

  final allCommentsEndPoint = 'spuggy/api/Comments/';
  final myCreatedIssuesEndPoint = 'spuggy/api/MyCreatedIssues/';
  final assignedIssuesEndPoint = 'spuggy/api/MyAssignedIssues/';
  final profilesEndPoint = 'spuggy/api/Profiles/';
  Future<String> fetchToken(String username, String password) async {
    print('token ka call to aay tha');
    http.Response response = await http.post(
      base + loginEndPoint,
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
      base + profileEndPoint,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic userProfile = jsonDecode(response.body);
    print('profile ka call success bhi hua tha');
    return userProfile;
  }

  Future<List<dynamic>> fetchProjs(String token) async {
    http.Response response = await http.get(
      base + allProjsEndPoint,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic projectsList = jsonDecode(response.body);
    return projectsList;
  }

  Future<List<dynamic>> fetchIssues(String token, int projectId) async {
    http.Response response = await http.get(
      base + allIssuesEndPoint,
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
      base + allCommentsEndPoint,
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
      base + myCreatedIssuesEndPoint,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic myCreatedIssuesList = jsonDecode(response.body);
    return myCreatedIssuesList;
  }

  Future<List<dynamic>> fetchAssignedIssues(String token) async {
    http.Response response = await http.get(
      base + assignedIssuesEndPoint,
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
    http.Response response = await http.post(base + allIssuesEndPoint,
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
    http.Response response = await http.post(base + allCommentsEndPoint,
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
    http.Response response =
        await http.put(base + allIssuesEndPoint + id.toString() + '/',
            headers: {
              HttpHeaders.authorizationHeader: 'Token $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(obj));
    dynamic updatedIssue = jsonDecode(response.body);
    print(updatedIssue);
    return (response.statusCode);
  }

  Future<int> deleteIssue(String token, int id) async {
    http.Response response = await http.delete(
      base + allIssuesEndPoint + id.toString() + '/',
      headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
      },
    );
    return (response.statusCode);
  }

  Future<List<dynamic>> fetchProfiles(String token) async {
    http.Response response = await http.get(
      base + profilesEndPoint,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic profilesList = jsonDecode(response.body);
    return profilesList;
  }

  Future<int> updateMemberAccess(String token, dynamic obj, int id) async {
    http.Response response =
        await http.put(base + profilesEndPoint + id.toString() + '/',
            headers: {
              HttpHeaders.authorizationHeader: 'Token $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(obj));
    dynamic updatedIssue = jsonDecode(response.body);
    print(updatedIssue);
    return (response.statusCode);
  }

  Future<dynamic> checkToken() async {
    var storage = FlutterSecureStorage();
    String value = await storage.read(key: 'token');
    if (value != null) {
      List profile = await fetchProfile(value);
      return {'token': value, 'profile': profile};
    } else {
      return {'token': '', 'profile': null};
    }
  }

  Future<List<dynamic>> fetchUsers(String token) async {
    http.Response response = await http.get(
      base + 'spuggy/api/Users/',
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    dynamic usersList = jsonDecode(response.body);

    return usersList;
  }
}
