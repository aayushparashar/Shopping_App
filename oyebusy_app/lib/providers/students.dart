
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
class Student {
  final String id;
  final String name;
  final DateTime DOB;
  final String college;
  final Image image;

  Student(
      {@required this.id,
      @required this.name,
      @required this.DOB,
      @required this.college,
      @required this.image});
}

class StudentList extends ChangeNotifier {
  List<Student> _students = [];
  final String userId;

  StudentList(this.userId);


  List<Student> get students {
    print('Getting students $_students');
    _students.forEach((stud) {
      print(stud);
    });
    return [..._students];
  }

  Future<void> addStudent(
      String name, DateTime DOB, String college, File image) async {
    final Dbref = FirebaseDatabase.instance.reference();
    var pushref = await Dbref.child("students").push();
   await pushref.set({
      'name': name,
      'dob': DOB.toString(),
      'college': college,
    });
    StorageReference reference =
    FirebaseStorage.instance.ref();
    StorageUploadTask uploadTask = reference.child(pushref.key).putFile(image);
    StorageTaskSnapshot snap = await uploadTask.onComplete;

    _students.add(Student(
        id: pushref.key,
        name: name,
        DOB: DOB,
        college: college,
        image: Image.file(
          image,
          fit: BoxFit.cover,
        )));
    notifyListeners();
  }

  void editStudent(
      String id, String name, DateTime DOB, String college, File image) async {
    final Dbref = FirebaseDatabase.instance.reference();
    await Dbref.child("students").child(id).update({
      'name': name,
      'dob': DOB.toString(),
      'college': college,
    });

    int idx = _students.indexWhere((stude) => stude.id == id);

    StorageReference reference =
        FirebaseStorage.instance.ref().child(id);
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot snap = await uploadTask.onComplete;
    _students.removeAt(idx);
    _students.insert(
        idx,
        Student(
            id: id,
            name: name,
            DOB: DOB,
            college: college,
            image: Image.file(
              image,
              fit: BoxFit.cover,
            )));
    notifyListeners();
  }

  Student searchById(String id) {
    return _students.firstWhere((stud) => stud.id == id);
  }

  Future<void> fetchAndSet() async {
    try {
      print('Fetching');
      final Dbref = FirebaseDatabase.instance.reference();
      final extracteddata = await Dbref.child('students').once();
      print('data: ${extracteddata.value}');
//      extracteddata.value
      var map= extracteddata.value;
      List<Student> loaded = [];

     await map.forEach((key, data) async {
        var _image;
        await FirebaseStorage.instance
            .ref()
            .child(key)
            .getDownloadURL()
            .then((onValue) {
          _image = Image.network(onValue, fit: BoxFit.cover);
        }).catchError((error) {
          print(error);
        });
        loaded.add(
          Student(
              id: key,
              name: data['name'],
              DOB: DateTime.parse(data['dob']),
              college: data['college'],
              image: _image,
          ),
        );
      });
      _students = loaded;
    } catch (error) {
      print(error);
    }
  }
}
