import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/services/user/user_service.dart';
import 'package:validatorless/validatorless.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkk4i6SKvQ_RON_XMfWRW1QQjxQASL3gpp0rm6oQdKT6VmhITCo814Cnw1jpqNtBAfEdk&usqp=CAU';
                  },
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ?? 'Não informado';
                      },
                      builder: (_, value, __) {
                        return Text(
                          value,
                          style: context.textTheme.titleSmall,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Alterar Nome"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  final nameEC = TextEditingController();
                  final formKey = GlobalKey<FormState>();

                  return AlertDialog(
                    title: const Text('Alterar Nome'),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    content: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: nameEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('Nome obrigátorio'),
                          Validatorless.min(3, 'Nome deve conter ao menos 3 caracteres'),
                        ]),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            final name = nameEC.text;

                            Loader.show(context);

                            await context.read<UserService>().updateDisplayName(name);

                            Loader.hide();

                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: const Text("Alterar"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            onTap: () {
              context.read<HomeController>().deleteAllTasks();
              context.read<AuthProvider>().logout();
            },
            title: const Text("Sair"),
          ),
        ],
      ),
    );
  }
}
