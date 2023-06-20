import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_list/app/core/modules/todo_list_page.dart';

abstract class TodoListModule {
  final Map<String, WidgetBuilder> _routers;
  final List<SingleChildWidget>? _bidings;

  TodoListModule({
    List<SingleChildWidget>? bidings,
    required Map<String, WidgetBuilder> routers,
  })  : _bidings = bidings,
        _routers = routers;

  Map<String, WidgetBuilder> get routers {
    return _routers.map(
      (key, pageBuilder) => MapEntry(
        key,
        (_) => TodoListPage(
          bindings: _bidings,
          page: pageBuilder,
        ),
      ),
    );
  }

  Widget getPage(String path, BuildContext context) {
    final widgetBuilder = _routers[path];
    if (widgetBuilder != null) {
      return TodoListPage(
        page: widgetBuilder,
        bindings: _bidings,
      );
    }
    throw Exception();
  }
}
