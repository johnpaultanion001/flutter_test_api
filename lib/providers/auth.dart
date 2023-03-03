// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_todo_api/widgets/notification_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  late String _token;
  NotificationText _notification = NotificationText('');

  Status get status => _status;
  String get token => _token;
  NotificationText get notification => _notification;

  final String api = 'http://192.168.0.33:8000/api/v1/auth';

  initAuthProvider() async {
    String? token = await getToken();
    if (token != null) {
      _token = token;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = Status.Authenticating;

    notifyListeners();

    final url = 'http://192.168.0.33:8000/api/v1/auth/login';
    final data = {
      "email": email,
      "password": password,
    };

    final dio = Dio();

    try {
      Response response;
      response = await dio.post(url, data: data);

      if (response.statusCode == 200) {
        _status = Status.Authenticated;
        _token = response.data['access_token'];
        await storeUserData(response.data);
        _notification = NotificationText('login');
        print('login');
        notifyListeners();
        return true;
      }

      if (response.statusCode == 401) {
        _status = Status.Unauthenticated;
        _notification = NotificationText('Invalid email or password.');
        print('Invalid email or password.');
        notifyListeners();
        return false;
      }

      _status = Status.Unauthenticated;
      _notification = NotificationText('Server error.');
      print('Server error.');
      return false;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> register(String name, String email, String password,
      String passwordConfirm) async {
    final url = Uri.parse('$api/register');

    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirm,
    };

    Map<String, dynamic> result = {
      "success": false,
      "message": 'Unknown error.'
    };

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      _notification = NotificationText(
          'Registration successful, please log in.',
          type: 'info');
      notifyListeners();
      result['success'] = true;
      return result;
    }

    Map apiResponse = json.decode(response.body);

    if (response.statusCode == 422) {
      if (apiResponse['errors'].containsKey('email')) {
        result['message'] = apiResponse['errors']['email'][0];
        return result;
      }

      if (apiResponse['errors'].containsKey('password')) {
        result['message'] = apiResponse['errors']['password'][0];
        return result;
      }

      return result;
    }

    return result;
  }

  Future<bool> passwordReset(String email) async {
    final url = Uri.parse('$api/forgot-password');

    Map<String, String> body = {
      'email': email,
    };

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      _notification = NotificationText('Reset sent. Please check your inbox.',
          type: 'info');
      notifyListeners();
      return true;
    }

    return false;
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', apiResponse['access_token']);
    await storage.setString('name', apiResponse['user']['name']);
  }

  Future<String?> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? token = storage.getString('token');
    return token;
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification = NotificationText('Session expired. Please log in again.',
          type: 'info');
    }
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
