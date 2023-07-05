import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
  List guestList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialTaskData() {
    toDoList = [];
  }
  void createInitialGuestData() {
    guestList = [];
  }
  // load the data from database
  void loadTaskData() {
    toDoList = _myBox.get("TODOLIST");
  }
  void loadGuestData() {
    guestList = _myBox.get("GUESTLIST");
  }

  // update the database
  void updateTaskDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
  void updateGuestDataBase() {
    _myBox.put("GUESTLIST", guestList);
  }
}
