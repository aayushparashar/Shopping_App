import 'package:flutter/material.dart';
import 'package:oyebusyapp/providers/auth.dart';
import 'package:oyebusyapp/providers/students.dart';
import 'package:oyebusyapp/screens/edit_student_details.dart';
import 'package:oyebusyapp/widgets/student_item.dart';
import 'package:provider/provider.dart';

class StudentListScreen extends StatelessWidget {
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
        body: FutureBuilder(
          future:
              Provider.of<StudentList>(context, listen: false).fetchAndSet(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () {
                      return Provider.of<StudentList>(context, listen: false)
                          .fetchAndSet();
                    },
                    child: Consumer<StudentList>(
                      builder: (context, student, child) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      ),
                    ));
          },
        ));
  }
}
