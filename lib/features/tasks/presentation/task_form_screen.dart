import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(
    this.title,
    this.description,
    this.priority, [
    this.dueDate,
  ]);

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;

  String get formattedDate {
    if (dueDate == null) return 'Sin fecha límite';
    return '${dueDate!.day.toString().padLeft(2, '0')}/${dueDate!.month.toString().padLeft(2, '0')}/${dueDate!.year}';
  }
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _priority = 'Media';
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority,
      _dueDate,
    );
    context.pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
                hintText: 'Ej. Entregar reporte de Flutter',
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) {
                  return 'Por favor, ingresa un título para la tarea.';
                }
                if (title.length < 3) {
                  return 'El título debe tener al menos 3 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descripción (Opcional)',
                hintText: 'Detalles adicionales...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: ['Alta', 'Media', 'Baja']
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _priority = value ?? 'Media'),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate == null
                    ? 'Fecha límite: No seleccionada (Opcional)'
                    : 'Fecha límite: ${_dueDate!.day.toString().padLeft(2, '0')}/${_dueDate!.month.toString().padLeft(2, '0')}/${_dueDate!.year}',
              ),
              trailing: TextButton(
                onPressed: _selectDate,
                child: Text(_dueDate == null ? 'Seleccionar' : 'Cambiar'),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Text('Guardar borrador'),
            ),
          ],
        ),
      ),
    );
  }
}
