import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloctest/screens/splash_screen.dart';

import 'package:bloctest/screens/add_employee_checklist3.dart';

import 'package:bloctest/bloc/checklist/checklist_bloc.dart';

import 'package:bloctest/widgets/employee_checklists.dart';

class CheckListScreen extends StatelessWidget {
  static const routeName = '/check-list';
  ChecklistBloc _blocData;

  @override
  Widget build(BuildContext context) {
    print('Screen: CheckListScreen');
    BlocProvider.of<ChecklistBloc>(context).add(
      LoadChecklists(),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('BlocTest'),
        ),
        floatingActionButton: FloatingActionButton(
          //key: ArchSampleKeys.addTodoFab,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AddEmployeeChecklistScreen.routeName);
          },
          child: Icon(Icons.add),
          //tooltip: ArchSampleLocalizations.of(context).addTodo,
        ),
        body: BlocBuilder<ChecklistBloc, ChecklistState>(
          bloc: _blocData,
          builder: (context, state) {
            print('state: $state');
            if (state is ChecklistsLoaded) {
              //return HomeScreen(name: state.displayName);
              return EmployeeChecklists();
            }
            if (state is ChecklistInitial) {
              return SplashScreen('Checklists Loading');
            }
            if (state is ChecklistsLoading) {
              return SplashScreen('Checklists Loading');
            }
            if (state is ChecklistsLoadFailure) {
              return Text('Error Loading Checklists');
            }
          },
        ),
      ),
    );
  }
}