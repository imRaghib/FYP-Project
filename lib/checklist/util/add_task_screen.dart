import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  final controller;
  VoidCallback onSave;

  AddTaskScreen({
    required this.controller,
    required this.onSave,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Add a new task",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 50),
              child: ElevatedButton(
                  onPressed: onSave,
                  child: Text('Add')),
            )
          ],
        ),
      ),
    );
  }
}
