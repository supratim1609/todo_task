import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/local_auth_service.dart';

final localAuthServiceProvider = Provider<LocalAuthService>((ref) {
  return LocalAuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(localAuthServiceProvider);
  return AuthRepository(authService);
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});
