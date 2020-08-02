import 'package:flutter/material.dart';

import 'package:bloctest/providers/database_client.dart';

import 'package:bloctest/screens/splash_screen.dart';
import 'package:bloctest/screens/checklist_screen2.dart';
import 'package:bloctest/screens/add_employee_checklist3.dart';

class MainUserScreen extends StatelessWidget {
  static const routeName = '/employee';
  //final authService = locator.get<Auth2>();

  //final _currentUser = _getUser();

  @override
  Widget build(BuildContext context) {
    print('In MainUserScreen');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bloc Test'),
        ),
        body: EmployeeScreen(),
      ),
    );
  }
}

class EmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Screen: EmployeeScreen');
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: _getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Text('Welcome ${snapshot.data}'),
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
            //Text('Welcome ${_currentUser}'),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Checklists'),
              onPressed: () {
                Navigator.of(context).pushNamed(CheckListScreen.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }
}

Future<String> _getUser() async {
  print('Function: _getUser');
  final dennyDb = DatabaseClient.instance;
  final user = await dennyDb.getCurrentUserInfo();
  var userName = 'Unknown';
  if (user != null) {
    final comma = user.userName.indexOf(',');
    userName = user.userName.substring(0, comma);
  }
  print('user: $userName');
  return userName;
}
