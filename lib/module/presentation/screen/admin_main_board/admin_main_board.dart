import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_revenue_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_revenue_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/admin_order_manager/admin_order_manager.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/search_bar_widget.dart';
import 'package:application_shoe_ecommerce/utils/shipping_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminMainBoard extends StatefulWidget {
  const AdminMainBoard({super.key});

  @override
  State<AdminMainBoard> createState() => _AdminMainBoardState();
}

class _AdminMainBoardState extends State<AdminMainBoard> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER OVERVIEW
              Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/img/icon_men.png"),
                      ),
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard Overview",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Admin",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black87,
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F80ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // 2. DỮ LIỆU THỐNG KÊ & DANH SÁCH ĐƠN HÀNG (DÙNG CHUNG BLOCBUILDER)
              BlocBuilder<AdminRevenueCubit, AdminRevenueState>(
                builder: (context, state) {
                  String revenueText = "0đ";
                  String ordersText = "0";
                  String productsText = "0";
                  String usersText = "0";
                  bool isLoading = false;

                  if (state is AdminRevenueLoading) {
                    isLoading = true;
                  } else if (state is AdminRevenueError) {
                    revenueText = "Error";
                    ordersText = "Error";
                    productsText = "Error";
                    usersText = "Error";
                  } else if (state is AdminRevenueLoaded) {
                    revenueText =
                        "${state.totalRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ";
                    ordersText = "${state.totalOrders}";
                    productsText = "${state.totalProducts}";
                    usersText = "${state.totalUsers}";
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "QUICK OVERVIEW",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "View All",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2F80ED),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // --- CARD 1: TOTAL REVENUE ---
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F0FE),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.attach_money_rounded,
                                color: Color(0xFF2F80ED),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Revenue",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF2F80ED),
                                        ),
                                      )
                                    : Text(
                                        revenueText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // --- CARD 2: TOTAL ORDERS ---
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F0FE),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xFF2F80ED),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Orders",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF2F80ED),
                                        ),
                                      )
                                    : Text(
                                        ordersText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // --- CARD 3: PRODUCTS & ACTIVE USERS GRID ROW ---
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6F4EA),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.grid_view_rounded,
                                          color: Color(0xFF34A853),
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Products",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF34A853),
                                          ),
                                        )
                                      : Text(
                                          productsText,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF7E0),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.people_alt_outlined,
                                          color: Color(0xFFF9AB00),
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Active Users",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFFF9AB00),
                                          ),
                                        )
                                      : Text(
                                          usersText,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "+48 Signed up",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: const Color(0xFFE27413),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 3. DANH SÁCH 5 ĐƠN HÀNG GẦN ĐÂY ĐỘNG (REALTIME)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "RECENT ORDERS",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminOrderManager(),
                                ),
                              );
                            },
                            child: Text(
                              "View All",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2F80ED),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // KIỂM TRA TRẠNG THÁI HIỂN THỊ DANH SÁCH ĐƠN HÀNG
                      if (state is AdminRevenueLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFF2F80ED),
                            ),
                          ),
                        )
                      else if (state is AdminRevenueLoaded)
                        state.recentOrders.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "Chưa có đơn hàng nào hệ thống",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.recentOrders.length,
                                itemBuilder: (context, index) {
                                  final order = state.recentOrders[index];
                                  int totalQuantity = order.items.fold(
                                    0,
                                    (sum, item) => sum + item.quantity,
                                  );

                                  String formattedOrderPrice =
                                      ShippingCalculator.formatCurrency(
                                        order.total,
                                      );
                                  // Format ngày tháng hiển thị đơn hàng
                                  String formattedDate =
                                      "${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')} - ${order.createdAt.day}/${order.createdAt.month}";

                                  // Xác định màu sắc hiển thị tag phương thức thanh toán
                                  bool isCod = order.paymentMethod == 'cod';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade100,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "#ORD-${order.id?.substring(0, 6).toUpperCase() ?? 'NEW'}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFF7CD),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .access_time_filled_rounded,
                                                    color: Color(0xFFED6C02),
                                                    size: 13,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Pending",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color: const Color(
                                                        0xFFED6C02,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          child: Divider(
                                            height: 1,
                                            color: Color(0xFFF1F3F4),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Color(
                                                0xFFF5F5F5,
                                              ),
                                              backgroundImage: AssetImage(
                                                "assets/img/customer_user.png",
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    order.shippingAddress,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    formattedDate,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "$totalQuantity Items",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                                Text(
                                                  formattedOrderPrice,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF1A73E8,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          child: Divider(
                                            height: 1,
                                            color: Color(0xFFF1F3F4),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.credit_card_rounded,
                                                  color: isCod
                                                      ? Colors.orange
                                                      : const Color(0xFF34A853),
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  isCod
                                                      ? "Paid via COD"
                                                      : "Paid via ApplePay",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey.shade500,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Track",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: const Color(
                                                      0xFF1A73E8,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Color(0xFF1A73E8),
                                                  size: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                      else
                        const SizedBox(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
