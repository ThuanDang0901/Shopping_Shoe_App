import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/custom_settings_switch_tile.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/custom_settings_tile.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSetting extends StatelessWidget {
  const AdminSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. PROFILE CARD
              // ==========================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/img/icon_men.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: AppColors.white,
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.accentBlue,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nguyen Dang Thuan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Text(
                            'admin@gmail.com',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Super Admin',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 3,
                                      backgroundColor: AppColors.accentBlue,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Online',
                                      style: TextStyle(
                                        color: AppColors.accentBlue,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new,
                      color: AppColors.textGrey,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 2. ACCOUNT SECTION
              // ==========================================
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CustomSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.mail_outline,
                      title: 'Email Address',
                      trailingText: 'admin@shoestore.vn',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.phone_outlined,
                      title: 'Phone Number',
                      trailingText: '+84 901 234 567',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 3. STORE SECTION
              // ==========================================
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text(
                  'STORE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CustomSettingsTile(
                      icon: Icons.storefront,
                      title: 'Store Information',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.local_offer_outlined,
                      title: 'Currency & Pricing',
                      trailingText: 'USD \$',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'Shipping Providers',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 4. NOTIFICATIONS SECTION
              // ==========================================
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text(
                  'NOTIFICATIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CustomSettingsSwitchTile(
                      icon: Icons.notifications_none,
                      title: 'Push Notifications',
                      value: true,
                      onChanged: (val) {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsSwitchTile(
                      icon: Icons.shopping_cart_outlined,
                      title: 'New Order Alerts',
                      value: true,
                      onChanged: (val) {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsSwitchTile(
                      icon: Icons.warning_amber_rounded,
                      title: 'Low Stock Alerts',
                      value: true,
                      onChanged: (val) {},
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 5. APPLICATION SECTION
              // ==========================================
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text(
                  'APPLICATION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CustomSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      trailingText: 'Tiếng Việt',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.security,
                      title: 'Privacy & Security',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: AppColors.bgGrey,
                    ),
                    CustomSettingsTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      trailingText: 'v1.0.0',
                      showArrow: false,
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 6. SESSION SECTION
              // ==========================================
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text(
                  'SESSION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  title: const Text(
                    'Sign Out of Account',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.exit_to_app,
                    color: AppColors.primaryBlue,
                  ),
                  onTap: () async {
                    context.read<AuthCubit>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
