import 'package:flutter/material.dart';
import 'package:pinjaman_mobile/api/pinjaman_service.dart';
import 'package:pinjaman_mobile/providers/pinjaman_provider.dart';
import 'package:pinjaman_mobile/screens/auth/register_screen.dart';
import 'package:pinjaman_mobile/screens/auth/splash_screen.dart';
import 'package:pinjaman_mobile/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import 'api/api_client.dart';
import 'api/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  final apiClient = ApiClient(baseUrl: "http://10.0.2.2:9194");
  final authService = AuthService(apiClient);
  final pinjamanService = PinjamanService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(
          create: (_) => PinjamanProvider(pinjamanService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/splash",
      routes: {
        "/splash": (_) => const SplashScreen(),
        "/login": (_) => const LoginScreen(),
        "/register": (_) => const RegisterScreen(),
        "/home": (_) => const HomeScreen(),
      },
    );
  }
}
