import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

// init Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth State Stream Dipakai oleh GoRouter untuk trigger redirect saat login/logout
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

// currentUser
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseClientProvider).auth.currentUser;
});


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

// Controller — handle login, register, logout, loading state, error message
class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).signInWithEmail(
            email: email,
            password: password,
          );
      state = const AsyncData(null);
      return true;
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
      return false;
    } catch (_) {
      state = AsyncError('Terjadi kesalahan, coba lagi.', StackTrace.current);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).signUpWithEmail(
            email: email,
            password: password,
          );
      state = const AsyncData(null);
      return true;
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
      return false;
    } catch (_) {
      state = AsyncError('Terjadi kesalahan, coba lagi.', StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).signOut();
    state = const AsyncData(null);
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);