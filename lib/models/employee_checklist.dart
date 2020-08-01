import 'dart:convert';

List<EmployeeCheckList> jobSiteromJson(String str) =>
    List<EmployeeCheckList>.from(
        json.decode(str).map((x) => EmployeeCheckList.fromJson(x)));

String jobSiteToJson(List<EmployeeCheckList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeCheckList {
  int id;
  String lastSync;
  String knackId;
  int jobSiteId;
  String jobSiteKnackId;
  String type;
  int equipmentId;
  String equipmentKnackId;
  String employeeKnackId;
  DateTime workDate;
  String recordCreatedDate;
  bool recordComplete;
  bool approved;
  String approvedby;
  String approvedDate;
  int safetyRecordsExpected;

  EmployeeCheckList({
    this.id,
    this.lastSync,
    this.knackId,
    this.jobSiteId,
    this.jobSiteKnackId,
    this.type,
    this.equipmentId,
    this.equipmentKnackId,
    this.employeeKnackId,
    this.workDate,
    this.recordCreatedDate,
    this.recordComplete,
    this.approved,
    this.approvedby,
    this.approvedDate,
    this.safetyRecordsExpected,
  });

  factory EmployeeCheckList.fromJson(Map<String, dynamic> data) =>
      EmployeeCheckList(
        id: data["id"],
        lastSync: data["lastSync"],
        knackId: data["knackId"],
        jobSiteId: data["jobSiteId"],
        jobSiteKnackId: data["jobSiteKnackId"],
        type: data["type"],
        equipmentId: data["equipmentId"],
        equipmentKnackId: data["equipmentKnackId"],
        employeeKnackId: data["employeeKnackId"],
        workDate: DateTime.parse(data["workDate"]),
        recordCreatedDate: data["recordCreatedDate"],
        recordComplete: data["recordComplete"] == 1,
        approved: data["approved"] == 1,
        approvedby: data["approvedby"],
        approvedDate: data["approvedDate"],
        safetyRecordsExpected: data["safetyRecordsExpected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastSync": lastSync,
        "knackId": knackId,
        "jobSiteId": jobSiteId,
        "jobSiteKnackId": jobSiteKnackId,
        "type": type,
        "equipmentId": equipmentId,
        "equipmentKnackId": equipmentKnackId,
        "employeeKnackId": employeeKnackId,
        "workDate": workDate.toIso8601String(),
        "recordCreatedDate": recordCreatedDate,
        "recordComplete": recordComplete == true ? 1 : 0,
        "approved": approved == true ? 1 : 0,
        "approvedby": approvedby,
        "approvedDate": approvedDate,
        "safetyRecordsExpected": safetyRecordsExpected,
      };

  Map<String, dynamic> toJsonNoId() => {
        "lastSync": lastSync,
        "knackId": knackId,
        "jobSiteId": jobSiteId,
        "jobSiteKnackId": jobSiteKnackId,
        "type": type,
        "equipmentId": equipmentId,
        "equipmentKnackId": equipmentKnackId,
        "employeeKnackId": employeeKnackId,
        "workDate": workDate.toIso8601String(),
        "recordCreatedDate": recordCreatedDate,
        "recordComplete": recordComplete == true ? 1 : 0,
        "approved": approved == true ? 1 : 0,
        "approvedby": approvedby,
        "approvedDate": approvedDate,
        "safetyRecordsExpected": safetyRecordsExpected,
      };
}
