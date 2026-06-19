import 'dart:math';

import 'package:application_shoe_ecommerce/module/data/services/auth_service.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/LoginUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SignupUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();
  String? pendingEmail;
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthCubit({required this.loginUseCase, required this.signupUseCase})
    : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.execute(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      pendingEmail = email;
      String otpCode = (Random().nextInt(900000) + 100000).toString();

      await _authService.savePendingUser(email, password, name, otpCode);
      await _authService.sendOTPEmail(email, otpCode);

      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOTP(String inputCode) async {
    if (pendingEmail == null) return;
    emit(AuthLoading());
    try {
      final doc = await _authService.getPendingData(pendingEmail!);
      if (doc.exists && doc['code'] == inputCode) {
        final user = await signupUseCase.execute(
          pendingEmail!,
          doc['password'],
          doc['name'],
        );
        await _authService.deletePendingData(pendingEmail!);
        emit(AuthSuccess(user));
      } else {
        emit(AuthError("Mã xác thực không chính xác"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await loginUseCase.repository.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError("Đăng xuất thất bại: ${e.toString()}"));
    }
  }
}
