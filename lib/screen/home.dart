import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlflit1/widget/buildTextFeild.dart';

class myHome extends StatefulWidget {
  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _ageC = TextEditingController();
  final _deptC = TextEditingController();
  final _gradeC = TextEditingController();
  late Database _database;
  @override
  void initState() {
    super.initState();
    _opendatabase();
  }

  _resetFields() {
    _nameC.text = "";
    _ageC.text = "";
    _gradeC.text = "";
    _deptC.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("SQLFLIT")),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextF("Name", _nameC),
                    buildTextF("Age", _ageC),
                    buildTextF("Grade", _gradeC),
                    buildTextF("Department", _deptC),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text("Save"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveStudent();
                            }
                          },
                        ),
                        ElevatedButton(
                            child: Text("Show Student"),
                            onPressed: () {
                              _showStudents();
                            }),
                        ElevatedButton(
                            onPressed: () {
                              _deleteStudents();
                            },
                            child: Text("Delete"))
                      ],
                    ),
                  ],
                )),
          ),
        ));
  }

  Future<void> _opendatabase() async {
    _database = await openDatabase(
      "students_db.db", //اسم القاعده
      version: 1, //اصدار قواعد البيانات
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            dept TEXT,
            age INTEGER,
            grade INTEGER
          )
        ''');
      },
    );
  }

  Future<void> _saveStudent() async {
    await _database.transaction((txt) async {
      await txt.rawInsert("""
    INSERT INTO students(name,age,dept,grade)
    VALUES("${_nameC.text.trim()}","${int.parse(_ageC.text.trim())}","${_deptC.text.trim()}","${int.parse(_gradeC.text.trim())}")
""");
    });
    _resetFields();
    showDialogDES("Save Successfully");
  }

  Future<void> _showStudents() async {
    final List<Map<String, dynamic>> students =
        await _database.query('students');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text("Students"),
            content: Column(
                children: students.map((student) {
              return Card(
                color: Color.fromARGB(255, 49, 92, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    title: Text("${student['name']}"),
                    subtitle: Text(
                        "Age: ${student['age']} \n Grade: ${student['grade']} \n Departement: ${student['dept']} \n"),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editStudent(student);
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteStudent(student['id']);
                            }),
                      ],
                    )),
              );
            }).toList()),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

//--------
  Future<void> _editStudent(Map<String, dynamic> student) async {
    _nameC.text = student['name'];
    _ageC.text = student['age'].toString();
    _deptC.text = student['dept'];
    _gradeC.text = student['grade'].toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text("Edit Student"),
            content: Column(
              children: [
                buildTextF("name", _nameC),
                buildTextF("age", _ageC),
                buildTextF("grade", _gradeC),
                buildTextF("department", _deptC),
              ],
            ),
            actions: [
              ElevatedButton(
                  child: Text("Update"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateStudent(student["id"]);
                      Navigator.of(context).pop();
                    }
                  }),
              ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> _updateStudent(int id) async {
    await _database.rawUpdate("""
  UPDATE students SET name =?, dept=? ,age=?,grade=?
  WHERE id = ?
""", [
      _nameC.text,
      _deptC.text,
      int.parse(_ageC.text.trim()),
      int.parse(_gradeC.text.trim()),
      id
    ]);
    _resetFields();
    Navigator.of(context).pop();
    showDialogDES("Updated Success");
  }

  Future<void> _deleteStudent(int id) async {
    _database.rawDelete("""
    DELETE FROM students WHERE id =?
""", [id]);
    Navigator.of(context).pop();
    showDialogDES("Deleted Success");
  }

  Future<void> _deleteStudents() async {
    _database.rawDelete("DELETE FROM students");
    showDialogDES("Deleted All Students");
  }

//---------------
//Message Success
  void showDialogDES(txt) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("$txt"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }
//--------------------
}
