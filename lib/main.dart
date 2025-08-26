import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/barber_shop_provider.dart';
import 'views/navigation_wrapper.dart';
import 'views/user_registration_screen.dart';
import 'views/login_screen.dart';
import 'design_system/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BarberShopProvider(),
      child: MaterialApp(
        title: 'Barbearia',
        debugShowCheckedModeBanner: false,
        theme: BarberTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<BarberShopProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<bool>(
                future: provider.loadUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final isLoggedIn = snapshot.data ?? false;
                  if (isLoggedIn) {
                    return const NavigationWrapper();
                  } else {
                    return const LoginScreen();
                  }
                },
              );
            },
          ),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const UserRegistrationScreen(),
          '/home': (context) => const NavigationWrapper(),
        },
      ),
    );
  }
}
