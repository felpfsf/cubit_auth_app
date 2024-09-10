import 'package:cubit_auth_app/app/core/auth_cubit/auth_cubit.dart';
import 'package:cubit_auth_app/app/pages/home_page.dart';
import 'package:cubit_auth_app/app/pages/login_page.dart';
import 'package:cubit_auth_app/app/pages/register_page.dart';
import 'package:cubit_auth_app/app/pages/splash_page.dart';
import 'package:cubit_auth_app/app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitApp extends StatelessWidget {
  const CubitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(auth: FirebaseAuth.instance);
    return BlocProvider(
      create: (context) =>
          AuthCubit(authRepository: authRepository)..checkLoginStatus(),
      child: MaterialApp(
        title: 'Profit Pulse',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
