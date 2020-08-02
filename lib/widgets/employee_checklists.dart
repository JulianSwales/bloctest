import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloctest/bloc/checklist/checklist_bloc.dart';
import 'package:bloctest/screens/employee_checklist_screen.dart';

class EmployeeChecklists extends StatelessWidget {
  EmployeeChecklists({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        if (state is ChecklistsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ChecklistsLoaded) {
          final items = state.checkLists;
          return ListView.builder(
            //key: ArchSampleKeys.todoList,
            padding: const EdgeInsets.all(15.0),
            itemCount: items.length,
            itemBuilder: (BuildContext context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 5.0),
                  ListTile(
                    title: Text(
                      '${items[position].customerSite} - ${items[position].unitNoWithName}',
                      style: TextStyle(
                        fontSize: 18.0,
                        //color: Theme.of(context).,
                      ),
                    ),
                    subtitle: Text(
                      '${items[position].workDate} - ${items[position].id}',
                      style: new TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          EmployeeCheckListScreen.routeName,
                          arguments: items[position].id);
                    },
                  ),
                ],
              );
            },
          );
          //} else {
          //  return Container(key: FlutterTodosKeys.filteredTodosEmptyContainer);
        }
      },
    );
  }
}
