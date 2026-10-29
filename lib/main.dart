import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String studentName = 'JosselynFQ';
  int pendingTasks = 3;
  final String courseName = 'Desarrollo de aplicaciones móviles';
  final String motivationalMessage = 'tienes pendientes';

  void addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  void completeTask() {
    if (pendingTasks == 0) return;
    setState(() {
      pendingTasks--;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*  const studentName = 'JosselynFQ';
    const pendingTasks = 3;
    const courseName = 'Desarrollo de aplicaciones móviles';
    const motivationalMessage = 'tienes pendientes';*/

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, size: 56),
                const SizedBox(height: 24),
                Text(
                  '¡Hola, $studentName!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text('Bienvenido/a a $courseName.'),
                const SizedBox(height: 12),
                Text('Mensaje de motivación: $motivationalMessage.'),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.pending_actions),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Tareas pendientes: $pendingTasks'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: addTask,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: completeTask,
                      icon: const Icon(Icons.check),
                      label: const Text('Completar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
