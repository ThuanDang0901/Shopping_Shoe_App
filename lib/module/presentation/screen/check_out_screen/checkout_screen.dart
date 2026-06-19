import 'package:application_shoe_ecommerce/module/domain/entities/order_entity.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/order_state.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:application_shoe_ecommerce/utils/color_utils.dart';
import 'package:application_shoe_ecommerce/utils/shipping_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  final List<String> selectedCartItemIds;
  const CheckoutScreen({super.key, required this.selectedCartItemIds});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _shippingAddress;
  String _selectedPaymentMethod = 'apple_pay';

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _showAddressForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Nhập Địa Chỉ Nhận Hàng',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Số nhà, tên đường, phường/xã...',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE53935)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'Quận/Huyện, Tỉnh/Thành phố',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    hintText: 'e.g. Quận 12, TP. Hồ Chí Minh',
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE53935)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_addressController.text.isNotEmpty &&
                    _cityController.text.isNotEmpty) {
                  setState(() {
                    _shippingAddress =
                        '${_addressController.text}, ${_cityController.text}';
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Lưu',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, orderState) {
        if (orderState is OrderSuccess) {
          if (user != null) {
            context.read<CartCubit>().fetchCart(user.uid);
          }
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đặt Hàng Thành Công!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đơn hàng của bạn đã được ghi nhận trên hệ thống.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (orderState is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đặt hàng thất bại: ${orderState.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, orderState) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFC62828),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "CHECKOUT",
              style: GoogleFonts.playfairDisplay(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              if (cartState is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryRed),
                );
              }
              if (cartState is CartLoaded) {
                // --- LỌC RA CÁC MẶT HÀNG ĐƯỢC CHỌN MUA ĐỂ THANH TOÁN ---
                final cartItems = cartState.cartItems
                    .where(
                      (item) => widget.selectedCartItemIds.contains(item.id),
                    )
                    .toList();

                double subtotal = 0;
                double totalWeightKg = 0;

                for (var item in cartItems) {
                  subtotal += item.shoe.price * item.quantity;
                  totalWeightKg += 0.5 * item.quantity;
                }

                double shippingFee = cartItems.isEmpty
                    ? 0.0
                    : ShippingCalculator.calculateShipping(
                        totalWeightKg: totalWeightKg,
                        shippingAddress: _shippingAddress,
                        paymentMethod: _selectedPaymentMethod,
                        subtotalAmount: subtotal,
                      );

                double tax = cartItems.isEmpty ? 0.0 : 15000.0;
                double total = subtotal + shippingFee + tax;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- 1. SHIPPING ADDRESS ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Địa Chỉ Giao Hàng',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212529),
                              ),
                            ),
                            if (_shippingAddress != null)
                              TextButton(
                                onPressed: _showAddressForm,
                                child: Text(
                                  'Thay Đổi',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFE53935),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _shippingAddress == null
                            ? GestureDetector(
                                onTap: _showAddressForm,
                                child: Container(
                                  width: double.infinity,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: const Color(0xFFE9ECEF),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Color(0xFFE53935),
                                        size: 28,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Thêm Địa Chỉ Nhận Hàng',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFEBEE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: Color(0xFFE53935),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Địa Chỉ Nhà',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: const Color(0xFF212529),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _shippingAddress!,
                                            style: GoogleFonts.inter(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        const SizedBox(height: 24),

                        // --- 2. PHƯƠNG THỨC THANH TOÁN ---
                        Text(
                          'Phương Thức Thanh Toán',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212529),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => setState(
                            () => _selectedPaymentMethod = 'apple_pay',
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedPaymentMethod == 'apple_pay'
                                    ? const Color(0xFFE53935)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.apple_rounded,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Apple Pay',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: const Color(0xFF212529),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Đã liên kết',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  _selectedPaymentMethod == 'apple_pay'
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: _selectedPaymentMethod == 'apple_pay'
                                      ? const Color(0xFFE53935)
                                      : Colors.grey[300],
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPaymentMethod = 'cod'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedPaymentMethod == 'cod'
                                    ? const Color(0xFFE53935)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.local_shipping_rounded,
                                    color: Color(0xFF495057),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thanh Toán Khi Nhận Hàng (COD)',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: const Color(0xFF212529),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Trả tiền mặt khi giao hàng (+ Phí thu hộ Viettel Post)',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  _selectedPaymentMethod == 'cod'
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: _selectedPaymentMethod == 'cod'
                                      ? const Color(0xFFE53935)
                                      : Colors.grey[300],
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // --- 3. CHI TIẾT ĐƠN HÀNG ---
                        Text(
                          'Chi Tiết Đơn Hàng',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212529),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 28,
                            color: Color(0xFFE9ECEF),
                          ),
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final itemTotalPrice =
                                item.shoe.price * item.quantity;
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    color: const Color(0xFFE9ECEF),
                                    child: Image.asset(
                                      item.shoe.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.shoe.name,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: const Color(0xFF212529),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Số lượng: ${item.quantity}  |  Size: ${item.selectedSize}  | ',
                                            style: GoogleFonts.inter(
                                              color: Colors.grey[500],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.hexToColor(
                                                item.selectedColor,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  ShippingCalculator.formatCurrency(
                                    itemTotalPrice,
                                  ),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: const Color(0xFF212529),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const Divider(height: 36, color: Color(0xFFE9ECEF)),

                        // --- 4. BẢNG PHÂN TÍCH GIÁ TIỀN ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tạm tính hàng hóa',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ShippingCalculator.formatCurrency(subtotal),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212529),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phí vận chuyển (Viettel Post)',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ShippingCalculator.formatCurrency(shippingFee),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212529),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Thuế giá trị gia tăng',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ShippingCalculator.formatCurrency(tax),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212529),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: Color(0xFFE9ECEF)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng số tiền cần \n thanh toán',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF212529),
                              ),
                            ),
                            Text(
                              ShippingCalculator.formatCurrency(total),
                              style: GoogleFonts.inter(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // --- 5. NÚT ĐẶT HÀNG ---
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed:
                                (_shippingAddress == null ||
                                    cartItems.isEmpty ||
                                    orderState is OrderLoading)
                                ? null
                                : () {
                                    final order = OrderEntity(
                                      userId: user!.uid,
                                      userName:
                                          user.displayName ?? "Khách hàng",
                                      shippingAddress: _shippingAddress!,
                                      paymentMethod: _selectedPaymentMethod,
                                      items: cartItems,
                                      subtotal: subtotal,
                                      shippingFee: shippingFee,
                                      tax: tax,
                                      total: total,
                                      createdAt: DateTime.now(),
                                      status: 'pending',
                                    );
                                    context.read<OrderCubit>().submitOrder(
                                      order,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: orderState is OrderLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Confirm Order',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: Text('Giỏ hàng trống hoặc có lỗi xảy ra.'),
              );
            },
          ),
        );
      },
    );
  }
}
