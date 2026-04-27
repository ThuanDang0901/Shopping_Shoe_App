import 'dart:ui';
import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/verify_account/verify_account.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                  SizedBox(height: 40),
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
                              TextFormFieldWidget(
                                hintText: "Name",
                                prefixIcon: Icons.person,
                              ),
                              SizedBox(height: 25),
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
                              SizedBox(height: 25),
                              TextFormFieldWidget(
                                hintText: "Comfirm Password",
                                prefixIcon: Icons.lock_open_rounded,
                                isPassword: true,
                              ),
                              SizedBox(height: 30),
                              //Nút Login
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyAccount(),
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
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
