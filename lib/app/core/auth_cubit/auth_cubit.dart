import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cubit_auth_app/app/core/exceptions/auth_exception.dart';
import 'package:cubit_auth_app/app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required AuthRepository authRepository})
      : _repository = authRepository,
        super(const AuthState.initial());

  void checkLoginStatus() {
    final user = _repository.getCurrentUser();
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());

    try {
      await _repository.signInWithEmailAndPassword(email, password);

      final user = _repository.getCurrentUser();

      emit(AuthState.authenticated(user!));
    } on LoginException catch (e, s) {
      log('❌ Erro ao realizar login 2: $e', error: e, stackTrace: s);
      emit(AuthState.error(e.message));
    } on AuthException catch (e, s) {
      log('❌ Erro de autenticação: $e', error: e, stackTrace: s);
      emit(AuthState.error('Erro de autenticação: ${e.message}'));
    } catch (e, s) {
      log('❌ Erro desconhecido ao realizar login: $e', error: e, stackTrace: s);
      emit(AuthState.error('Erro desconhecido - $e'));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(const AuthState.loading());
    try {
      await _repository.registerWithEmailAndPassword(email, password, name);
      final user = _repository.getCurrentUser();
      emit(AuthState.authenticated(user!));
    } on RegisterException catch (e, s) {
      log('❌ Erro ao realizar login: $e', error: e, stackTrace: s);
      emit(AuthState.error(e.message));
    } on AuthException catch (e, s) {
      log('❌ Erro de autenticação: $e', error: e, stackTrace: s);
      emit(AuthState.error('Erro de autenticação: ${e.message}'));
    } catch (e, s) {
      log('❌ Erro desconhecido ao realizar login: $e', error: e, stackTrace: s);
      emit(AuthState.error('Erro desconhecido - $e'));
    }
  }

  Future<void> logout() async {
    await _repository.signOut();
    try {
      emit(const AuthState.unauthenticated());
    } on LogoutException catch (e, s) {
      log('❌ Erro ao realizar logout: $e', error: e, stackTrace: s);
      emit(AuthState.error(e.message));
    } catch (e, s) {
      log('❌ Erro desconhecido ao realizar logout: $e',
          error: e, stackTrace: s);
      emit(AuthState.error('Erro desconhecido - $e'));
    }
  }
}
