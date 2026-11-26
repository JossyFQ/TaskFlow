import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/local_task_repository.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

void main() {
  testWidgets('TaskFlowApp displays task list smoke test', (WidgetTester tester) async {
    // Build our app with the required Provider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<TasksViewModel>(
        create: (_) => TasksViewModel(LocalTaskRepository()),
        child: const TaskFlowApp(),
      ),
    );

    // Verify that the AppBar title 'Mis tareas' is present.
    expect(find.text('Mis tareas'), findsOneWidget);

    // Verify that sample tasks are displayed in the list.
    expect(find.text('Leer documentación'), findsOneWidget);
    expect(find.text('Diseñar pantalla'), findsOneWidget);
  });
}
