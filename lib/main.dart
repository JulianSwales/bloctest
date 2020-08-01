import 'package:bloctest/providers/database_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloctest/screens/main_user_screen.dart';
import 'package:bloctest/screens/splash_screen.dart';
import 'package:bloctest/screens/employee_checklist_screen.dart';
import 'package:bloctest/screens/checklist_screen.dart';
import 'package:bloctest/screens/add_employee_checklist3.dart';

import 'package:bloctest/bloc/checklist/checklist_bloc.dart';

import 'package:bloctest/class/simple_bloc_delegate.dart';

import 'package:bloctest/class/checklist_repository.dart';

void main() {
  final checklistRepository = ChecklistRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ChecklistBloc>(
          create: (context) =>
              ChecklistBloc(checklistRepository: checklistRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final db = DatabaseClient.instance;

  @override
  Widget build(BuildContext context) {
    db.queryAllUsers();
    return MaterialApp(
      title: 'Bloc Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlueAccent,
        fontFamily: 'Lato',
      ),
      home: MainUserScreen(),
      routes: {
        MainUserScreen.routeName: (ctx) => MainUserScreen(),
        EmployeeCheckListScreen.routeName: (ctx) => EmployeeCheckListScreen(),
        CheckListScreen.routeName: (ctx) => CheckListScreen(),
        AddEmployeeChecklistScreen.routeName: (ctx) =>
            AddEmployeeChecklistScreen(),
      },
    );
  }
}
