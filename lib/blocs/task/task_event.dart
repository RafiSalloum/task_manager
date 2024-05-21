import 'package:task_manager/data/model/task.dart';

abstract class TaskEvent {}

class FetchTasksEvent extends TaskEvent {}
class AddTaskEvent extends TaskEvent {
  final String title;

  AddTaskEvent({required this.title});
}
class UpdateTaskEvent extends TaskEvent {

  final Task task;

  UpdateTaskEvent({required this.task});
}
class DeleteTaskEvent extends TaskEvent {
  final Task task;

  DeleteTaskEvent({required this.task});
}