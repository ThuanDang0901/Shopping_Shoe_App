import 'dart:ui';
import 'package:application_shoe_ecommerce/module/presentation/widget/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyAccount extends StatelessWidget {
  const VerifyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEC5353), Color(0xFF1A1A1A)],
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tiêu đề phía trên card
                    Text(
                      "Verify account",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. Thẻ Glassmorphism (Card mờ)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: 360,
                          padding: const EdgeInsets.symmetric(
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
                              // Logo nhỏ bên trong card
                              Image.asset(
                                "assets/img/logo_AUNORA.png",
                                scale: 12,
                              ),
                              Text(
                                "AUNORA",
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                "COLLECTIONS",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Nội dung hướng dẫn
                              Text(
                                "By verifying your account, your data will be secured and by default you are accepting our terms and policies",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Ô nhập mã xác thực
                              TextFormFieldWidget(
                                hintText: "Verification Code",
                                prefixIcon: Icons.mail_outline_outlined,
                              ),
                              const SizedBox(height: 30),
                              // Nút Verify
                              GestureDetector(
                                onTap: () {
                                  // Xử lý verify
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEC5353),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFEC5353,
                                        ).withValues(alpha: 0.5),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Verify",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
