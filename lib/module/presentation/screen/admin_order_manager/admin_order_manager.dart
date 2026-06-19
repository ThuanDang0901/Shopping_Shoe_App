import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_order_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/search_bar_widget.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:application_shoe_ecommerce/utils/shipping_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrderManager extends StatefulWidget {
  const AdminOrderManager({super.key});

  @override
  State<AdminOrderManager> createState() => _AdminOrderManagerState();
}

class _AdminOrderManagerState extends State<AdminOrderManager> {
  @override
  void initState() {
    super.initState();

    context.read<AdminOrderCubit>().fetchAllOrders();
  }

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
              // ==========================================
              // 1. THANH TIÊU ĐỀ TRÊN CÙNG
              // ==========================================
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
                        "Access Control",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Order Management",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textDark,
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
                      border: Border.all(
                        color: AppColors.borderGrey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.textDark,
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
                      color: AppColors.primaryBlue,
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
              const SizedBox(height: 24),

              // ==========================================
              // 2. TIÊU ĐỀ "TODAY'S OVERVIEW"
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TODAY'S OVERVIEW",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrey,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SearchBarWidget(
                hintText: "search Order ID, .....",
                onChanged: (value) {
                  // search
                },
              ),
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "1,284",
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up_rounded,
                          color: Color(0xFF4EE475),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "+24 orders today",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF4EE475),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusItem("42", "Pending", const Color(0xFFFF9800)),
                  _buildStatusItem("118", "Confirmed", const Color(0xFF2F80ED)),
                  _buildStatusItem("235", "Shipping", const Color(0xFF9C27B0)),
                  _buildStatusItem("871", "Completed", const Color(0xFF4CAF50)),
                  _buildStatusItem("18", "Cancelled", const Color(0xFFE53935)),
                ],
              ),
              const SizedBox(height: 32),

              // ==========================================
              // 3. TIÊU ĐỀ KHU VỰC CHI TIẾT
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RECENT ORDERS",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrey,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    "Sort: Newest",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2F80ED),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 4. HIỂN THỊ DANH SÁCH ORDER ĐỘNG TỪ FIREBASE
              // ==========================================
              BlocBuilder<AdminOrderCubit, AdminOrderState>(
                builder: (context, state) {
                  if (state is AdminOrderLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  }

                  if (state is AdminOrderError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Lỗi tải đơn hàng: ${state.message}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (state is AdminOrderLoaded) {
                    final ordersList = state.orders;

                    if (ordersList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            "Hệ thống chưa ghi nhận đơn hàng nào.",
                            style: GoogleFonts.poppins(
                              color: AppColors.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }

                    // Render danh sách item
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordersList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final order = ordersList[index];

                        // Tính toán các thuộc tính hiển thị
                        int totalItemsCount = order.items.fold(
                          0,
                          (sum, item) => sum + item.quantity,
                        );
                        String formattedPrice =
                            ShippingCalculator.formatCurrency(order.total);

                        // Định dạng ngày: Nov 12 - 01:48 PM
                        String formattedDate =
                            "${order.createdAt.day}/${order.createdAt.month} - "
                            "${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}";

                        // Custom giao diện tinh gọn bo góc y hệt như bức ảnh được cung cấp
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hàng tiêu đề: Mã Đơn hàng và Trạng thái Chip tròn xanh dương mờ giống hệt hình ảnh mẫu
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#ORD-${order.id?.substring(0, 4).toUpperCase() ?? 'NEW'}",
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF2F80ED),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF3FF),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircleAvatar(
                                          radius: 3.5,
                                          backgroundColor: Color(0xFF2F80ED),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          order.status,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF2F80ED),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Giờ giấc mua hàng phía dưới mã đơn hàng
                              Text(
                                formattedDate,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Hộp thông tin Khách hàng lồng bên trong
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    // Avatar bo tròn mềm mại
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        "assets/img/customer_user.png",
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Tên và Số lượng sản phẩm
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order.userName
                                                .split(',')
                                                .last
                                                .trim(), // Lấy tạm tên tỉnh hoặc gán mặc định tên
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "$totalItemsCount item(s)",
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Số tiền & Phương thức thanh toán (Icon Thẻ Tín Dụng)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formattedPrice,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.credit_card_rounded,
                                              color: Color(0xFF2F80ED),
                                              size: 13,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              order.paymentMethod == 'cod'
                                                  ? 'COD'
                                                  : 'Credit Card',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: const Color(0xFF2F80ED),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String count, String label, Color dotColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  count,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
