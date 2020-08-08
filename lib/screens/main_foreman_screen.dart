import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloctest/providers/database_client.dart';

import 'package:bloctest/screens/jobsite_notes_screen.dart';

class MainForemanScreen extends StatelessWidget {
  static const routeName = '/foreman';
  //final authService = locator.get<Auth2>();

  //final _currentUser = _getUser();
  @override
  Widget build(BuildContext context) {
    print('In MainForemanScreen');
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Denny Forbes Construction'),
          ),
          body: EmployeeScreen()),
    );
  }
}

class EmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Screen: ForemanScreen');
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
                builder: (context, AsyncSnapshot<String> snapshot) {
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
              child: Text('Daily Notes'),
              onPressed: () {
                Navigator.of(context).pushNamed(JobSiteNotesScreen.routeName);
              },
            ),
            /*RaisedButton(
                            child: Text('Add Checklist'),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AddEmployeeChecklistScreen.routeName);
                            },
                          ),*/
            /*RaisedButton(
                                child: Text('Pay'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(MainPayScreen.routeName);
                                },
                              ),*/
          ],
        ),
        /*Divider(),
                      Row(
                        children: [
                          RaisedButton(
                            child: Text('Employee Check Lists'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(CheckListScreen.routeName);
                            },
                          ),
                          RaisedButton(
                            child: Text('Employee Pay Records'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EmployeePayListScreen.routeName);
                            },
                          ),
                        ],
                      ),*/
        /*Row(
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Run EmployeeCheckList Sync'),
                                onPressed: () {
                                  syncdata.syncEmployeeChecklist();
                                },
                              ),
                            ],
                          ),*/
      ],
    );
  }
}
/*class MainForemanScreen extends StatelessWidget {
  static const routeName = '/foreman';
  //final authService = locator.get<Auth2>();

  //final _currentUser = _getUser();
  @override
  Widget build(BuildContext context) {
    print('In MainForemanScreen');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Denny Forbes Construction'),
        ),
        endDrawer: AppDrawer('Foreman'),
        body: Consumer<SyncData>(
          builder: (ctx, syncdata, _) => FutureBuilder(
            future: syncdata.isInitialSync,
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen('Sync in Progress. Please Wait.')
                    //: CheckListScreen(),
                    : Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder(
                                  future: _getUser(),
                                  builder: (context,
                                      AsyncSnapshot<String> snapshot) {
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
                                child: Text('Daily Notes'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(JobSiteNotesScreen.routeName);
                                },
                              ),
                              /*RaisedButton(
                            child: Text('Add Checklist'),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AddEmployeeChecklistScreen.routeName);
                            },
                          ),*/
                              /*RaisedButton(
                                child: Text('Pay'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(MainPayScreen.routeName);
                                },
                              ),*/
                            ],
                          ),
                          /*Divider(),
                      Row(
                        children: [
                          RaisedButton(
                            child: Text('Employee Check Lists'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(CheckListScreen.routeName);
                            },
                          ),
                          RaisedButton(
                            child: Text('Employee Pay Records'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EmployeePayListScreen.routeName);
                            },
                          ),
                        ],
                      ),*/
                          /*Row(
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Run EmployeeCheckList Sync'),
                                onPressed: () {
                                  syncdata.syncEmployeeChecklist();
                                },
                              ),
                            ],
                          ),*/
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}*/

Future<String> _getUser() async {
  print('Function: _getUser');
  final dennyDb = DatabaseClient.instance;
  final user = await dennyDb.getCurrentUserInfo();
  var userName = '';
  if (user != null) {
    final comma = user.userName.indexOf(',');
    userName = user.userName.substring(0, comma);
  }
  print('user: $userName');
  return userName;
}
