import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/blocs/authentication/authentication_event.dart';
import 'package:task_manager/blocs/authentication/authentication_state.dart';
import 'package:task_manager/blocs/task/task_event.dart';
import 'package:task_manager/blocs/task/task_state.dart';
import 'package:task_manager/data/model/task.dart';
import 'package:task_manager/data/repositories/authentication_repository.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/blocs/authentication/authentication_bloc.dart';
import 'package:task_manager/blocs/task/task_bloc.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockSharedPreferences extends Mock implements SharedPreferences {}


void main() {
  group('Task App Tests', () {
    late MockHttpClient mockHttpClient;
    late MockSharedPreferences sharedPreferences;
    late TaskRepository taskRepository;
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    late TaskBloc taskBloc;

    setUp(() {
      mockHttpClient = MockHttpClient();
      sharedPreferences = MockSharedPreferences();
      taskRepository = TaskRepository();
      authenticationRepository = AuthenticationRepository(
        sharedPreferences: sharedPreferences,
      );
      authenticationBloc = AuthenticationBloc(
        sharedPreferences: sharedPreferences,
        authenticationRepository: authenticationRepository,
      );
      taskBloc = TaskBloc(taskRepository: taskRepository);
    });

    group('Authentication Tests', () {
      test('Login Success', () async {
        // Mock API response
        when(mockHttpClient.post(
          Uri.parse('https://dummyjson.com/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          '{"token": "dummyAuthToken"}',
          200,
        ));

        // Trigger the login event
        authenticationBloc.add(LoginEvent(
          username: 'testUser',
          password: 'testPassword',
        ));

        // Expect the authentication state to be AuthenticationSuccess
        await expectLater(
          authenticationBloc.stream,
          emits(AuthenticationSuccess()),
        );

        // Verify that the auth token is saved in SharedPreferences
        verify(sharedPreferences.setString('authToken', 'dummyAuthToken'));
      });

      test('Login Failure', () async {
        // Mock API response
        when(mockHttpClient.post(
          Uri.parse('https://dummyjson.com/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          '',
          401,
        ));

        // Trigger the login event
        authenticationBloc.add(LoginEvent(
          username: 'testUser',
          password: 'testPassword',
        ));

        // Expect the authentication state to be AuthenticationFailure
        await expectLater(
          authenticationBloc.stream,
          emits(AuthenticationFailure(errorMessage: 'Login failed')),
        );

        // verifyNever(sharedPreferences.setString(any, any));
      });
    });

    group('Task CRUD Tests', () {
      test('Fetch Tasks Success', () async {
        // Mock API response
        when(mockHttpClient.get(Uri.parse('https://dummyjson.com/todos')))
            .thenAnswer((_) async => http.Response(
          '{"todos": [{"id": 1, "todo": "Task 1", "completed": false}, {"id": 2, "todo": "Task 2", "completed": true}]}',
          200,
        ));

        // Trigger the fetch tasks event
        taskBloc.add(FetchTasksEvent());

        // Expect the task state to be TaskLoaded with the correct tasks
        await expectLater(
          taskBloc.stream,
          emits(
            isA<TaskLoaded>().having(
                  (state) => state.tasks,
              'tasks',
              [
                Task(id: 1, title: 'Task 1', completed: false),
                Task(id: 2, title: 'Task 2', completed: true),
              ],
            ),
          ),
        );
      });

      test('Add Task Success', () async {
        // Mock API response
        when(mockHttpClient.post(
          Uri.parse('https://dummyjson.com/todos/add'),
          headers: {'Content-Type': 'application/json'},
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 201));

        // Trigger the add task event
        taskBloc.add(AddTaskEvent(title: 'New Task'));

        // Expect the task state to be TaskAddedSuccess with the success message
        await expectLater(
          taskBloc.stream,
          emits(
            TaskAddedSuccess(
              successMessage: 'Task "New Task" was added successfully!',
            ),
          ),
        );
      });

      test('Update Task Success', () async {
        // Mock API response
        when(mockHttpClient.put(
          Uri.parse('https://dummyjson.com/todos/1'),
          headers: {'Content-Type': 'application/json'},
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 200));

        // Trigger the update task event
        taskBloc.add(UpdateTaskEvent(
          task: Task(id: 1, title: 'Updated Task', completed: false),
        ));

        // Expect the task state to be TaskUpdatedSuccess with the success message
        await expectLater(
          taskBloc.stream,
          emits(
            TaskUpdatedSuccess(
            ),
          ),
        );
      });

      test('Delete Task Success', () async {
        // Mock API response
        when(mockHttpClient.delete(
          Uri.parse('https://dummyjson.com/todos/1'),
          headers: {'Content-Type': 'application/json'},
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 200));

        // Trigger the delete task event
        taskBloc.add(DeleteTaskEvent(task: Task(id: 1, title: 'Task 1', completed: false)));

        // Expect the task state to be TaskDeletedSuccess with the success message
        await expectLater(
          taskBloc.stream,
          emits(
            TaskDeletedSuccess(
            ),
          ),
        );
      });
    });
  });
}