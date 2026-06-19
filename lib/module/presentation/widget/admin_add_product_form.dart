import 'dart:io';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_state.dart'; // Đảm bảo import state của category
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddProductForm extends StatefulWidget {
  const AdminAddProductForm({super.key});

  @override
  State<AdminAddProductForm> createState() => _AdminAddProductFormState();
}

class _AdminAddProductFormState extends State<AdminAddProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorsController = TextEditingController();
  final _sizesController = TextEditingController();

  String? _selectedCategory;
  File? _pickedImage;

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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng chọn danh mục cho sản phẩm!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // if (_pickedImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Vui lòng bổ sung hình ảnh cho sản phẩm giày mới!"),
    //       backgroundColor: Colors.orange,
    //     ),
    //   );
    //   return;
    // }

    final double? parsedPrice = double.tryParse(_priceController.text.trim());
    final int? parsedStock = int.tryParse(_stockController.text.trim());

    if (parsedPrice == null || parsedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Giá bán hoặc số lượng phải là một số hợp lệ!"),
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
          content: Text("Sản phẩm phải có ít nhất 1 màu sắc và 1 kích cỡ!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context
        .read<ShoeCubit>()
        .addNewProduct(
          name: _nameController.text.trim(),
          sku: _skuController.text.trim().toUpperCase(),
          description: _descriptionController.text.trim(),
          price: parsedPrice,
          stockQuantity: parsedStock,
          category: _selectedCategory!,
          colors: parsedColors,
          sizes: parsedSizes,
          imageFile: _pickedImage ?? File(''),
        )
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đã lưu sản phẩm mới thành công!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        });
  }

  @override
  void initState() {
    super.initState();
    // Kích hoạt việc load dữ liệu danh mục từ Firebase khi mở Form
    context.read<CategoryCubit>().fetchCategories();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Thêm Giày Mới",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: _pickedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(_pickedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey.shade400,
                                size: 36,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Chọn ảnh thiết bị",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _nameController,
                label: "Tên Sản Phẩm Giày",
                icon: Icons.abc,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _skuController,
                      label: "Mã Định Danh SKU",
                      icon: Icons.qr_code,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // KHU VỰC SỬA: Đã bọc BlocBuilder xử lý bất đồng bộ từ Firebase
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
                          if (state is CategoryLoading) {
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          } else if (state is CategoryLoaded) {
                            // Map từ đối tượng Category Entity sang List chuỗi ký tự chứa Tên danh mục
                            final List<String> categories = state.categories
                                .map((c) => c.name)
                                .toList();

                            // Thiết lập giá trị được chọn đầu tiên nếu chưa có
                            if (_selectedCategory == null &&
                                categories.isNotEmpty) {
                              _selectedCategory = categories.first;
                            }

                            if (categories.isEmpty) {
                              return Text(
                                "Trống",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              );
                            }

                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
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
                                onChanged: (newValue) {
                                  setState(() => _selectedCategory = newValue);
                                },
                              ),
                            );
                          } else if (state is CategoryError) {
                            return Text(
                              "Lỗi tải dữ liệu",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: "Giá Bán (VNĐ)",
                      icon: Icons.attach_money,
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _stockController,
                      label: "Số Lượng Kho",
                      icon: Icons.inventory_2_outlined,
                      isNumber: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _buildTextField(
                controller: _colorsController,
                label: "Màu sắc (vd: #000000, #FFFFFF)",
                icon: Icons.color_lens_outlined,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _sizesController,
                label: "Kích cỡ (vd: 39, 40, 41)",
                icon: Icons.format_size_outlined,
                isNumber: true,
              ),
              const SizedBox(height: 14),

              _buildTextField(
                controller: _descriptionController,
                label: "Mô tả sản phẩm giày",
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "SAVE PRODUCT",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
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
      ),
    );
  }

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
          ? "Vui lòng nhập dữ liệu"
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
