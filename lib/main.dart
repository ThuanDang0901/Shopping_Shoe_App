import 'package:application_shoe_ecommerce/TempSeeder.dart';
import 'package:application_shoe_ecommerce/firebase_options.dart';
import 'package:application_shoe_ecommerce/module/data/repository/AuthRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/CartItemRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/CategoryRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/ShoeRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/AddToCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetAllCategoryUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetFeaturedShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetWishlistUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/LoginUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/RemoveFromCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SearchShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SignUpUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/UpdateCartQuantityUseCase.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/auth_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/cart_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/wishlist_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/onboarding_screen/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await TempSeeder.seedShoes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final authRepo = AuthRepositoryImpl();
            return AuthCubit(
              loginUseCase: LoginUseCase(authRepo),
              signupUseCase: SignupUseCase(authRepo),
            );
          },
        ),
        BlocProvider(
          create: (context) => ShoeCubit(
            GetFeaturedShoesUseCase(Shoerepositoryimpl()),
            searchShoesUseCase: SearchShoesUseCase(Shoerepositoryimpl()),
          )..fetchFeaturedShoes(),
        ),
        BlocProvider(
          create: (context) =>
              CategoryCubit(GetAllCategoryUseCase(Categoryrepositoryimpl()))
                ..fetchCategories(),
        ),
        BlocProvider(
          create: (context) {
            final shoeRepo = Shoerepositoryimpl();
            return WishlistCubit(
              getWishlistUseCase: GetWishlistUseCase(shoeRepo),
              shoeRepository: shoeRepo,
            );
          },
        ),
        BlocProvider(
          create: (context) {
            final cartRepo = CartRepositoryImpl();
            return CartCubit(
              getCartUseCase: GetCartUseCase(cartRepo),
              addToCartUseCase: AddToCartUseCase(cartRepo),
              removeFromCartUseCase: RemoveFromCartUseCase(cartRepo),
              updateCartQuantityUseCase: UpdateCartQuantityUseCase(cartRepo),
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.white10)),
        home: OnboardingScreen(),
      ),
    );
  }
}
