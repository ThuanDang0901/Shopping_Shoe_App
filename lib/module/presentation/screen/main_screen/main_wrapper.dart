import 'package:application_shoe_ecommerce/module/presentation/screen/SearchScreen/SearchScreen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/cart_screen/cart_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/main_screen/main_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/profile_screen/profile_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/wishlist_screen/wishlist_creen.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedPageIndex = 0;
  static const List<Widget> _pages = <Widget>[
    MainScreen(),
    CartScreen(),
    Searchscreen(),
    WishlistCreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: _pages[_selectedPageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          // Tap Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          // Tab WishList
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          // Tab Cart
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          // Tab Cart
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Cart",
          ),
          // Tab Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: AppColors.primaryRed,
        onTap: _onItemTapped,
      ),
    );
  }
}
