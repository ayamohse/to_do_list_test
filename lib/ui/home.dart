import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_test/database/database_provider.dart';
import 'package:to_do_list_test/model/to_do_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  List<ToDoModel> todoList = [];
  ToDoModel? todoModel;
  bool value=false;

  Future<List<ToDoModel>> loadData() async {
    todoList = await DatabaseProvider.instance.readAllToDo();
    setState(() {});
    return todoList.isEmpty ? [] : todoList;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController text = TextEditingController();
  String ?task = '';
  ToDoModel? model;
  DateTime selectedDate = DateTime.now();
  bool isNew = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15)),
            child: AppBar(
              backgroundColor: Color(0xff6C60E1),
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 34),
                      child: Text(
                        "Tasker",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          DateFormat(' d ').format(DateTime.now()),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 35,
                              color: Color(0xffF98F12)),
                          textAlign: TextAlign.start,
                        ),
                        Column(
                          children: [
                            Text(
                              DateFormat(' MMM').format(DateTime.now()),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color(0xffF98F12)),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              DateFormat('yyyy').format(DateTime.now()),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(left: 150),
                          child: Text(
                            DateFormat(' EEEE').format(DateTime.now()).toString().substring(0, 4).toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Color(0xffF98F12)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6C60E1),
        onPressed: () {
          openAlertBox();
        },
        child: Icon(Icons.add, color: Color(0xffF98F12)),
      ),
      body: Column(
        children: [
          FutureBuilder<List<ToDoModel>>(
              future: loadData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  todoList = snapshot.data!;
                }
                return snapshot.hasData
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: todoList.length,
                          itemBuilder: (context, index) {
                            return _built(todoList[index],index);
                          },
                        ),
                      )
                    : Container();
              }),
        ],
      ),
    );
  }
  void _pickDateDialog() {
    showDatePicker(
        context: context,
        initialDate: selectedDate == null ? DateTime.now() : selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }
  openAlertBox({ToDoModel? model}) {
    if (model != null) {
      task = model.text;
      print(selectedDate);
      selectedDate = DateTime.tryParse(model.date!)!  ;
      isNew = true;
    } else {
      task = '';
      selectedDate = DateTime.now();
      isNew = false;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
                width: 300,
                height: 300,
                child:

                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            top: 8,
                          ),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "what is to be done ?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xffF98F12),
                                fontWeight: FontWeight.w500,
                              ),
                              //  textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                          ),
                          child:

                          TextFormField(
                            initialValue: task,
                            onSaved: (String? value) {
                              task = value;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Enter Task Here",
                              hintStyle: TextStyle(
                                fontSize: 17,
                              ),
                              labelStyle: TextStyle(color: Colors.grey.shade800),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color(0xffF98F12),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.5,
                                  color: Color(0xff6C60E1),
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your task';
                              }
                              return null;
                            },



                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            top: 8,
                          ),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Due date",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xffF98F12),
                                fontWeight: FontWeight.w500,
                              ),
                              //  textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.topLeft,
                            child: Row(children: [

                              IconButton(
                                icon: Icon(Icons.date_range_sharp),
                                color: Colors.grey.shade800,
                                onPressed: () {
                                  _pickDateDialog();
                                },
                              ),
                            ])),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xff6C60E1)),
                              foregroundColor:
                              MaterialStateProperty.all(Color(0xffF98F12)),
                            ),
                            onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();
            print("task :  $task");
            String b = selectedDate.toString();
            print("date : $b");

            isNew ? editData(model!.id!) : addData();
            print('Insert');
            Navigator.pop(context);
          }

                            },
                            child:  Text(isNew ? 'Edit Task' : 'Add Task'))

                      ],
                    ))  ),
          );
        });

  }
  addData() async {
    await DatabaseProvider.instance
        .createToDo(ToDoModel(text: task, date: selectedDate.toString(),status:0));
  }
  editData(int id) {
    _formKey.currentState?.save();
    DatabaseProvider.instance.updateToDo(ToDoModel(
        id: id,
        text: task,
        date: selectedDate.toString()
    ));
    print('Update');
    setState(() {
      isNew = false;
    });
  }

  _onEdit(ToDoModel model, int index) {
    openAlertBox(model: model);
  }
  _built(ToDoModel model, int index){
   return Row(
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding:
          const EdgeInsets.only(left: 15, top: 15),
          child: Container(
            height: MediaQuery.of(context).size.height *
                1 /
                9,
            width: MediaQuery.of(context).size.width *
                1 /
                1.1,
            child: Material(
                elevation: 14,
                borderRadius:
                BorderRadius.circular(8.0),
                shadowColor: Color(0xffF98F12),
                child: Padding(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context)
                          .size
                          .width *
                          1 /
                          30)),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Checkbox(value: value, onChanged: (val){
                      }),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(

                            "${todoList[index].text}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color:
                              Colors.grey.shade900,
                              fontSize: 18,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "${DateFormat('dd.MMMM.yyyy').format(DateTime.parse(todoList[index].date!))}",
                          //  "${todoList[index].date}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color:
                              Colors.grey.shade500,
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){  _onEdit(model, index);}, icon: Icon(Icons.edit, color: Color(0xffF98F12))),
                          IconButton(onPressed: (){ DatabaseProvider.instance.deleteToDo(todoList[index].id);}, icon: Icon(Icons.delete, color: Color(0xff6C60E1)),),
                        ],),


                    ],
                  ),
                )),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
