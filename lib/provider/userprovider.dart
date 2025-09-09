import 'package:flutter/material.dart';
import 'package:smart_tourist/models/usermodel.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();
  bool _isProfileEditable = false;

  UserModel get user => _user;
  bool get isProfileEditable => _isProfileEditable;

  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void setEditable(bool editable) {
    _isProfileEditable = editable;
    notifyListeners();
  }
}
