import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/order_screen/order_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/list_options_widget.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // TRƯỜNG HỢP 1: NẾU USER CHƯA ĐĂNG NHẬP
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 90,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 20),
                Text(
                  "Account not logged in",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please log in to view your personal information and manage your orders.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    String displayName = user.displayName ?? "Alex Johnson";
    String displayEmail = user.email ?? "alex.johnson@example.com";

    return Scaffold(
      backgroundColor: Colors.white,
      // ---- 1. APP BAR PHÍA TRÊN ----
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 65,
        backgroundColor: AppColors.primaryRed,
        title: Text(
          "MY PROFILE",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // Xử lý sự kiện bật mapp setting
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: [
              // ---- 2. KHU VỰC AVATAR & THÔNG TIN CỦA USER ----
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryRed.withValues(
                                alpha: 0.2,
                              ),
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white70,
                            backgroundImage: AssetImage(
                              "assets/img/icon_user.png",
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      displayName,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayEmail,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ---- 4. KHU VỰC DANH SÁCH MENU TÙY CHỌN (LIST OPTIONS) ----
              // Hàng 1: My Orders
              ListOptionsWidget(
                leadingIcon: Icons.local_shipping_outlined,
                title: "My Order",
                subtitle: "Track, return, or buy again",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderScreen()),
                  );
                },
              ),

              // Hàng 2: Shipping Addresses
              ListOptionsWidget(
                leadingIcon: Icons.location_on_outlined,
                title: "Shipping Addresses",
                subtitle: "3 addresses saved",
                onTap: () {},
              ),
              // Hàng 3: Setting
              ListOptionsWidget(
                leadingIcon: Icons.settings_outlined,
                title: "Setting",
                subtitle: "All Setting For The App",
                onTap: () {},
              ),
              // Hàng 4: Notifications
              ListOptionsWidget(
                leadingIcon: Icons.notifications_none_rounded,
                title: "Notifications",
                subtitle: "Turn on/off push alerts",
                onTap: () {},
              ),
              // Hàng 5: Help & Support
              ListOptionsWidget(
                leadingIcon: Icons.help_outline_rounded,
                title: "Hepl & Support",
                subtitle: "FAQ and customer service",
                onTap: () {},
              ),

              const SizedBox(height: 25),
              // ---- 5. NÚT ĐĂNG XUẤT (LOG OUT) ----
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  onPressed: () async {
                    context.read<AuthCubit>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Log Out",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
