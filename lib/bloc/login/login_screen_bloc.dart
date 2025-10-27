import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/bloc/login/login_screen_event.dart';
import 'package:hipstarvideocall/bloc/login/login_screen_state.dart';
import 'package:hipstarvideocall/helper/logs.dart';
import 'package:hipstarvideocall/repository/login/login_repository_impl.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final LoginRepositoryImpl _repository;

  LoginBloc() : super(LoginState.initial()) {
    // Initialize repository instance
    _repository = LoginRepositoryImpl();

    // Event handlers
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, error: ''));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: ''));
    });

    on<LoginSubmitted>((event, emit) async {
      // Validation
      if (state.email.trim().isEmpty) {
        emit(state.copyWith(error: 'Email cannot be empty'));
        return;
      }

      if (state.password.trim().isEmpty) {
        emit(state.copyWith(error: 'Password cannot be empty'));
        return;
      }

      if (state.password.length < 6) {
        emit(state.copyWith(error: 'Password must be at least 6 characters'));
        return;
      }

      emit(state.copyWith(isSubmitting: true, error: ''));

      // Hide keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        // Call login API using internal repository
        final token = await _repository.login(state.email, state.password);

        Logs.info('LoginBloc: Login success, token: $token');

        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        Logs.error('LoginBloc: Login failed - $e');
        emit(state.copyWith(
          isSubmitting: false,
          error: e.toString().replaceAll('Exception: ', ''),
        ));
      }
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
