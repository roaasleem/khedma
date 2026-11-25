import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/models/user_model.dart';
import 'package:khedma/features/auth/presentation/cubit/auth_state.dart';
import 'package:khedma/core/network/user_api_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final UserApiService userApiService = UserApiService();
  Future<void> signUp(UserModel user) async {
    try {
      emit(AuthLoading());

      final users = await userApiService.getUsers();

      final emailExists = users.any(
        (existingUser) =>
            existingUser.email.trim().toLowerCase() ==
            user.email.trim().toLowerCase(),
      );

      if (emailExists) {
        emit(AuthError('This email is already registered'));
        return;
      }

      final createdUser = await userApiService.createUser(user.toJson());

      emit(AuthAuthenticated(createdUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      emit(AuthLoading());
      final users = await userApiService.getUsers();
      final matchingUsers = users.where((user) => user.email == email).toList();
      if (matchingUsers.isEmpty) {
        emit(AuthError('User not found'));
        return;
      }
      final user = matchingUsers.first;
      if (user.password != password) {
        emit(AuthError('Wrong password'));
        return;
      }
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logOut() {
    emit(AuthInitial());
  }
}
