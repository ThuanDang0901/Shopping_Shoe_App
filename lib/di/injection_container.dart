import 'package:application_shoe_ecommerce/module/domain/usecases/GetUserOrdersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/AddProductUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetAllOrdersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetRecentOrdersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalOrdersCountUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalProductsCountUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalUsersCountUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetUsersUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/UpdateUserRoleUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/UpdateUserStatusUseCase.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_user_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:application_shoe_ecommerce/module/data/repository/AuthRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/CartItemRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/CategoryRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/OrderRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/ShoeRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/AuthRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CartRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/CategoryRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/OrderRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/AddToCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetAllCategoryUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetFeaturedShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetWishlistUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/LoginUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/PlaceOrderUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/RemoveFromCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SearchShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SignupUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/UpdateCartQuantityUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/GetTotalRevenueUseCase.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/admin_revenue_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/order_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/wishlist_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //1. TẦNG DATA - REPOSITORIES (Đăng ký Interface gốc -> Ép kiểu về Impl)
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());
  sl.registerLazySingleton<ShoeRepository>(() => Shoerepositoryimpl());
  sl.registerLazySingleton<CategoryRepository>(() => Categoryrepositoryimpl());
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl());

  //2. TẦNG DOMAIN - USE CASES
  sl.registerLazySingleton(() => GetTotalRevenueUseCase(sl()));
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl(), sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedShoesUseCase(sl()));
  sl.registerLazySingleton(() => SearchShoesUseCase(sl()));
  sl.registerLazySingleton(() => GetAllCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetWishlistUseCase(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalOrdersCountUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalProductsCountUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalUsersCountUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentOrdersUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserRoleUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetAllOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserOrdersUseCase(sl()));
  // Presention
  sl.registerFactory(
    () => AdminRevenueCubit(
      getTotalRevenueUseCase: sl(),
      getTotalOrdersCountUseCase: sl(),
      getTotalProductsCountUseCase: sl(),
      getTotalUsersCountUseCase: sl(),
      getRecentOrdersUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OrderCubit(placeOrderUseCase: sl(), getUserOrdersUseCase: sl()),
  );

  sl.registerFactory(() => AuthCubit(loginUseCase: sl(), signupUseCase: sl()));

  sl.registerFactory(
    () => ShoeCubit(sl(), searchShoesUseCase: sl(), addProductUseCase: sl()),
  );

  sl.registerFactory(() => CategoryCubit(sl()));

  sl.registerFactory(
    () => WishlistCubit(getWishlistUseCase: sl(), shoeRepository: sl()),
  );

  sl.registerFactory(
    () => CartCubit(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      updateCartQuantityUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminUserCubit(
      getUsersUseCase: sl(),
      updateUserRoleUseCase: sl(),
      updateUserStatusUseCase: sl(),
    ),
  );
  sl.registerFactory(() => AdminOrderCubit(getAllOrdersUseCase: sl()));
}
