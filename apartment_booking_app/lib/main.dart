import 'package:flutter/material.dart';

import 'ui/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/role_select_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/apartments_list_screen.dart';

void main() {
  runApp(const BaytiApp());
}

class BaytiApp extends StatelessWidget {
  const BaytiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bayti',
      debugShowCheckedModeBanner: false,
      theme: baytiTheme,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/role': (_) => const RoleSelectScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/apartments': (_) => const ApartmentsListScreen(),
      },
    );
  }
}
