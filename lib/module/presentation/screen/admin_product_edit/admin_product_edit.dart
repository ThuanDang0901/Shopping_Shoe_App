import 'dart:io';
import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_state.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductEdit extends StatefulWidget {
  final Shoe
  shoe; // Nhận thực thể đôi giày được chọn để chỉnh sửa từ màn hình quản lý

  const AdminProductEdit({super.key, required this.shoe});

  @override
  State<AdminProductEdit> createState() => _AdminProductEditState();
}

class _AdminProductEditState extends State<AdminProductEdit> {
  final _formKey = GlobalKey<FormState>();

  // Khai báo các Controller quản lý nội dung nhập liệu
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;
  late TextEditingController _colorsController;
  late TextEditingController _sizesController;

  String? _selectedCategory;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    // Kích hoạt load danh mục từ Firebase phục vụ việc chọn thương hiệu liên kết
    context.read<CategoryCubit>().fetchCategories();

    // ĐỔ DỮ LIỆU CŨ CỦA SẢN PHẨM VÀO CÁC Ô NHẬP LIỆU (Đọc từ widget.shoe)
    _nameController = TextEditingController(text: widget.shoe.name);
    _skuController = TextEditingController(text: widget.shoe.sku);
    _priceController = TextEditingController(
      text: widget.shoe.price.toStringAsFixed(0),
    );
    _stockController = TextEditingController(
      text: widget.shoe.stockQuantity.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.shoe.description,
    );

    // Ghép mảng màu sắc và kích cỡ thành chuỗi hiển thị lên UI để Admin dễ sửa
    _colorsController = TextEditingController(
      text: widget.shoe.colors.join(', '),
    );
    _sizesController = TextEditingController(
      text: widget.shoe.sizes.join(', '),
    );

    // Đặt danh mục mặc định ban đầu là danh mục hiện tại của sản phẩm cần sửa
    _selectedCategory = widget.shoe.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _colorsController.dispose();
    _sizesController.dispose();
    super.dispose();
  }

  // Hàm chọn ảnh mới từ thiết bị nếu muốn thay thế ảnh cũ
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi chọn ảnh: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Xử lý logic kiểm tra và lưu thay đổi khi bấm nút UPDATE
  void _submitUpdateForm() {
    if (!_formKey.currentState!.validate()) return;

    final double? parsedPrice = double.tryParse(_priceController.text.trim());
    final int? parsedStock = int.tryParse(_stockController.text.trim());

    if (parsedPrice == null || parsedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Giá bán hoặc số lượng không hợp lệ!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final List<String> parsedColors = _colorsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final List<int> parsedSizes = _sizesController.text
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .where((e) => e != null)
        .cast<int>()
        .toList();

    if (parsedColors.isEmpty || parsedSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sản phẩm cần ít nhất 1 màu và 1 kích cỡ!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Đóng màn hình sau khi cập nhật thông tin thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đang lưu chỉnh sửa sản phẩm..."),
        backgroundColor: Colors.blue,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
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
                          "Product Detail",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Edit Product",
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
                const SizedBox(height: 24),

                // ==========================================
                // NỐI TIẾP: 2. KHU VỰC HIỂN THỊ & THAY ĐỔI ẢNH GIÀY
                // ==========================================
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: _pickedImage != null
                                ? Image.file(
                                    _pickedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : (widget.shoe.image.startsWith('assets/')
                                      ? Image.asset(
                                          widget.shoe.image,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : Image.network(
                                          widget.shoe.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2F80ED),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ==========================================
                // NỐI TIẾP: 3. Ô NHẬP TÊN SẢN PHẨM & MÃ SKU
                // ==========================================
                _buildTextField(
                  controller: _nameController,
                  label: "Product Name",
                  icon: Icons.abc,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _skuController,
                        label: "SKU Code",
                        icon: Icons.qr_code,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dropdown chọn thương hiệu danh mục (Đọc real-time từ Firebase)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            List<String> categories = [];
                            if (state is CategoryLoaded) {
                              categories = state.categories
                                  .map((c) => c.name)
                                  .toList();
                            }
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: categories.contains(_selectedCategory)
                                    ? _selectedCategory
                                    : null,
                                hint: Text(
                                  "Category",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                isExpanded: true,
                                items: categories.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) => setState(
                                  () => _selectedCategory = newValue,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ==========================================
                // NỐI TIẾP: 4. GIÁ BÁN & SỐ LƯỢNG KHO TỒN
                // ==========================================
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: "Price (VND)",
                        icon: Icons.attach_money,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _stockController,
                        label: "Stock Quantity",
                        icon: Icons.inventory_2_outlined,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ==========================================
                // NỐI TIẾP: 5. MÀU SẮC & KÍCH CỠ SẢN PHẨM
                // ==========================================
                _buildTextField(
                  controller: _colorsController,
                  label: "Colors (e.g., #000000, #FFFFFF)",
                  icon: Icons.color_lens_outlined,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _sizesController,
                  label: "Sizes (e.g., 39, 40, 41)",
                  icon: Icons.format_size_outlined,
                  isNumber: true,
                ),
                const SizedBox(height: 14),

                // ==========================================
                // NỐI TIẾP: 6. MÔ TẢ CHI TIẾT SẢN PHẨM
                // ==========================================
                _buildTextField(
                  controller: _descriptionController,
                  label: "Product Description",
                  icon: Icons.description_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 28),

                // ==========================================
                // NỐI TIẾP: 7. NÚT BẤM CẬP NHẬT THAY ĐỔI
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitUpdateForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "SAVE CHANGES",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Khối thiết kế định dạng TextForm nhập liệu dùng chung
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
      validator: (value) => value == null || value.trim().isEmpty
          ? "Vui lòng nhập thông tin"
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey.shade500,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
