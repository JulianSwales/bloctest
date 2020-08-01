import 'dart:async';

import 'package:bloctest/providers/database_client.dart';

class ChecklistRepository {
  final _dennyDb = DatabaseClient.instance;

  @override
  Stream<List<dynamic>> checklists() {
    print('ChecklistRepository: Stream: checklists');
    final res = _dennyDb.getUserAllEmployeeChecklistInfo();
    return Stream.fromFuture(res);
  }

  @override
  Future<void> addNewChecklist (
      int jobSiteValue, int equipmentValue, DateTime dateValue, List list) async {
    await _dennyDb.addEmployeeSafetyRecord(
        jobSiteValue, equipmentValue, dateValue, list);
  }
}
