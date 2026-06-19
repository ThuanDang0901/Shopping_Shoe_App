import 'package:application_shoe_ecommerce/module/presentation/screen/admin_main_board/admin_main_board.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/admin_manager_product/admin_manager_product.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/admin_order_manager/admin_order_manager.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/admin_setting/admin_setting.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/admin_user_manager/admin_user_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminWrapper extends StatefulWidget {
  const AdminWrapper({super.key});

  @override
  State<AdminWrapper> createState() => _AdminWrapperState();
}

class _AdminWrapperState extends State<AdminWrapper> {
  int _selectedPageIndex = 0;
  static final List<Widget> _pages = <Widget>[
    AdminMainBoard(),
    AdminManagerProduct(),
    AdminOrderManager(),
    AdminUserManager(),
    AdminSetting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A73E8),
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: "Products",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: "Users",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
