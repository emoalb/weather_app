

import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: const Color(0xFF0A5688),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF3954F)),
          fontFamily:'Georgia'),
     initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        }
        );
  }
}

