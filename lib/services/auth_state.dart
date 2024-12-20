import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthState extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool get isAuthenticated => _user != null;
}
