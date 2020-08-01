
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bloctest/providers/database_client.dart';
import 'package:bloctest/models/safety_record.dart';

class EmployeeCheckListScreen extends StatelessWidget {
  static const routeName = '/employee-checklist-detail';
  var dateformat = new DateFormat('MMM');

  @override
  Widget build(BuildContext context) {
    print('In EmployeeCheckListScreen');
    final id = ModalRoute.of(context).settings.arguments;

    //print('id runtype is: ${id.runtimeType} with value ${id}');

    return Scaffold(
        appBar: AppBar(
          title: Text('Safety Checklist Details'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),

        body: Column(
          children: [
            FutureBuilder(
              future: getData(id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {

                  ///when the future is null
                  case ConnectionState.none:
                    return Text(
                      'Press the button to fetch data',
                      textAlign: TextAlign.center,
                    );

                  case ConnectionState.active:

                  ///when data is being fetched
                  case ConnectionState.waiting:
                    return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
                  case ConnectionState.done:

                    ///task is complete with an error (eg. When you
                    ///are offline)
                    if (snapshot.hasError)
                      return Text(
                        'Error:\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      );

                    ///task is complete with some data
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'JobSite: ${snapshot.data['customerSite']}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                ),
                              ),
                              snapshot.data['type'] == 'Equipment'
                                  ? Text(
                                      'Equipment: ${snapshot.data['unitNoWithName']}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : Text(
                                      'Safety: ${snapshot.data['unitNoWithName']}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                              Text(
                                'Work Date: ${snapshot.data['workDate']}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
            Column(
              children: <Widget>[
                Container(
                  child: FutureBuilder(
                      future: getSafetyData(id),
                      builder: (context, safetysnapshot) {
                        switch (safetysnapshot.connectionState) {

                          ///when the future is null
                          case ConnectionState.none:
                            return Text(
                              'Press the button to fetch data',
                              textAlign: TextAlign.center,
                            );

                          case ConnectionState.active:

                          ///when data is being fetched
                          case ConnectionState.waiting:
                            return CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue));
                          case ConnectionState.done:

                            ///task is complete with an error (eg. When you
                            ///are offline)
                            if (safetysnapshot.hasError)
                              return Text(
                                'Error:\n\n${safetysnapshot.error}',
                                textAlign: TextAlign.center,
                              );
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: safetysnapshot.data.length,
                              padding: const EdgeInsets.all(15.0),
                              itemBuilder: (context, position) {
                                return Column(
                                  children: <Widget>[
                                    Divider(height: 5.0),
                                    ListTile(
                                      leading:
                                          safetysnapshot.data[position].yesno ==
                                                  "Ok"
                                              ? Icon(Icons.check,
                                                  color: Colors.green)
                                              : Icon(Icons.new_releases,
                                                  color: Colors.red),
                                      title: Text(
                                        '${safetysnapshot.data[position].name}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      subtitle: safetysnapshot
                                                  .data[position].yesno ==
                                              "Ok"
                                          ? null
                                          : Text(
                                              '${safetysnapshot.data[position].problemDescription}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              },
                            );
                        }
                      }),
                ),
              ],
            ),
          ],
        ));
  }
}

Future<dynamic> getData(int id) async {
  final dennyDb = DatabaseClient.instance;
  final employeeChecklist = await dennyDb.getEmployeeChecklistInfoById(id);
  print('before Decode');
  print('${employeeChecklist[0]['id']}');
  //final abc = json.decode(employeeChecklist);

  //print('decode: ${abc}');
  print('after Decode');
  return employeeChecklist[0];
}

Future<List<SafetyRecord>> getSafetyData(int id) async {
  final dennyDb = DatabaseClient.instance;
  print('checkListId: ${id}');
  final safetyRecords = await dennyDb.getAllSafetyRecordsByCheckListId(id);

  return safetyRecords;
}
