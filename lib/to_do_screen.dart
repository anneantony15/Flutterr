import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ToDoScreen(),
    );
  }
}

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Task> tasks = [];
  TextEditingController _taskController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();
  FocusNode _deadlineFocusNode = FocusNode();

  void addTask(String taskName, DateTime deadline) {
    setState(() {
      Task task = Task(name: taskName, deadline: deadline);
      tasks.add(task);
      _taskController.clear();
      _deadlineController.clear();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _deadlineController.dispose();
    _deadlineFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add a Task',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  FocusScope.of(context).requestFocus(_deadlineFocusNode);
                }
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _deadlineController,
              focusNode: _deadlineFocusNode,
              decoration: InputDecoration(
                labelText: 'Deadline',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    DateTime selectedDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    _deadlineController.text = selectedDateTime.toString();
                  }
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String taskName = _taskController.text;
                DateTime deadline = DateTime.parse(_deadlineController.text);
                if (taskName.isNotEmpty && deadline != null) {
                  addTask(taskName, deadline);
                }
              },
              child: Text(
                'Add Task',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical:
                16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Added Tasks:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return ListTile(
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deadline: ${task.getFormattedDeadline()}'),
                        SizedBox(height: 4.0),
                        Text('Status: ${task.isCompleted ? 'Completed' : 'Incomplete'}'),
                      ],
                    ),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          task.toggleCompletion();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String name;
  final DateTime deadline;
  bool isCompleted;

  Task({required this.name, required this.deadline, this.isCompleted = false});

  String getFormattedDeadline() {
    return '${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour}:${deadline.minute}';
  }

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }
}

