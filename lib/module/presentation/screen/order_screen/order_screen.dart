import 'package:application_shoe_ecommerce/module/presentation/cubit/order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/order_state.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:application_shoe_ecommerce/utils/shipping_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi dữ liệu đơn hàng ngay khi vào trang dựa trên ID tài khoản hiện tại
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<OrderCubit>().fetchUserOrders(user.uid);
    }
  }

  // Hàm Helper xác định màu sắc hiển thị trạng thái giống hệt Admin
  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'text': 'Pending',
          'color': const Color(0xFFFF9800),
          'bgColor': const Color(0xFFFFF3E0),
        };
      case 'confirmed':
        return {
          'text': 'Đã xác nhận',
          'color': const Color(0xFF2F80ED),
          'bgColor': const Color(0xFFEAF3FF),
        };
      case 'shipping':
        return {
          'text': 'Đang giao hàng',
          'color': const Color(0xFF9C27B0),
          'bgColor': const Color(0xFFF3E5F5),
        };
      case 'completed':
        return {
          'text': 'Thành công',
          'color': const Color(0xFF4CAF50),
          'bgColor': const Color(0xFFE8F5E9),
        };
      case 'cancelled':
        return {
          'text': 'Đã hủy',
          'color': const Color(0xFFE53935),
          'bgColor': const Color(0xFFFFEBEE),
        };
      default:
        return {
          'text': 'Chờ xử lý',
          'color': const Color(0xFFFF9800),
          'bgColor': const Color(0xFFFFF3E0),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        toolbarHeight: 65,
        backgroundColor: AppColors.primaryRed,
        title: Text(
          "MY ORDERS",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderListLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          if (state is OrderListError) {
            return Center(
              child: Text(
                "Lỗi khi tải đơn hàng: ${state.message}",
                style: GoogleFonts.inter(color: Colors.red),
              ),
            );
          }

          if (state is OrderListLoaded) {
            final myOrders = state.orders;

            if (myOrders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Bạn chưa có đơn hàng nào.",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: myOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = myOrders[index];
                final statusConfig = _getStatusConfig(order.status);
                int totalItemsCount = order.items.fold(
                  0,
                  (sum, item) => sum + item.quantity,
                );
                String formattedPrice = ShippingCalculator.formatCurrency(
                  order.total,
                );

                String formattedDate =
                    "${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}";

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#ORD-${order.id?.substring(0, 6).toUpperCase() ?? 'NEW'}",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusConfig['bgColor'],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 3.5,
                                  backgroundColor: statusConfig['color'],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  statusConfig['text'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: statusConfig['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Ngày đặt: $formattedDate",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF1F3F5)),
                      const SizedBox(height: 12),

                      // Danh sách các món đồ gọn trong đơn
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: order.items.isNotEmpty
                                ? Image.network(
                                    order.items.first.shoe.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey.shade200,
                                              width: 50,
                                              height: 50,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            ),
                                  )
                                : Container(
                                    color: Colors.grey.shade200,
                                    width: 50,
                                    height: 50,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.items.isNotEmpty
                                      ? order.items.first.shoe.name
                                      : "Sản phẩm giày",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  order.items.length > 1
                                      ? "và ${order.items.length - 1} sản phẩm khác"
                                      : "$totalItemsCount sản phẩm",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formattedPrice,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.paymentMethod == 'cod'
                                    ? 'COD'
                                    : 'Thẻ tín dụng',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
