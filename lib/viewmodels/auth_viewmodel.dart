import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../providers/auth_provider.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserModel? user;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> register(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.signOut();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthViewModel(authRepository);
});
