import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/students.dart';
import '../screens/edit_student_details.dart';

class StudentItem extends StatelessWidget {
  final Student _student;

  StudentItem(this._student);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: _student.image,
        footer: GridTileBar(
          title: Text(_student.name),
          subtitle: Text(_student.college),
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditStudentScreen.routeName,
                  arguments: _student.id);
            },
            icon: Icon(Icons.edit),
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
