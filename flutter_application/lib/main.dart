import 'package:flutter/material.dart';
import 'package:flutter_application/screen/login/login_screen.dart';
import 'package:flutter_application/screen/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 2000)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: SplashScreen());
        } else {
          return const MaterialApp(
            title: 'Flutter Demo',
            home: LoginScreen(),
          );
        }
      },
    );
  }
}
