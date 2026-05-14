import 'dart:ui';

import 'package:application_shoe_ecommerce/module/presentation/screen/main_screen/main_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/main_screen/main_wrapper.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/sign_up_screen/signup_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/login_with_Social_widget.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Center(
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
                              //Nhập EMAIL
                              TextFormFieldWidget(
                                hintText: "E-mail",
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 25),
                              //Nhập Password
                              TextFormFieldWidget(
                                hintText: "Password",
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: false,
                                          onChanged: (value) {
                                            //Xử lý sự kiện
                                          },
                                          activeColor: Color(0xFFEC5353),
                                          side: BorderSide(
                                            color: Colors.white70,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Remember me",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Forgot Password?
                                  GestureDetector(
                                    onTap: () {
                                      // xử lý sự kiện
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              //Nút Login
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainWrapper(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEC5353),
                                    borderRadius: BorderRadius.circular(15),
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
                                      "SIGN IN",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white24,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      "OR SIGN IN WITH",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white60,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white24,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  // Nút Google
                                  LoginWithSocialWidget(
                                    label: "Google",
                                    iconPath: "assets/img/icon_gg.png",
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 15),
                                  // Nút Facebook
                                  LoginWithSocialWidget(
                                    label: "Facebook",
                                    iconPath: "assets/img/logo_facebook.png",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
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
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account? REGISTER",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
