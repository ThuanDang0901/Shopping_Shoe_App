import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/admin_product_edit/admin_product_edit.dart';
import 'package:application_shoe_ecommerce/module/presentation/widget/admin_add_product_form.dart';
import 'package:application_shoe_ecommerce/utils/shipping_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminManagerProduct extends StatefulWidget {
  const AdminManagerProduct({super.key});

  @override
  State<AdminManagerProduct> createState() => _AdminManagerProductState();
}

class _AdminManagerProductState extends State<AdminManagerProduct> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    context.read<ShoeCubit>().searchProducts("");
  }

  @override
  void dispose() {
    super.dispose();
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
              // 1. HEADER PROFILE & ACTIONS (Giữ nguyên của bạn)
              // ==========================================
              Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey,
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
                        "Product Management",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Inventory Control",
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
              const SizedBox(height: 16),

              // ==========================================
              // 2. SEARCH BAR WITH FILTER BUTTON (Giữ nguyên của bạn)
              // ==========================================
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search brand, model, or SKU...",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune_rounded,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              BlocBuilder<ShoeCubit, ShoeState>(
                builder: (context, state) {
                  // Trạng thái đang tải từ Firebase
                  if (state is ShoeLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF2F80ED),
                        ),
                      ),
                    );
                  }
                  // Trạng thái tải lỗi
                  else if (state is ShoeError) {
                    return Center(
                      child: Text(
                        "Lỗi: ${state.message}",
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    );
                  }
                  // Trạng thái đã tải dữ liệu thành công từ Firebase về
                  else if (state is ShoeLoaded) {
                    final filteredShoes = _selectedCategory == 'All'
                        ? state.shoes
                        : state.shoes
                              .where(
                                (s) =>
                                    s.category.toLowerCase() ==
                                    _selectedCategory.toLowerCase(),
                              )
                              .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL PRODUCTS (${filteredShoes.length})",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (filteredShoes.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                "Không có đôi giày nào trong danh mục này.",
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredShoes.length,
                            itemBuilder: (context, index) {
                              final shoe = filteredShoes[index];
                              bool hasStock = shoe.stockQuantity > 0;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.asset(shoe.image),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                shoe.category.toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: const Color(
                                                    0xFF2F80ED,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: hasStock
                                                      ? const Color(0xFFE6F4EA)
                                                      : const Color(0xFFFFEAEA),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  hasStock
                                                      ? "Active"
                                                      : "Out of Stock",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: hasStock
                                                        ? const Color(
                                                            0xFF137333,
                                                          )
                                                        : Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            shoe.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Stock: ${shoe.stockQuantity} units | SKU: ${shoe.sku}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ShippingCalculator.formatCurrency(
                                                  shoe.price,
                                                ),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFE8F0FE,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 16,
                                                        color: Color(
                                                          0xFF2F80ED,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminProductEdit(
                                                                  shoe: shoe,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFFFEAEA,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        size: 16,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () {},
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
                          ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const AdminAddProductForm();
            },
          );
        },
        backgroundColor: const Color(0xFF2F80ED),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
