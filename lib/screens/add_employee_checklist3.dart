import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:bloctest/bloc/checklist/checklist_bloc.dart';

import 'package:bloctest/providers/database_client.dart';

import 'package:bloctest/widgets/datePicker.dart';

class AddEmployeeChecklistScreen extends StatefulWidget {
  static const routeName = '/add-employee-checklist';
  @override
  State<StatefulWidget> createState() {
    return _AddEmployeeChecklistScreenState();
  }
}

class _AddEmployeeChecklistScreenState
    extends State<AddEmployeeChecklistScreen> {
  final dennyDb = DatabaseClient.instance;
  int jobSiteValue;
  int equipmentValue;
  String typeValue;
  int prevequipmentValue;
  bool haveEquipment = false;
  bool haveType = false;
  DateTime dateValue = DateTime.now();
  List showProblem = [];

  List<ListItem<dynamic>> list;

  Future<List<dynamic>> _getEquipData(int equipmentValue) async {
    if (prevequipmentValue == equipmentValue) {
      return list;
    }
    list = [];
    final data = await dennyDb.getEquipmentCheckLists(equipmentValue);


    data.forEach((f) {
      print('f.id is: ${f.id}');
      list.add(ListItem<dynamic>(f));
    });
    prevequipmentValue = equipmentValue;

    return list;
  }

  void _submitPressed() {
    print('Submit');
    var invaliddata = false;

    if (jobSiteValue == null) {
      return;
    }

    if (equipmentValue == null) {
      return;
    }

    list.takeWhile((_) => !invaliddata).forEach((f) {
      print('optional: ${f.data.optional}');
      if (f.optionSelected == null && !invaliddata && !f.data.optional) {
        print('First Invalid data');
        invaliddata = true;
        setState(() {
          f.error = true;
        });
      }
      if (f.isSelected == true &&
          (f.repairData == "" || f.repairData == null)) {
        print('second invalid data');
        invaliddata = true;
        setState(() {
          f.error = true;
        });
      }
      print(
          'option: ${f.optionSelected} repair: ${f.repairData} selected: ${f.isSelected} invaliddata: ${invaliddata}');
    });
    if (!invaliddata) {
      print('Now Adding Records');
      print('jobSiteValue: ${jobSiteValue}');
      BlocProvider.of<ChecklistBloc>(context).add(AddChecklist(jobSiteValue, equipmentValue, dateValue, list));
      Navigator.pop(context);
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Checklist'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<List<dynamic>>(
              future: dennyDb.getDropDownJobSiteInfo(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<dynamic>(
                  value: jobSiteValue,
                  hint: Text('Choose JobSite'),
                  isExpanded: true,
                  onChanged: (value) {
                    print(
                        'selected value is: ${value} jobSiteValue is: ${jobSiteValue}');
                    setState(() {
                      jobSiteValue = value;
                    });
                  },
                  items: snapshot.data
                      .map((jobsite) => DropdownMenuItem<dynamic>(
                            child: Text(jobsite['customerSite']),
                            value: jobsite['id'],
                          ))
                      .toList(),
                );
              },
            ),
            jobSiteValue != null
                ? DropdownButton<String>(
                    value: typeValue,
                    onChanged: (value) {
                      print(
                          'selected value is: ${value} typeValue is: ${typeValue}');
                      setState(() {
                        typeValue = value;
                        haveType = true;
                      });
                      print(
                          'selected value is: ${value} typeValue is: ${typeValue}');
                    },
                    items: <String>['Operator', 'NonOperator']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                : Container(),
            haveType
                ? FutureBuilder<List<dynamic>>(
                    future: dennyDb.getDropDownEquipmentInfoByType(typeValue),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return DropdownButton<dynamic>(
                        value: equipmentValue,
                        hint: typeValue == 'Operator'
                            ? Text('Choose Equipment')
                            : Text('Choose Safety'),
                        onChanged: (value) {
                          print(
                              'selected value is: ${value} equipmentValue is: ${equipmentValue}');
                          setState(() {
                            equipmentValue = value;
                            haveEquipment = true;
                          });
                        },
                        items: snapshot.data
                            .map((equipment) => DropdownMenuItem<dynamic>(
                                  child: Text(equipment['unitNoWithName']),
                                  value: equipment['id'],
                                ))
                            .toList(),
                      );
                    },
                  )
                : Text(''),
            haveType
                ? JSDateTimePicker(
                    selectedDate: dateValue,
                    selectDate: _test,
                  )
                : Text(''),
            haveEquipment
                ? Expanded(
                    child: FutureBuilder<List<dynamic>>(
                        //future: dennyDb.getEquipmentCheckLists(equipmentValue),
                        future: _getEquipData(equipmentValue),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          //print('snapshot.data: ${snapshot.data}');
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(snapshot.data[index].data.name,
                                          style: TextStyle(
                                              color: snapshot.data[index].error
                                                  ? Theme.of(context).errorColor
                                                  : null)),
                                    ],
                                  ),
                                  RadioButtonGroup(
                                    orientation:
                                        GroupedButtonsOrientation.HORIZONTAL,

                                    onSelected: (String selected) {
                                      //_handleButtonTap(index, selected,
                                      //snapshot.data[index].data.id);
                                      snapshot.data[index].optionSelected =
                                          selected;
                                      snapshot.data[index].error = false;
                                      setState(() {
                                        print(
                                            'In set state with selected: ${selected} and id: ${snapshot.data[index].data.id}');
                                        if (selected == 'Ok') {
                                          snapshot.data[index].isSelected =
                                              false;

                                          snapshot.data[index].repairData = '';
                                        } else {
                                          snapshot.data[index].isSelected =
                                              true;
                                        }
                                      });
                                    },
                                    //radioItem[index] = selected;
                                    //print('${selected} index: ${index}');},
                                    labels: <String>["Ok", "Repair"],
                                    itemBuilder: (Radio rb, Text txt, int i) {
                                      return Row(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[rb, txt],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  snapshot.data[index].isSelected
                                      ? TextField(
                                          //autofocus: true,
                                          onChanged: (String str) {
                                            print(
                                                'in TextField for index: ${index} with value: ${str}');
                                            snapshot.data[index].repairData =
                                                str;
                                          },
                                        )
                                      : Text(''),
                                ],
                              );
                            },
                          );
                        }),
                  )
                : Text(''),
            RaisedButton(
              child: Text('Submit'),
              onPressed: _submitPressed,
            )
          ],
        ),
      ),
    );
  }

  void _test(DateTime abc) {
    print('picked value is: ${abc}');
    setState(() {
      dateValue = abc;
    });
    //dateValue = abc;
//selectedDate = abc;
  }
}

class ListItem<T> {
  bool isSelected = false;
  bool error = false;
  //bool texterror = false;
  String optionSelected = null;
  String repairData;
  T data;
  ListItem(this.data);
}
