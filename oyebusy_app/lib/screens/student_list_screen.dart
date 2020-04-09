import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/auth.dart';
import 'package:oyebusyapp/providers/students.dart';
import 'package:oyebusyapp/screens/edit_student_details.dart';
import 'package:oyebusyapp/widgets/location_detector.dart';
import 'package:oyebusyapp/widgets/student_item.dart';
import 'package:provider/provider.dart';

class StudentListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StudentState();
  }
}

class StudentState extends State<StudentListScreen> {
  int _curridx = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 200,
                color: Theme.of(context).primaryColor,
                child: Image.asset('images/logo.png'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Log Out'),
                onTap: () {
                  Provider.of<Authenticate>(context, listen: false).logout();
                },
              ),
              Divider(),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Student List'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditStudentScreen.routeName, arguments: null);
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            LocationWidget(),
            FutureBuilder(
              future: Provider.of<StudentList>(context, listen: false)
                  .fetchAndSet(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ))
                    : RefreshIndicator(
                        color: Theme.of(context).primaryColor,
                        onRefresh: () {
                          return Provider.of<StudentList>(context,
                                  listen: false)
                              .fetchAndSet();
                        },
                        child: Consumer<StudentList>(
                            builder: (context, student, child) =>
                                Container(
                                    height: MediaQuery.of(context).size.height*0.7,
                                    child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
//                    maxCrossAxisExtent: 3,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 1 / 1,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemBuilder: (ctx, i) =>
                                      StudentItem(student.students[i]),
                                  itemCount: student.students.length,
                                  padding: EdgeInsets.all(10),
                                ))));
              },
            )
          ],
        ));
  }
}
