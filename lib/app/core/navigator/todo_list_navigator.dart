import 'package:flutter/widgets.dart';

class TodoListNavigator {
  TodoListNavigator._();

  static final navigationKey = GlobalKey<NavigatorState>();
  static NavigatorState? get to => navigationKey.currentState;
}
