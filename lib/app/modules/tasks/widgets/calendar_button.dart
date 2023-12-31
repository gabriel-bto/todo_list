import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  final dateFormat = DateFormat('dd/MM/yyyy');

  CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final currentDate = DateTime.now();

        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: currentDate.subtract(const Duration(days: 10 * 365)),
          lastDate: currentDate.add(const Duration(days: 10 * 365)),
        );

        if (context.mounted) context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.today, color: Colors.grey),
            const SizedBox(width: 10),
            Selector<TaskCreateController, DateTime?>(
              selector: (_, controller) => controller.selectedDate,
              builder: (_, value, __) {
                return Text(
                  value != null ? dateFormat.format(value) : "SELECIONE UMA DATA",
                  style: context.titleStyle,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
