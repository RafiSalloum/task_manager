import 'package:task_manager/data/model/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded({required this.tasks});
}

class TaskError extends TaskState {
  final String errorMessage;

  TaskError({required this.errorMessage});
}
class TaskAddedSuccess extends TaskState {
  final String successMessage;

  TaskAddedSuccess({required this.successMessage});
}

class TaskUpdatedSuccess extends TaskState {}

class TaskDeletedSuccess extends TaskState {}
