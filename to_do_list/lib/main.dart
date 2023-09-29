import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF363636), // Fondo de la aplicación
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tareas'), // Título del Navbar
          backgroundColor: Color(0xFF757575), // Color de fondo del Navbar
        ),
        body: TaskListScreen(),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void editTask(Task task, int index) {
    setState(() {
      tasks[index] = task;
    });
  }

  void completeTask(int index) {
    setState(() {
      Task completedTask = tasks.removeAt(index);
      completedTasks.add(completedTask);
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tareas pendientes: ${tasks.length}',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 168, 168, 168), // Color del texto
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onComplete: () => completeTask(index),
                  onEdit: (task) => editTask(task, index),
                  onDelete: () => deleteTask(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tareas finalizadas: ${completedTasks.length}',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 168, 168, 168), // Color del texto
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                return CompletedTaskCard(task: completedTasks[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(
                onSave: addTask,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF757575), // Color del botón
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Task({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });
}

class TaskFormScreen extends StatefulWidget {
  final void Function(Task) onSave;
  final Task? taskToEdit;

  TaskFormScreen({required this.onSave, this.taskToEdit});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    startDate = widget.taskToEdit?.startDate ?? DateTime.now();
    endDate = widget.taskToEdit?.endDate ?? DateTime.now();

    if (widget.taskToEdit != null) {
      titleController.text = widget.taskToEdit!.title;
      descriptionController.text = widget.taskToEdit!.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'), // Título en la página de formulario
        backgroundColor: Color(0xFF757575), // Color de fondo del Navbar
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Botón de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Regresar a la página anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(
                          0xFFD4D4D4), // Color del borde de la caja de texto
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFECECEC), // Color del texto de la etiqueta
                  ),
                ),
                style: TextStyle(
                  color:
                      Color(0xFFECECEC), // Color del texto de la caja de texto
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(
                          0xFFD4D4D4), // Color del borde de la caja de texto
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFECECEC), // Color del texto de la etiqueta
                  ),
                ),
                style: TextStyle(
                  color:
                      Color(0xFFECECEC), // Color del texto de la caja de texto
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Fecha y hora de inicio:',
                style: TextStyle(
                  color: Color(0xFFECECEC), // Color del texto
                ),
              ),
              DateTimePicker(
                initialDateTime: startDate,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    startDate = dateTime;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Fecha y hora de finalización:',
                style: TextStyle(
                  color: Color(0xFFECECEC), // Color del texto
                ),
              ),
              DateTimePicker(
                initialDateTime: endDate,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    endDate = dateTime;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final task = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      startDate: startDate,
                      endDate: endDate,
                    );
                    widget.onSave(task);
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF757575), // Color del botón
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final void Function(Task) onEdit;
  final VoidCallback onDelete;

  TaskCard({
    required this.task,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Color.fromARGB(255, 150, 150, 150), // Color del card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFECECEC), // Color del texto
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                color: Color(0xFFECECEC), // Color del texto
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit,
                      color: Color(0xFFECECEC)), // Color del ícono
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskFormScreen(
                          onSave: onEdit,
                          taskToEdit: task,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.check,
                      color: Color(0xFFECECEC)), // Color del ícono
                  onPressed: onComplete,
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: Color(0xFFECECEC)), // Color del ícono
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompletedTaskCard extends StatelessWidget {
  final Task task;

  CompletedTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      color: Color.fromARGB(
          255, 150, 150, 150), // Color del card de tareas completadas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFECECEC), // Color del texto
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                color: Color(0xFFECECEC), // Color del texto
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Completada el ${task.endDate.toString()}',
                  style: TextStyle(
                    color: Color(0xFFECECEC), // Color del texto
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  DateTimePicker({
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != selectedDateTime) {
                setState(() {
                  selectedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    selectedDateTime.hour,
                    selectedDateTime.minute,
                  );
                  widget.onDateTimeChanged(selectedDateTime);
                });
              }
            },
            child: Text(
              "${selectedDateTime.toLocal()}".split(' ')[0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFECECEC), // Color del texto
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedDateTime),
              );
              if (pickedTime != null) {
                setState(() {
                  selectedDateTime = DateTime(
                    selectedDateTime.year,
                    selectedDateTime.month,
                    selectedDateTime.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  widget.onDateTimeChanged(selectedDateTime);
                });
              }
            },
            child: Text(
              "${selectedDateTime.toLocal().hour}:${selectedDateTime.toLocal().minute}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFECECEC), // Color del texto
              ),
            ),
          ),
        ),
      ],
    );
  }
}
