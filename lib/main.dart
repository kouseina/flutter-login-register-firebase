import 'package:flutter/material.dart';
import 'package:flutter_login_and_register/login.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  Widget getScreen() {
    return Login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: getScreen(),
    );
  }
}
