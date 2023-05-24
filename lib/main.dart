import 'package:flutter/material.dart';
import 'package:todo_app_eltodo/screens/screens.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo app Eltodo',
      theme: ThemeData(
        drawerTheme: const DrawerThemeData(
          scrimColor: Colors.black87,
        ),
        colorSchemeSeed: Colors.red,
        appBarTheme: const AppBarTheme(
          color: Colors.red,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.red,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
