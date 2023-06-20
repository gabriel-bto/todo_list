import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/widget/todo_list_field.dart';

import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/widgets/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _descriptionEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    DefaultListenerNotifier(changeNotifier: context.read<TaskCreateController>()).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
        Navigator.pop(context);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              color: Colors.black,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: context.primaryColor,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<TaskCreateController>().save(_descriptionEC.text);
            }
          },
          label: const Text(
            "Salvar Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Criar Atividade',
                    style: context.titleStyle.copyWith(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),
                TodoListField(
                  label: '',
                  controller: _descriptionEC,
                  validator: Validatorless.required('Descrição é obrigatória'),
                ),
                const SizedBox(height: 20),
                CalendarButton(),
              ],
            ),
          ),
        ));
  }
}
