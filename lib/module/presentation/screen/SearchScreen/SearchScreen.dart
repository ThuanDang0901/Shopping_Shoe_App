import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/detail_screen.dart/detail_creen.dart';
import 'package:application_shoe_ecommerce/module/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ShoeCubit>().searchProducts("");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // ---- 1. KHU VỰC THANH TÌM KIẾM VÀ NÚT FILTER THEO ẢNH MẪU ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Nút Back mũi tên tròn bên trái
                  GestureDetector(
                    onTap: () {
                      // Xử lý sự kiện back nếu cần
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Thanh Tìm Kiếm Ô Nhập (TextField) bọc trong khung xám nhạt bo góc
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {
                          // Gọi Cubit lọc sản phẩm realtime khi gõ chữ
                          context.read<ShoeCubit>().searchProducts(value);
                        },
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade500,
                            size: 22,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    context.read<ShoeCubit>().searchProducts(
                                      "",
                                    );
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                )
                              : null,
                          hintText: "Search shoes...",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nút Cấu hình Filter màu đỏ vuông bo góc bên phải
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ---- 2. HIỂN THỊ TRẠNG THÁI SỐ LƯỢNG KẾT QUẢ TÌM THẤY ----
            BlocBuilder<ShoeCubit, ShoeState>(
              builder: (context, state) {
                int totalResults = 0;
                if (state is ShoeLoaded) {
                  totalResults = state.shoes.length;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Found $totalResults results for \"${_searchController.text}\"",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // ---- 3. LƯỚI GRIDVIEW HIỂN THỊ DANH SÁCH SẢN PHẨM ----
            Expanded(
              child: BlocBuilder<ShoeCubit, ShoeState>(
                builder: (context, state) {
                  if (state is ShoeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    );
                  } else if (state is ShoeError) {
                    return Center(child: Text(state.message));
                  } else if (state is ShoeLoaded) {
                    final resultShoes = state.shoes;

                    if (resultShoes.isEmpty) {
                      return Center(
                        child: Text(
                          "Không tìm thấy sản phẩm nào!",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      itemCount: resultShoes.length,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            0.76, // Tỉ lệ chiều cao thon dài giống ảnh mẫu của bạn
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        final shoe = resultShoes[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailCreen(shoe: shoe),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.grey.shade100,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Nội dung thông tin đôi giày bên trong thẻ
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Hình nền xám nhạt chứa ảnh chiếc giày bo góc mềm mại
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Hero(
                                            tag: shoe.name,
                                            child: Image.asset(
                                              shoe.image,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Tên sản phẩm hiển thị phía dưới ảnh sản phẩm
                                      Text(
                                        shoe.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
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
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
