import 'package:flutter/material.dart';

import 'package:bloctest/providers/database_client.dart';

import 'package:bloctest/screens/add_employee_checklist3.dart';

import 'package:bloctest/screens/employee_checklist_screen.dart';

class CheckListScreen extends StatefulWidget {
  static const routeName = '/check-list';
  @override
  _CheckListScreenState createState() => new _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  var _isLoading = false;
  List<dynamic> items = new List();
  final dennyDb = DatabaseClient.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    dennyDb.getUserAllEmployeeChecklistInfo().then((employeeChecklist) {
      setState(() {
        employeeChecklist.forEach((checklist) {
          //items.add(EmployeeCheckList.fromJson(checklist));
          items.add(checklist);
        });
      });
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Checklists'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        //key: ArchSampleKeys.addTodoFab,
        onPressed: () {
          //Navigator.of(context).pushNamed(AddPayScreen.routeName);
          //Navigator.of(context).pushNamed(AddPayScreen.routeName, arguments: items[position]['id']);
          //Map data = {
          //  'id': _employeePayPeriodValue,
          //  'startDate': currPeriodStartDate,
          //  'endDate': currPeriodEndDate
          //};
          Navigator.of(context).pushNamed(AddEmployeeChecklistScreen.routeName);
          //Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
        },
        child: Icon(Icons.add),
        //tooltip: ArchSampleLocalizations.of(context).addTodo,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: items.isEmpty
                  ? Center(
                      child: Text('No Checklists Currently'),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.all(15.0),
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            Divider(height: 5.0),
                            ListTile(
                              title: Text(
                                '${items[position]['customerSite']} - ${items[position]['unitNoWithName']}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  //color: Theme.of(context).,
                                ),
                              ),
                              subtitle: Text(
                                '${items[position]['workDate']} - ${items[position]['id']}',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    EmployeeCheckListScreen.routeName,
                                    arguments: items[position]['id']);
                              },
                            ),
                          ],
                        );
                      }),
            ),
    );
  }
}
