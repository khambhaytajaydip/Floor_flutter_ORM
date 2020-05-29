import 'package:flutter/material.dart';
import 'package:todolist/src/dao/todo_dao.dart';
import 'package:todolist/src/database/app_database.dart';
import 'package:todolist/src/model/todo.dart';

import 'add_todo.dart';

/// Created by Jai on 14,May,2020

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  bool ckValue = false;
  TodoDao _todoDao;
  List<Todo> todoList = [];
  List<bool> cbList = [];

  //  List<bool> sizeOfList = ;
  final database = $FloorAppDatabase.databaseBuilder('tododatabase.db').build();

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // print debug
    // get dao
    debugPrint('build call');
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                List<Todo> listSelectedDat = widget.todoList.where((test) => test.isSelect == true).toList();
                widget._todoDao.deleteAll(listSelectedDat).then((onValue){
                  debugPrint('deleted values :${onValue}');
                  setState(() {
                  });
                });
              },
            )
          ],

        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<TodoDao>(
                    future: _calltheStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<TodoDao> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.none) {
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return StreamBuilder<List<Todo>>(
                            stream: snapshot.data.fetchStreamData(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.none) {
                                return Container(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if(widget.todoList.length != snapshot.data.length){
                                  widget.todoList = snapshot.data;
                                }

                                if(snapshot.data.length == 0){
                                  return Center(
                                    child: Text('No Data Found'),
                                  );
                                }

                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                            child: ListTile(
                                          leading: Checkbox(
                                            value: widget.todoList[index].isSelect,
                                            onChanged: (bool value) {
                                             setState(() {
                                               widget.todoList[index].isSelect = value;
                                             });
                                            },
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              _selectedDetele(snapshot.data[index].id);
                                            },
                                            child: Icon(Icons.delete),
                                          ),
                                          title: Text('${snapshot.data[index].task}',maxLines: 1,),
                                          subtitle: Text('${snapshot.data[index].time}',style: TextStyle(fontSize: 10),),
                                        ));
                                      }),
                                );
                              }
                            });
                      }
                    }),
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddScreen(),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  _openAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodo()),
    );
  }

  @override
  void initState() {
    super.initState();
    final database = $FloorAppDatabase.databaseBuilder('tododatabase.db').build();
    database.then((onValueP) {
      setState(() {
        widget._todoDao = onValueP.todoDao;
      });
    });
    debugPrint('call in init');
  }

  Future<TodoDao> _calltheStream() async {
  AppDatabase appDatabase =  await widget.database;
   widget._todoDao = appDatabase.todoDao;
  return appDatabase.todoDao;
  }

  void _selectedDetele(int id) {
   widget._todoDao.deleteTodo(id);
   setState(() {});
  }

}
