import 'package:flutter/material.dart';
import 'package:todo_app_eltodo/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Todo'),
      ),
      drawer: const DrawerNavigation(),
    );
  }
}
