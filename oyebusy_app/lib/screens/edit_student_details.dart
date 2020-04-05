import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/students.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class EditStudentScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditState();
  }
}

class _EditState extends State<EditStudentScreen> {
  Student student;
  String appBarText;
  bool edit = false;
  bool _imgUploading = false;
  Map<String, dynamic> details = {
    'name': null,
    'dob': null,
    'college': null,
    'image': null,
  };
  File _image = null;
  ImageProvider _bimg = AssetImage('images/student.jpg');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final studentId = ModalRoute.of(context).settings.arguments;
    if (studentId != null) {
      student = Provider.of<StudentList>(context, listen: false)
          .searchById(studentId);
      details['name'] = student.name;
      details['dob'] = student.DOB;
      details['college'] = student.college;
      details['image'] = student.image;
      _bimg = (details['image'] as Image).image;
      appBarText = student.name;
      edit = true;
    } else {
      appBarText = 'Add Student';
    }
    super.didChangeDependencies();
  }

  ImageSource source;

  Future<void> getImage() async {
    var _pickImage =
        await ImagePicker.pickImage(source: this.source, imageQuality: 25);
    setState(() {
      _image = _pickImage;
      _bimg = FileImage(_image);
      details['image'] = Image.file(
        _image,
        fit: BoxFit.cover,
      );
    });
  }

  Future<void> save() async {
    bool valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _imgUploading = true;
    });
    !edit
        ? await Provider.of<StudentList>(context, listen: false).addStudent(
            details['name'], details['dob'], details['college'], _image)
        : await Provider.of<StudentList>(context, listen: false).editStudent(
            student.id,
            details['name'],
            details['dob'],
            details['college'],
            _image,
          );
    setState(() {
      _imgUploading = false;
    });
    Navigator.pop(context);
  }

  Widget dobSelector() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
                'Selected Date: ${details['dob'] == null ? 'No Date Chosen' : DateFormat.yMMMd().format(details['dob'])}')),
        FlatButton(
          textColor: Theme.of(context).primaryColorDark,
          child: Text('Choose a Date!'),
          onPressed: () => openDatePicker(context),
        )
      ],
    );
  }

  void openDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        details['dob'] = date;
      });
    });
  }

  var _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext ctx) {
    final String studentId = ModalRoute.of(context).settings.arguments;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: save),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: _imgUploading ? CircularProgressIndicator() : null,
                      radius: 50,
                      backgroundImage: _bimg,
                    ),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                            ),
                                            onPressed: () async {
                                              source = ImageSource.camera;
                                              await getImage();
                                              Navigator.of(ctx).pop();
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.image,
                                              size: 50,
                                            ),
                                            onPressed: () async {
                                              source = ImageSource.gallery;
                                              await getImage();
                                              Navigator.of(ctx).pop();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                        })
                  ],
                ),
                TextFormField(
                  initialValue: details['name'] == null ? '' : details['name'],
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter Name of the Student',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    details['name'] = value;
                  },
                ),
                TextFormField(
                  initialValue:
                      details['college'] == null ? '' : details['college'],
                  decoration: InputDecoration(
                    labelText: 'College',
                    hintText: 'Enter College Name of the Student',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'College cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    details['college'] = value;
                  },
                ),
                dobSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
