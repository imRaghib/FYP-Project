import 'package:easy_shaadi/guest_list_content/add_guest.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'guest_list_tile.dart';
import '../checklist/data/database.dart';


class GuestList extends StatefulWidget {
  const GuestList({super.key});

  @override
  State<GuestList> createState() => _GuestListState();
}

class _GuestListState extends State<GuestList> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db1 = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever open in the app, then create default data
    if (_myBox.get("GUESTLIST") == null) {
      db1.createInitialGuestData();
    } else {
      // there already exists data
      db1.loadGuestData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db1.guestList[index][1] = !db1.guestList[index][1];
    });
    db1.updateGuestDataBase();
  }

  // save new task
  void saveNewGuest() {
    setState(() {
      if(_controller.text!=''){
        db1.guestList.add([_controller.text, false]);
        _controller.clear();
      }

    });
    Navigator.of(context).pop();
    db1.updateGuestDataBase();
  }


  // delete task
  void deleteGuest(int index) {
    setState(() {
      db1.guestList.removeAt(index);
    });
    db1.updateGuestDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          child: Icon(Icons.add),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (context)=>AddGuestScreen(
              controller: _controller,
              onSave: saveNewGuest,
            ));
          }
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              padding:EdgeInsets.only(top: 60,bottom:30,left:30,right:30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.list,size: 30,color: Colors.deepPurpleAccent,),
                    backgroundColor: Colors.white,
                    radius: 30 ,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Guest List',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  Text(
                    '${db1.guestList.length} guests',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  ),
                ),
                child: ListView.builder(
                  itemCount: db1.guestList.length,
                  itemBuilder: (context, index) {
                    return GuestTile(
                      GuestName: db1.guestList[index][0],
                      GuestCancel: db1.guestList[index][1],
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context) => deleteGuest(index),
                    );
                  },
                ),
              ),
            ),
          ]
      ),
    );
  }
}

