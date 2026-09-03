import 'package:flutter/material.dart';
import '../../models/user_role.dart';

class SessionProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  UserRole? _role;
  SupporterSubRole? _supporterSubRole;

  String get name => _name;
  String get email => _email;
  UserRole? get role => _role;
  SupporterSubRole? get supporterSubRole => _supporterSubRole;

  void setSession({required String name, required String email}) {
    _name = name;
    _email = email;
    _role = null;
    _supporterSubRole = null;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _role = role;
    _supporterSubRole = null;
    notifyListeners();
  }

  void setSupporterSubRole(SupporterSubRole subRole) {
    _supporterSubRole = subRole;
    notifyListeners();
  }

  void clear() {
    _name = '';
    _email = '';
    _role = null;
    _supporterSubRole = null;
    notifyListeners();
  }
}
