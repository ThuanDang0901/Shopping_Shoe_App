import 'dart:ui';
import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const K_PRIMARY_RED = Color(0xFFB71C1C); // Đỏ chủ đạo
const K_LIGHT_RED = Color(0xFFFFF0F0); // Đỏ nhạt nền
const K_TEXT_GREY = Color(0xFF757575); // Xám chữ mô tả

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"name": "Sneakers", "iconPath": "assets/img/icon_sneaker.png"},
      {"name": "Sports", "iconPath": "assets/img/icon_sport.png"},
      {"name": "Casual", "iconPath": "assets/img/icon_casual.png"},
      {"name": "Running", "iconPath": "assets/img/icon_running.png"},
      {"name": "Hiking", "iconPath": "assets/img/icon_hiking.png"},
    ];

    final List<Map<String, dynamic>> products = [
      {
        "name": "Nike Air Max 270",
        "price": 150.00,
        "imagePath": "assets/img/shoe_nike.png",
      },
      {
        "name": "Adidas Ultraboost 22",
        "price": 180.00,
        "imagePath": "assets/img/shoe_adidas.png",
      },
      {
        "name": "New Balance 327",
        "price": 120.00,
        "imagePath": "assets/img/shoe_nb.png",
      },
      {
        "name": "Puma Rider",
        "price": 110.00,
        "imagePath": "assets/img/shoe_puma.png",
      },
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        backgroundColor: K_PRIMARY_RED,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset("assets/img/logo_AUNORA.png"),
        ),
        title: Text(
          "AUNORA",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      //  NỘI DUNG CHÍNH
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildSearchBar(), _buildFlashSaleBanner()],
          ),
        ),
      ),
      // BOTTOM NAVIGATION BAR
    );
  }

  // WIDGET HELPER FUNCTIONS
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: K_TEXT_GREY),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for shoes, brands...",
                  hintStyle: GoogleFonts.poppins(color: K_TEXT_GREY),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3.2. WIDGET BANNER KHUYẾN MÃI
  Widget _buildFlashSaleBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: K_PRIMARY_RED,
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage("assets/img/shoe_banner2.png"),
            fit: BoxFit.contain,
            alignment: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SUMMER FLASH SALE!",
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "UP TO\n50% OFF",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              // Nút Shop Now
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Shop Now",
                  style: GoogleFonts.poppins(
                    color: K_PRIMARY_RED,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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
