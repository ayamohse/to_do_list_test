import 'package:to_do_list_test/database/constants.dart';

class ToDoModel{
  final int? id;
  final String? text;
  final String? date;
  final int? status;

  const ToDoModel({
    this.id,
    this.text,
    this.date,
    this.status
  });

  Map<String, dynamic> toMap() {
    return {
       columnID: id ,
       columnText:text,
       columnDate:date,
       columnStatus:status,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      id: map[columnID],
      text: map[columnText] ,
      date: map[columnDate],
      status: map[columnStatus],
    );
  }
}