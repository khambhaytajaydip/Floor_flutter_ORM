import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/database/app_database.dart';
import 'package:todolist/src/model/todo.dart';

/// Created by Jai on 15,May,2020
class AddTodo extends StatefulWidget {

  TextEditingController _textEditingController = new TextEditingController();

  @override
  State<StatefulWidget> createState() => _addTodoData();
}

class _addTodoData extends State<AddTodo>
  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add TODO'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.all(10),
            child: TextField(
              maxLines: 5,
              controller: widget._textEditingController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              onTap: () {},
            ),
          ),

          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed:()=> _saveCall(),
            child: Text('Save'),
            ),
          ),

          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              onPressed:()=> _saveBunkCall(),
              child: Text('Generate Bulk 100 Record'),
            ),
          )
        ],
      ),
    );
  }

  _saveCall() {
    final database = $FloorAppDatabase.databaseBuilder('tododatabase.db').build();
    database.then((onValu){
    onValu.todoDao.getMaxTodo().then((onValue){
      int id = 1;
      if(onValue != null){
       id=onValue.id+1;
      }
      onValu.todoDao.insertTodo(Todo(id,widget._textEditingController.value.text,DateFormat('dd-mm-yyyy kk:mm').format(DateTime.now()),""));
    });
  });
    Navigator.pop(context);
  }

  _saveBunkCall() {
    // add 100 records
    final database = $FloorAppDatabase.databaseBuilder('tododatabase.db').build();
    database.then((onValu){
      onValu.todoDao.getMaxTodo().then((onValue){
        int id = 1;
        if(onValue != null){
          id=onValue.id+1;
        }
        List<Todo> listBunkData =  [];
        for(int i = id;i < id+100;i++){
          listBunkData.add(Todo(i,i.toString(),DateFormat('dd-mm-yyyy kk:mm').format(DateTime.now()),""));
        }
        onValu.todoDao.insertAllTodo(listBunkData);
      });
    });
    Navigator.pop(context);

  }
}
