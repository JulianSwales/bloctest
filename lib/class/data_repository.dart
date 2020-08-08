import 'dart:async';

import 'package:bloctest/models/jobsite.dart';
import 'package:bloctest/models/jobsite_notes.dart';

import 'package:bloctest/providers/database_client.dart';

class DataRepository {
  final _dennyDb = DatabaseClient.instance;

  Future<void> addJobSiteDailyNote(
    int jobSiteId,
    String dailyNote,
  ) async {
    await _dennyDb.addJobSiteDailyNote(
      jobSiteId,
      dailyNote,
    );
  }

  Future<List<JobSite>> getAllJobSites() async {
    print('DataRepository: Stream: getAllActiveJobSites');
    final res = await _dennyDb.getAllActiveJobSites();
    return res;
  }

  Future<List<JobSiteNote>> getAllNotesForJobSites(int jobSiteId) async {
    print('DataRepository: Stream: getAllNotesForJobSites');
    final res = await _dennyDb.getJobSiteNotesData(jobSiteId);
    return res;
  }
}
