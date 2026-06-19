import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/check_out_screen/checkout_screen.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:application_shoe_ecommerce/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> _selectedCartItemIds = [];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<CartCubit>().fetchCart(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 65,
        backgroundColor: AppColors.primaryRed,
        title: Text(
          "MY CART",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: user == null
            ? _buildRequireLogin()
            : BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    );
                  } else if (state is CartError) {
                    return Center(
                      child: Text(
                        "Đã xảy ra lỗi: ${state.message}",
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  } else if (state is CartLoaded) {
                    final items = state.cartItems;
                    if (items.isEmpty) {
                      return _buildEmptyCart();
                    }

                    // --- LOGIC TÍNH TOÁN THEO SẢN PHẨM ĐƯỢC CHỌN ---
                    double subtotal = 0;
                    final selectedItems = items
                        .where((item) => _selectedCartItemIds.contains(item.id))
                        .toList();

                    for (var item in selectedItems) {
                      subtotal += item.shoe.price * item.quantity;
                    }

                    bool isSelectAll =
                        items.isNotEmpty &&
                        _selectedCartItemIds.length == items.length;

                    return Column(
                      children: [
                        // 1. DANH SÁCH SẢN PHẨM TRONG GIỎ HÀNG
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 15,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final isChecked = _selectedCartItemIds.contains(
                                item.id,
                              );

                              String formattedItemPrice =
                                  "${item.shoe.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ";

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      activeColor: AppColors.primaryRed,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedCartItemIds.add(item.id);
                                          } else {
                                            _selectedCartItemIds.remove(
                                              item.id,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 85,
                                      height: 85,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        item.shoe.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Thông tin văn bản của sản phẩm
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.shoe.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.shoe.category,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),

                                          // Hiển thị Size và Màu sắc đã chọn thực tế
                                          Row(
                                            children: [
                                              Text(
                                                "Size: ${item.selectedSize}  |  Màu: ",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              Container(
                                                width: 11,
                                                height: 11,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.hexToColor(
                                                    item.selectedColor,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            formattedItemPrice,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          alignment: Alignment.topRight,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.grey.shade400,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<CartCubit>()
                                                .removeItemFromCart(
                                                  user.uid,
                                                  item.id,
                                                );
                                            setState(() {
                                              _selectedCartItemIds.remove(
                                                item.id,
                                              );
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => context
                                                    .read<CartCubit>()
                                                    .changeQuantity(
                                                      user.uid,
                                                      item.id,
                                                      item.quantity - 1,
                                                    ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${item.quantity}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => context
                                                    .read<CartCubit>()
                                                    .changeQuantity(
                                                      user.uid,
                                                      item.id,
                                                      item.quantity + 1,
                                                    ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- THANH TIỆN ÍCH: CHỌN TẤT CẢ ---
                              Row(
                                children: [
                                  Checkbox(
                                    value: isSelectAll,
                                    activeColor: AppColors.primaryRed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedCartItemIds = items
                                              .map((e) => e.id)
                                              .toList();
                                        } else {
                                          _selectedCartItemIds.clear();
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    "Chọn tất cả (${items.length})",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              _buildSummaryRow(
                                "Tạm tính",
                                "${subtotal.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ",
                              ),
                              const SizedBox(height: 6),
                              _buildSummaryRow(
                                "Phí vận chuyển",
                                selectedItems.isEmpty
                                    ? "0đ"
                                    : "Tính khi nhận hàng",
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(height: 1, color: Colors.white),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tổng cộng",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "${subtotal.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // NÚT BẤM CHECKOUT
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: selectedItems.isEmpty
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen(
                                                    selectedCartItemIds:
                                                        _selectedCartItemIds,
                                                  ),
                                            ),
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryRed,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey[300],
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "CHECK OUT (${_selectedCartItemIds.length})",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          Text(
            "Giỏ hàng của bạn đang trống",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequireLogin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              "Login Required",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Please login to look at and manage your personal wishlist.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
