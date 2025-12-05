import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalAuthService {
  static const String _keyCurrentUser = 'current_user';
  static const String _keyUsers = 'users';

  final StreamController<UserModel?> _authStateController =
      StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyCurrentUser);

    if (userJson != null) {
      _currentUser = UserModel.fromJson(json.decode(userJson));
      _authStateController.add(_currentUser);
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_keyUsers);

    if (usersJson == null) {
      throw Exception('No users found. Please register first.');
    }

    final users = Map<String, dynamic>.from(json.decode(usersJson));
    final hashedPassword = _hashPassword(password);

    if (!users.containsKey(email)) {
      throw Exception('User not found');
    }

    final userData = Map<String, dynamic>.from(users[email]);

    if (userData['password'] != hashedPassword) {
      throw Exception('Invalid password');
    }

    final user = UserModel(
      uid: userData['uid'],
      email: email,
      displayName: userData['displayName'],
    );

    _currentUser = user;
    await prefs.setString(_keyCurrentUser, json.encode(user.toJson()));
    _authStateController.add(user);

    return user;
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_keyUsers);

    Map<String, dynamic> users = {};
    if (usersJson != null) {
      users = Map<String, dynamic>.from(json.decode(usersJson));
    }

    if (users.containsKey(email)) {
      throw Exception('User already exists');
    }

    final uid = DateTime.now().millisecondsSinceEpoch.toString();
    final hashedPassword = _hashPassword(password);

    users[email] = {
      'uid': uid,
      'password': hashedPassword,
      'displayName': displayName,
    };

    await prefs.setString(_keyUsers, json.encode(users));

    final user = UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
    );

    _currentUser = user;
    await prefs.setString(_keyCurrentUser, json.encode(user.toJson()));
    _authStateController.add(user);

    return user;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);

    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}
