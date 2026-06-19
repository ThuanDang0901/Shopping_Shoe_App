import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class TempSeeder {
  static Future<void> seedShoesData() async {
    final firestore = FirebaseFirestore.instance;
    final random = Random();

    // 1. Định nghĩa danh sách 10 mẫu giày độc lập kèm thông tin chi tiết
    final List<Map<String, dynamic>> rawShoesData = [
      {
        'name': 'Nike Air Max Elite',
        'brand': 'Nike',
        'price': 3200000.0,
        'image': 'assets/images/nike_air_max.png',
        'description':
            'Đôi giày chạy bộ cao cấp với đệm khí Air Max mang lại cảm giác êm ái tuyệt đối khi vận động suốt ngày dài.',
        'category': 'Running',
      },
      {
        'name': 'Adidas Ultraboost 22',
        'brand': 'Adidas',
        'price': 4500000.0,
        'image': 'assets/images/adidas_ultraboost.png',
        'description':
            'Dòng sản phẩm hoàn trả năng lượng đỉnh cao từ công nghệ Boost, ôm sát bàn chân mang lại trải nghiệm hoàn hảo.',
        'category': 'Running',
      },
      {
        'name': 'Puma Cali Sneaker',
        'brand': 'Puma',
        'price': 2100000.0,
        'image': 'assets/images/puma_cali.png',
        'description':
            'Thiết kế classic mang phong cách đường phố California, dễ dàng phối đồ cho các hoạt động thường nhật.',
        'category': 'Casual',
      },
      {
        'name': 'Jordan 1 Retro High',
        'brand': 'Jordan',
        'price': 5800000.0,
        'image': 'assets/images/jordan_1.png',
        'description':
            'Huyền thoại bóng rổ cổ cao mang tính biểu tượng văn hóa sneaker toàn cầu, chất liệu da thật cao cấp.',
        'category': 'Basketball',
      },
      {
        'name': 'New Balance 550',
        'brand': 'New Balance',
        'price': 3500000.0,
        'image': 'assets/images/nb_550.png',
        'description':
            'Mẫu giày retro mang hơi hướng thập niên 80, thiết kế cổ thấp năng động được giới trẻ săn đón rộng rãi.',
        'category': 'Casual',
      },
      {
        'name': 'Vans Old Skool Classic',
        'brand': 'Vans',
        'price': 1850000.0,
        'image': 'assets/images/vans_old_skool.png',
        'description':
            'Giày trượt ván truyền thống với sọc Sidestripe kinh điển, bền bỉ và không bao giờ lỗi mốt.',
        'category': 'Skate',
      },
      {
        'name': 'Converse Chuck 70 High',
        'brand': 'Converse',
        'price': 2000000.0,
        'image': 'assets/images/converse_70s.png',
        'description':
            'Nâng cấp từ dòng Classic với vải canvas dày dặn hơn, đế màu ngà vintage bóng bẩy và đệm lót êm ái.',
        'category': 'Casual',
      },
      {
        'name': 'Asics Gel-Kayano 29',
        'brand': 'Asics',
        'price': 3800000.0,
        'image': 'assets/images/asics_gel.png',
        'description':
            'Giày bảo hộ chạy bộ chuyên nghiệp, tích hợp công nghệ ổn định cấu trúc chân chống lật sơ mi hiệu quả.',
        'category': 'Running',
      },
      {
        'name': 'Reebok Club C 85',
        'brand': 'Reebok',
        'price': 2300000.0,
        'image': 'assets/images/reebok_club_c.png',
        'description':
            'Mẫu giày tennis cổ điển mang phong cách tối giản thanh lịch, chất da mềm mại tạo cảm giác thoải mái.',
        'category': 'Casual',
      },
      {
        'name': 'Nike Dunk Low Panda',
        'brand': 'Nike',
        'price': 3400000.0,
        'image': 'assets/images/nike_dunk_panda.png',
        'description':
            'Phối màu quốc dân Đen-Trắng cực hot, chất liệu da dễ lau chùi, phù hợp cho mọi outfit xuống phố.',
        'category': 'Casual',
      },
    ];

    List<int> dummySizes = [40, 41, 42, 43];
    List<String> dummyColors = [
      "#000000", // Đen
      "#FFFFFF", // Trắng
      "#FF0000", // Đỏ
    ];

    try {
      print("--- BẮT ĐẦU SEED DỮ LIỆU GIÀY CHUẨN ERP/SKU ---");

      for (var shoeData in rawShoesData) {
        // Thêm sản phẩm chính vào collection 'shoes'
        DocumentReference shoeRef = await firestore.collection('shoes').add({
          'name': shoeData['name'],
          'brand': shoeData['brand'],
          'price': shoeData['price'],
          'image': shoeData['image'],
          'description': shoeData['description'],
          'category': shoeData['category'],
          'sizes': dummySizes,
          'colors': dummyColors,
          'isActive': true,
          'soldCount': random.nextInt(50),
          'stockQuantity': 120,
        });

        print(
          "Đã thêm giày chính thành công: ${shoeData['name']} (ID: ${shoeRef.id})",
        );

        // Vòng lặp lồng tạo Sub-collection 'variants' với Custom Document ID trực quan
        for (var size in dummySizes) {
          for (var color in dummyColors) {
            int randomStock = 5 + random.nextInt(11);

            // Khởi tạo mã định danh biến thể tường minh theo thực tế ngoài đời
            String variantDocumentId = "${color}_$size";

            await shoeRef.collection('variants').doc(variantDocumentId).set({
              'size': size,
              'color': color,
              'stockQuantity': randomStock,
              'price': shoeData['price'],
            });

            print(
              "   -> Đã ghi nhận biến thể SKU: $variantDocumentId (Kho: $randomStock đôi)",
            );
          }
        }
        print(
          "-> Hoàn thành cấu hình 12 mã kho thực tế cho: ${shoeData['name']}\n",
        );
      }

      print(
        "--- HOÀN THÀNH SEED TOÀN BỘ DỮ LIỆU SẢN PHẨM MẪU CHUẨN THỰC TẾ ---",
      );
    } catch (e) {
      print("❌ LỖI KHI NẠP DỮ LIỆU MẪU: $e");
    }
  }
}
