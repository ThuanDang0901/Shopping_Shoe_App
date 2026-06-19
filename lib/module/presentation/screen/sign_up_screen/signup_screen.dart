import 'dart:ui';
import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/verify_account/verify_account.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial &&
            context.read<AuthCubit>().pendingEmail != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VerifyAccount()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEC5353), Color(0xFF1A1A1A)],
                  ),
                ),
              ),
              Positioned(
                top: 250,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              //
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Thương Hiệu
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Image.asset("assets/img/logo_AUNORA.png", scale: 8),
                          Text(
                            "AUNORA",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            "COLLECTIONS",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white70,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                      // Thẻ Bóng
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                width: 360,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 40,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.15),
                                      Colors.white.withValues(alpha: 0.05),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormFieldWidget(
                                      hintText: "Name",
                                      controller: _nameController,
                                      prefixIcon: Icons.person,
                                    ),
                                    SizedBox(height: 25),
                                    //Nhập EMAIL
                                    TextFormFieldWidget(
                                      hintText: "E-mail",
                                      controller: _emailController,
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(height: 25),
                                    //Nhập Password
                                    TextFormFieldWidget(
                                      hintText: "Password",
                                      controller: _passwordController,
                                      prefixIcon: Icons.lock_outline,
                                      isPassword: true,
                                    ),
                                    SizedBox(height: 25),
                                    TextFormFieldWidget(
                                      hintText: "Comfirm Password",
                                      controller: _confirmPasswordController,
                                      prefixIcon: Icons.lock_open_rounded,
                                      isPassword: true,
                                    ),
                                    SizedBox(height: 30),
                                    //Nút Sign Up
                                    GestureDetector(
                                      onTap: state is AuthLoading
                                          ? null
                                          : () {
                                              final name = _nameController.text
                                                  .trim();
                                              final email = _emailController
                                                  .text
                                                  .trim();
                                              final pass = _passwordController
                                                  .text
                                                  .trim();
                                              final confirmPassword =
                                                  _confirmPasswordController
                                                      .text
                                                      .trim();
                                              //
                                              if (name.isEmpty ||
                                                  email.isEmpty ||
                                                  pass.isEmpty) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Vui Lòng Nhập Thông Tin Đầy Đủ",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              if (pass != confirmPassword) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Mật Khẩu Xác Nhận Chưa Khớp !",
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              context
                                                  .read<AuthCubit>()
                                                  .register(email, pass, name);
                                            },
                                      child: Container(
                                        width: double.infinity,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEC5353),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                0xFFEC5353,
                                              ).withValues(alpha: 0.5),
                                              blurRadius: 20,
                                              offset: Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "SIGN UP",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Already have an account? SIGN IN",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
