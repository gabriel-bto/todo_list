import '../../models/task_model.dart';

abstract class TasksRepository {
  Future<void> save(DateTime date, String description);
  Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end);
  Future<void> checkOrUncheckTask(TaskModel task);
  Future<void> deleteAllTasks();
  Future<void> deleteTask(TaskModel task);
}
