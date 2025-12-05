import '../models/user_model.dart';
import '../services/local_auth_service.dart';

class AuthRepository {
  final LocalAuthService _authService;

  AuthRepository(this._authService);

  Stream<UserModel?> get authStateChanges => _authService.authStateChanges;

  UserModel? get currentUser => _authService.currentUser;

  Future<void> initialize() async {
    await _authService.initialize();
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      return await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }
}
