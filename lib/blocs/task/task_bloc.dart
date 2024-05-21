import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:task_manager/data/model/task.dart';
import 'package:task_manager/data/repositories/task_repository.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTasksEvent) {
      yield* _mapFetchTasksEventToState();
    } else if (event is AddTaskEvent) {
      yield* _mapAddTaskEventToState(event);
    } else if (event is UpdateTaskEvent) {
      yield* _mapUpdateTaskEventToState(event);
    } else if (event is DeleteTaskEvent) {
      yield* _mapDeleteTaskEventToState(event);
    }
  }

  // FETCH
  Stream<TaskState> _mapFetchTasksEventToState() async* {
    yield TaskLoading();
    try {
      final tasks = await taskRepository.fetchTasks();
      yield TaskLoaded(tasks: tasks);
    } catch (e) {
      yield TaskError(errorMessage: 'Failed to fetch tasks');
    }
  }

  // ADD
  Stream<TaskState> _mapAddTaskEventToState(AddTaskEvent event) async* {
    yield TaskLoading();
    try {
      final newTask = Task(
        completed: false,
        id: 0,
        title: event.title,
      );

      await taskRepository.saveTask(newTask);
      yield TaskAddedSuccess(successMessage: 'Task "$event.title" was added successfully!');
    } catch (e) {
      yield TaskError(errorMessage: 'Failed to add task');
    }
  }

  // UPDATE
  Stream<TaskState> _mapUpdateTaskEventToState(UpdateTaskEvent event) async* {
    yield TaskLoading();
    try {
      final updatedTask = Task(
        completed: event.task.completed,
        id: event.task.id,
        title: event.task.title,
      );
      await taskRepository.updateTask(updatedTask);
      yield TaskUpdatedSuccess();
    } catch (e) {
      yield TaskError(errorMessage: 'Failed to update task');
    }
  }

  // DELETE
  Stream<TaskState> _mapDeleteTaskEventToState(DeleteTaskEvent event) async* {
    yield TaskLoading();
    try {
      final updatedTask = Task(
        completed: event.task.completed,
        id: event.task.id,
        title: event.task.title,
      );
      await taskRepository.deleteTask(updatedTask);
      yield TaskDeletedSuccess();
    } catch (e) {
      yield TaskError(errorMessage: 'Failed to update task');
    }
  }
}

