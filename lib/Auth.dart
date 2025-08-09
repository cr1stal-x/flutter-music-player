import 'package:flutter/material.dart';
import 'package:musix/testClient.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? username;
  String? password;
  String? email;
  bool? isVip;
  double? credit;
  String? profileCover;

  Future<bool> login(String username, String password, CommandClient client) async {
    final response = await client.sendCommand("login", username: username, password: password);

    if (response['status-code'] == 200) {
      _isAuthenticated = true;
      this.username = username;
      this.password = password;
      credit = response['credit']?.toDouble() ?? 0.0;
      isVip = response['isVip'] ?? false;
      email=response['email'];
      profileCover=response['profile_cover'];
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> signUp(String username, String email, String password, CommandClient client) async {
    final response = await client.sendCommand(
      "SignUp",
      username: username,
      email: email,
      password: password,
    );
    print('📤SignUp response: $response');
    if (response['status-code'] == 200) {
      _isAuthenticated = true;
      this.username = username;
      this.email = email;
      this.password = password;
      credit=200;
      isVip=false;

      notifyListeners();
      return true;
    }

    return false;
  }

  void logout() {
    _isAuthenticated = false;
    username = null;
    email = null;
    password = null;
    credit=null;
    isVip=null;
    profileCover=null;
    notifyListeners();
  }
  void updateField(String field, dynamic value) {
    switch (field) {
      case 'username':
        username = value;
        break;
      case 'email':
        email = value;
        break;
      case 'password':
        password = value;
        break;
      case 'credit':
        credit = value?.toDouble();
        break;
      case 'isVip':
        isVip = value;
        break;
      case 'profileCover':
        profileCover=value;
    }
    notifyListeners();
  }}
