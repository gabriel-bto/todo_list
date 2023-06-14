import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list/app/repositories/user/user_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      drawer: const HomeDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<UserRepository>().logout();
          },
          child: const Text("LOGOUT"),
        ),
      ),
    );
  }
}
