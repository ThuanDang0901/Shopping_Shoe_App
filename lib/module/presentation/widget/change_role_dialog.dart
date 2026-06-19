import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/user.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_user_cubit.dart';

class ChangeRoleDialog extends StatelessWidget {
  final UserEntity user;
  final AdminUserCubit adminUserCubit;

  const ChangeRoleDialog({
    super.key,
    required this.user,
    required this.adminUserCubit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Color(0xFF2F80ED),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Thay đổi quyền hạn",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2F80ED),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chọn quyền mới cho tài khoản này:",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 20),

          // Nút bấm chọn Khách hàng (User)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.pop(context);
              // Sử dụng instance cubit được truyền từ màn hình chính
              adminUserCubit.changeUserRole(user.uid, 'user');
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF2F80ED).withValues(alpha: 0.2),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFEAF3FF),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF2F80ED),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Khách hàng (User)",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF2F80ED),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Nút bấm chọn Quản trị viên (Admin)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.pop(context);
              // Sử dụng instance cubit được truyền từ màn hình chính
              adminUserCubit.changeUserRole(user.uid, 'admin');
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF2F80ED),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF2F80ED),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Quản trị viên (Admin)",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
