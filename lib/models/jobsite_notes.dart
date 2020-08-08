import 'dart:convert';

import 'package:equatable/equatable.dart';

List<JobSiteNote> JobSiteNoteFromJson(String str) => List<JobSiteNote>.from(
    json.decode(str).map((x) => JobSiteNote.fromJson(x)));

String JobSiteNoteToJson(List<JobSiteNote> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobSiteNote extends Equatable {
  int id;
  DateTime dateTime;
  String employeeKnackId;
  String dailyNotes;
  int jobSiteId;
  String jobSiteKnackId;
  String lastSync;
  String knackId;

  JobSiteNote({
    this.id,
    this.dateTime,
    this.employeeKnackId,
    this.dailyNotes,
    this.jobSiteId,
    this.jobSiteKnackId,
    this.lastSync,
    this.knackId,
  });

  @override
  List get props => [
        id,
        dateTime,
        employeeKnackId,
        dailyNotes,
        jobSiteId,
        jobSiteKnackId,
        lastSync,
        knackId,
      ];

  factory JobSiteNote.fromJson(Map<String, dynamic> data) => JobSiteNote(
        id: data["id"],
        dateTime: DateTime.parse(data["dateTime"]),
        employeeKnackId: data["employeeKnackId"],
        dailyNotes: data["dailyNotes"],
        jobSiteId: data["jobSiteId"],
        jobSiteKnackId: data["jobSiteKnackId"],
        lastSync: data["lastSync"],
        knackId: data["knackId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateTime": dateTime.toIso8601String(),
        "employeeKnackId": employeeKnackId,
        "dailyNotes": dailyNotes,
        "jobSiteId": jobSiteId,
        "jobSiteKnackId": jobSiteKnackId,
        "lastSync": lastSync,
        "knackId": knackId,
      };

  Map<String, dynamic> toJsonNoId() => {
        "dateTime": dateTime.toIso8601String(),
        "employeeKnackId": employeeKnackId,
        "dailyNotes": dailyNotes,
        "jobSiteId": jobSiteId,
        "jobSiteKnackId": jobSiteKnackId,
        "lastSync": lastSync,
        "knackId": knackId,
      };
}

