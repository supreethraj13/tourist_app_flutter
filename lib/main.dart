import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourist/provider/userprovider.dart';
import 'package:smart_tourist/screens/Registerscreen.dart';
import 'package:smart_tourist/screens/homescreen.dart';
import 'package:smart_tourist/screens/loginscreen.dart';
import 'package:smart_tourist/screens/profilescreen.dart';
import 'package:smart_tourist/screens/qrscreen.dart';
import 'package:smart_tourist/screens/otpscreen.dart';

void main() {
  runApp(SafeArea(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Tourist Safety Monitor',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/register',
        routes: {
          '/login': (context) => LoginScreen(),
          '/qrscreen': (context) => const QrDisplayScreen(),
          '/verify-otp': (context) => const OTPScreen(),
          '/register': (context) => const Registerscreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
