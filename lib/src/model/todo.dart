import 'package:floor/floor.dart';

/// Created by Jai on 15,May,2020

@entity
class Todo {
@PrimaryKey(autoGenerate: true)
final int id;
final String task;
final String time;
final String scheduleTime;
@ignore
bool isSelect = false;
Todo(this.id,this.task,this.time,this.scheduleTime);
}