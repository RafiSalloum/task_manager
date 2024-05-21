import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/data/model/task.dart';
import 'package:task_manager/data/repositories/task_repository.dart';

void showDeleteSnackBar(BuildContext context, Task task, TaskRepository taskRepository) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(taskRepository: taskRepository),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Warning'),
              content: const Text('This task will be deleted'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Undo'),
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<TaskBloc>(context)
                        .add(DeleteTaskEvent(task: task));
                    Navigator.pop(context); // Close the bott
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}