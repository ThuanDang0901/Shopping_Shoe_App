import 'package:flutter/material.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';

class CustomSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final bool showArrow;
  final VoidCallback? onTap;

  const CustomSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          if (showArrow) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.borderGrey,
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
