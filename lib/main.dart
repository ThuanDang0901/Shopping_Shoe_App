import 'package:application_shoe_ecommerce/module/presentation/screen/login_creen/login_screen.dart';
import 'package:application_shoe_ecommerce/module/presentation/screen/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.white10)),
      home: OnboardingScreen(),
    );
  }
}
