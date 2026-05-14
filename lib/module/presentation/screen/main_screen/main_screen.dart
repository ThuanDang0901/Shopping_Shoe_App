import 'dart:ui';
import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/banner_widget.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  int currentBanner = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        backgroundColor: AppColors.primaryRed,
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
            children: [
              //Banner
              CarouselSlider(
                items: [
                  // item 1
                  BannerWidget(
                    title: 'SUMMER FLASH SALE!',
                    subtitle: 'UP TO \n50% OFF',
                    imagePath: 'assets/img/shoe_banner2.png',
                  ),
                  // item 2
                  BannerWidget(
                    title: 'LAUNCHING THE NEW SUPER SHOE',
                    subtitle: '20% OFF \nFIRST 100 ORDERS ONLY',
                    imagePath: 'assets/img/shoe_banner.png',
                    subtitleSize: 20,
                  ),
                ],
                options: CarouselOptions(
                  height: 210,
                  viewportFraction: 1,
                  padEnds: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentBanner = index;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentBanner == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentBanner == index
                          ? AppColors.primaryRed
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
              // danh mục Sản phẩm
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "CATEGORY",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoryError) {
                    return Center(child: Text(state.message));
                  } else if (state is CategoryLoaded) {
                    final categories = state.categories;

                    return SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndex == index;
                          final item = categories[index];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              width: 75,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFB71C1C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    item.icon,
                                    width: 55,
                                    height: 55,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black54,
                                    colorBlendMode: BlendMode.srcIn,
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              SizedBox(height: 20),
              //sản phẩm phổ biến
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "FEATURED SHOE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              BlocBuilder<ShoeCubit, ShoeState>(
                builder: (context, state) {
                  if (state is ShoeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ShoeError) {
                    return Center(child: Text(state.message));
                  } else if (state is ShoeLoaded) {
                    final featuredShoes = state.shoes;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: featuredShoes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final shoe = featuredShoes[index];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Hình ảnh sản phẩm
                                      Expanded(
                                        child: Center(
                                          child: Image.asset(
                                            shoe.image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Tên sản phẩm
                                      Text(
                                        shoe.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Giá sản phẩm
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${shoe.price.toStringAsFixed(2)}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Nút thêm vào giỏ hàng
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            color: AppColors.primaryRed,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Xem Thêm",
                          style: TextStyle(
                            color: Colors.white,
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
      ),
    );
  }
}
