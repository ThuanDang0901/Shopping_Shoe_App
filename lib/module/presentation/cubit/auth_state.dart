import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError(this.errorMessage);
}

class AuthLoggedOut extends AuthState {}
