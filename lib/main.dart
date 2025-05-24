import 'package:fintest/shop2.dart';
import 'package:flutter/material.dart';
import 'theme/theme_provider.dart';


import 'UserAccount.dart';

void main() {
  runApp(const MyApp());
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>ThemeProvider()),
    ],
    child: const MyApp(),
  ),
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: Shop2(category: 'pop'),
      //home: Login(),
      home: UserAccount(),
    );
  }
}
