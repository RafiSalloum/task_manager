import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/data/repositories/task_repository.dart';

void showAddTaskBottomSheet(BuildContext context,
    TextEditingController controller, TaskRepository taskRepository) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider<TaskBloc>(
        create: (context) => TaskBloc(taskRepository: taskRepository),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      final taskTitle = controller.text;
                      BlocProvider.of<TaskBloc>(context)
                          .add(AddTaskEvent(title: taskTitle));
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
