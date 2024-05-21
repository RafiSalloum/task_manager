import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/data/repositories/authentication_repository.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/screens/task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final TaskRepository taskRepository = TaskRepository();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(sharedPreferences: sharedPreferences);
  runApp(TaskManagerApp(
    sharedPreferences: sharedPreferences,
    taskRepository: taskRepository,
    authenticationRepository: authenticationRepository,
  ));
}

class TaskManagerApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final TaskRepository taskRepository;
  final AuthenticationRepository authenticationRepository;

  const TaskManagerApp({
    super.key,
    required this.sharedPreferences,
    required this.taskRepository,
    required this.authenticationRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                sharedPreferences: sharedPreferences,
                authenticationRepository: authenticationRepository,
              ),
              child: LoginScreen(),
            ),
        '/task': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<TaskBloc>(
                  create: (context) => TaskBloc(taskRepository: taskRepository)
                    ..add(FetchTasksEvent()),
                ),
                BlocProvider<AuthenticationBloc>(
                  create: (context) => AuthenticationBloc(
                    sharedPreferences: sharedPreferences,
                    authenticationRepository: authenticationRepository,
                  ),
                ),
              ],
              child: TaskScreen(),
            ),
      },
    );
  }
}
