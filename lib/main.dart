import 'package:application_shoe_ecommerce/TempSeeder.dart';
import 'package:application_shoe_ecommerce/di/injection_container.dart' as di;
import 'package:application_shoe_ecommerce/firebase_options.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_revenue_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_user_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/wishlist_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/onboarding_screen/onboarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kích hoạt nạp toàn bộ Object vào tổng kho trước khi chạy app
  await di.init();

  await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // print("-> Khởi tạo Firebase thành công!");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
  // try {
  //   await TempSeeder.seedShoesData();
  //   print("-> Nạp dữ liệu mẫu 10 đôi giày thành công!");
  // } catch (e) {
  //   print("Lỗi nạp dữ liệu mẫu: $e");
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AdminRevenueCubit>()..fetchRevenue(),
        ),
        BlocProvider(create: (context) => di.sl<OrderCubit>()),
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        BlocProvider(
          create: (context) => di.sl<ShoeCubit>()..fetchFeaturedShoes(),
        ),
        BlocProvider(
          create: (context) => di.sl<CategoryCubit>()..fetchCategories(),
        ),
        BlocProvider(create: (context) => di.sl<WishlistCubit>()),
        BlocProvider(create: (context) => di.sl<CartCubit>()),
        BlocProvider(
          create: (context) => di.sl<AdminUserCubit>()..fetchUsers(),
        ),
        BlocProvider(
          create: (context) => di.sl<AdminOrderCubit>()..fetchAllOrders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aunora Shoe Store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
