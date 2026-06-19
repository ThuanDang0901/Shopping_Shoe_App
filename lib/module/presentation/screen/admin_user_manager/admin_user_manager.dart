import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_user_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_user_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/change_role_dialog.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/search_bar_widget.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUserManager extends StatefulWidget {
  const AdminUserManager({super.key});

  @override
  State<AdminUserManager> createState() => _AdminUserManagerState();
}

class _AdminUserManagerState extends State<AdminUserManager> {
  @override
  void initState() {
    super.initState();
    // Kích hoạt UseCase tải danh sách tài khoản ngay khi vào màn hình
    context.read<AdminUserCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: SafeArea(
        child: BlocBuilder<AdminUserCubit, AdminUserState>(
          builder: (context, state) {
            if (state is AdminUserLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              );
            }

            if (state is AdminUserError) {
              return Center(
                child: Text(
                  "Đã xảy ra lỗi: ${state.message}",
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              );
            }

            if (state is AdminUserLoaded) {
              final users = state.users;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 1. THANH TIÊU ĐỀ TRÊN CÙNG (HEADER OVERVIEW)
                    // ==========================================
                    Row(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                "assets/img/icon_men.png",
                              ),
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
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
                              "User Management",
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
                              color: AppColors.borderGrey.withValues(
                                alpha: 0.5,
                              ),
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
                    const SizedBox(height: 18),

                    // ==========================================
                    // 2. Ô TÌM KIẾM CÓ CHỨA ICON BỘ LỌC (SEARCH BAR)
                    // ==========================================
                    Row(
                      children: [
                        Expanded(
                          child: SearchBarWidget(
                            hintText: "Search customer names or email...",
                            onChanged: (value) {
                              // Tương lai có thể thêm phương thức lọc danh sách user tại đây
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderGrey.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.tune_rounded,
                              color: AppColors.textDark.withValues(alpha: 0.8),
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderGrey.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Customers",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.customerCount.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderGrey.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Admins",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.adminCount.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // 4. TIÊU ĐỀ PHÂN KHU TÀI KHOẢN (SECTION TITLE)
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ACCOUNTS (${users.length})",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ==========================================
                    // 5. DANH SÁCH THẺ THÀNH VIÊN (USER LIST CARDS ĐỘNG)
                    // ==========================================
                    users.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                "Chưa có tài khoản nào đăng ký trên hệ thống",
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              // Xác định quyền hạn tài khoản trên UI dựa trên dữ liệu thực tế động từ server
                              final bool isAdmin =
                                  user.role.toLowerCase() == "admin";

                              // Gán trạng thái động từ thực thể UserEntity
                              final bool userActiveStatus = user.isActive;

                              const int mockTotalOrders = 0;
                              const double mockTotalSpent = 0.0;
                              final String defaultAvatar = isAdmin
                                  ? "assets/img/icon_men.png"
                                  : "assets/img/customer_user.png";

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.borderGrey.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // --- Hàng 1: Avatar, Thông tin tên, Quyền hạn và Trạng thái chip ---
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: AppColors.bgGrey,
                                          backgroundImage: AssetImage(
                                            defaultAvatar,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      user.name ??
                                                          'Chưa cập nhật tên',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .textDark,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isAdmin
                                                          ? AppColors
                                                                .primaryBlue
                                                          : const Color(
                                                              0xFFE8F0FE,
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      user.role.toUpperCase(),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 9,
                                                        color: isAdmin
                                                            ? Colors.white
                                                            : AppColors
                                                                  .primaryBlue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                user.email,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: AppColors.textGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: userActiveStatus
                                                ? const Color(0xFFE6F4EA)
                                                : const Color(0xFFFFEAEA),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            userActiveStatus
                                                ? "Active"
                                                : "Blocked",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: userActiveStatus
                                                  ? const Color(0xFF137333)
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // --- Hàng 2: Hộp hiển thị thông số chi tiết đơn hàng ---
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Total Orders",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: AppColors.textGrey,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "$mockTotalOrders",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 24,
                                            color: AppColors.borderGrey
                                                .withValues(alpha: 0.5),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Total Spent",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: AppColors.textGrey,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "${mockTotalSpent.toInt()}đ",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // --- Hàng 3: Các nút chức năng điều khiển tác vụ tác vụ (Đã tích hợp xử lý thẳng) ---
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // ==========================================
                                        // NÚT SỐ 1: EDIT ROLE (XỬ LÝ THẲNG QUA DIALOG)
                                        // ==========================================
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return ChangeRoleDialog(
                                                  user: user,
                                                  adminUserCubit: context
                                                      .read<AdminUserCubit>(),
                                                );
                                              },
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              side: BorderSide(
                                                color: AppColors.borderGrey
                                                    .withValues(alpha: 0.6),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Edit Role",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: AppColors.textDark
                                                  .withValues(alpha: 0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // ==========================================
                                        // NÚT SỐ 2: BLOCK / UNBLOCK USER (XỬ LÝ THẲNG CUBIT)
                                        // ==========================================
                                        TextButton(
                                          onPressed: () {
                                            // Đảo trạng thái dựa trên dữ liệu userActiveStatus thực tế
                                            context
                                                .read<AdminUserCubit>()
                                                .toggleUserStatus(
                                                  user.uid,
                                                  userActiveStatus,
                                                );
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: userActiveStatus
                                                ? const Color(0xFFFFEAEA)
                                                : const Color(0xFFE6F4EA),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: Text(
                                            userActiveStatus
                                                ? "Block User"
                                                : "Unblock",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: userActiveStatus
                                                  ? Colors.red
                                                  : const Color(0xFF137333),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
