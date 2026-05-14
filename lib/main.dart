import 'package:application_shoe_ecommerce/TempSeeder.dart';
import 'package:application_shoe_ecommerce/firebase_options.dart';
import 'package:application_shoe_ecommerce/module/data/repository/CategoryRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/data/repository/ShoeRepositoryImpl.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetAllCategoryUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetFeaturedShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/category_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/cubit/shoe_cubit.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/onboarding_screen/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          create: (context) =>
              ShoeCubit(GetFeaturedShoesUseCase(Shoerepositoryimpl()))
                ..fetchFeaturedShoes(),
        ),
        BlocProvider(
          create: (context) =>
              CategoryCubit(GetAllCategoryUseCase(Categoryrepositoryimpl()))
                ..fetchCategories(),
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
