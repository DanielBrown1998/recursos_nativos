import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/ui/_core/themes/themes.dart';
import 'package:flutter_banco_douro/ui/registration/registration_screen.dart';
import 'package:provider/provider.dart';
import 'data/repositories/account_repository.dart';
import 'data/repositories/camera_repository.dart';
import 'data/services/account_service.dart';
import 'ui/home/view_model/home_viewmodel.dart';
import 'ui/home/home_screen.dart';
import 'ui/login/login_screen.dart';
import 'ui/registration/view_model/registration_viewmodel.dart';

void main() {
  runApp(const BancoDouroApp());
}

class BancoDouroApp extends StatelessWidget {
  const BancoDouroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            AccountRepository(AccountService()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationViewModel(CameraRepository()),
        ),
      ],
      child: MaterialApp(
        theme: appThemeLight,
        routes: {
          "login": (context) => const LoginScreen(),
          "registration": (context) => const RegistrationScreen(),
          "home": (context) => const HomeScreen(),
        },
        initialRoute: "login",
      ),
    );
  }
}
