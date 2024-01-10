import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habaybna/utils/regex_patterns.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);

    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    // print('AuthBloc - $change');
  }

  // @override
  // void onError(Object error, StackTrace stackTrace) {
  //   super.onError(error, stackTrace);
  // }

  void _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final email = event.email;
      final password = event.password;
      final regex = RegExp(RegexPatterns.emailPattern);

      if (!regex.hasMatch(email)) {
        return emit(AuthFailure(errorMessage: 'Invalid email address'));
      }
      if (password.length < 6) {
        return emit(AuthFailure(
            errorMessage: "Password can't be less than 6 characters"));
      }

      await Future.delayed(const Duration(seconds: 1), () {
        return emit(AuthSuccess(uid: '$email-$password')); //should come from db
      });
    } catch (e) {
      return emit(
        AuthFailure(errorMessage: e.toString()),
      );
    }
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1), () {
        return emit(AuthInitial());
      });
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
