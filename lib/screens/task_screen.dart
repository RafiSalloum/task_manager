import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/services/functions/add_task.dart';
import 'package:task_manager/services/functions/delete_task.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_state.dart';

class TaskScreen extends StatelessWidget {
  final TextEditingController taskTitleController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();
  TaskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          } else if (state is TaskAddedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage),
              ),
            );
          }
        },
        builder: (context, state) {
          final taskBloc = BlocProvider.of<TaskBloc>(context);
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.blue[100],
                    ),
                    child: ListTile(
                      onLongPress: (){
                        showDeleteSnackBar(context, state.tasks[index], taskRepository);
                      },
                      trailing: Checkbox(
                          value: state.tasks[index].completed,
                          onChanged: (value) {
                            taskBloc.add(
                              UpdateTaskEvent(
                                  task: state.tasks[index],
                              ),
                            );
                          }),
                      title: Text(task.title),
                      subtitle: Text('Completed: ${task.completed}'),
                    ),
                  );
                },
              ),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          showAddTaskBottomSheet(context, taskTitleController, taskRepository);
          taskTitleController.clear();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
