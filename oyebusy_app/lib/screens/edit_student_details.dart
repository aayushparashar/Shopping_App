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
  Map<String, dynamic> details = {
    'name': null,
    'dob': null,
    'college': null,
    'image': null,
  };
  var _image = null;

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
      _image = details['image'];
      appBarText = student.name;
      edit = true;
    } else {
      appBarText = 'Add Student';
    }
    super.didChangeDependencies();
  }

  void getImage() async {

    var _Pickimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = _Pickimage;
      details['image'] = Image.file(_image, fit: BoxFit.cover,);
    });
  }

  void save() {
    bool valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    !edit
        ? Provider.of<StudentList>(context, listen: false).addStudent(
            details['name'],
            details['dob'],
            details['college'],
           _image)
        : Provider.of<StudentList>(context, listen: false).editStudent(
            student.id,
            details['name'],
            details['dob'],
            details['college'],
        _image);
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
  Widget build(BuildContext context) {
    final String studentId = ModalRoute.of(context).settings.arguments;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: save),
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                height: 200,
                width: 200,
                child: Center(
                  child: GridTile(
                    child: details['image'] == null
                        ? Image.asset(
                            'images/student.jpg',
                            fit: BoxFit.cover,
                          )
                        : details['image'],
                    footer: GridTileBar(
                      title: Text(''),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: getImage),
                    ),
                  ),
                ),
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
    );
  }
}
