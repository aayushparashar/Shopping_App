import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    const url = 'https://oyebusy-7b255.firebaseio.com/students.json';
    final result = await http.post(url,
        body: json.encode({
          'name': name,
          'dob': DOB.toString(),
          'college': college,
        }));
    StorageReference reference =
        FirebaseStorage.instance.ref().child(json.decode(result.body)['name']);
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot snap = await uploadTask.onComplete;

    _students.add(Student(
        id: json.decode(result.body)['name'],
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
    final url = 'https://oyebusy-7b255.firebaseio.com/students/$id.json';
    final result = await http.patch(url,
        body: json.encode({
          'name': name,
          'dob': DOB.toString(),
          'college': college,
        }));
    int idx = _students.indexWhere((stude) => stude.id == id);

    StorageReference reference =
        FirebaseStorage.instance.ref().child(json.decode(result.body)['name']);
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
      const url = 'https://oyebusy-7b255.firebaseio.com/students.json';
      final result = await http.get(url);
      final extracteddata = json.decode(result.body) as Map<String, dynamic>;
      print('data: $extracteddata');

      List<Student> loaded = [];
      extracteddata.forEach((key, data) async {
        var _image;
        await FirebaseStorage.instance
            .ref()
            .child(key)
            .getDownloadURL()
            .then((onValue) {
          print('Image $onValue');
          _image = Image.network(onValue, fit: BoxFit.cover);
          print(_image);
        }).catchError((error) {
          print(error);
        });

        print('$key +  $data');
        loaded.add(
          Student(
              id: key,
              name: data['name'],
              DOB: DateTime.parse(data['dob']),
              college: data['college'],
              image: _image),
        );
        print('loaded:  $loaded');
      });
      _students = loaded;
      print('***students: $_students');
    } catch (error) {
      print(error);
    }
  }
}
