import 'dart:convert';

List<SafetyRecord> jobSiteromJson(String str) => List<SafetyRecord>.from(
    json.decode(str).map((x) => SafetyRecord.fromJson(x)));

String jobSiteToJson(List<SafetyRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SafetyRecord {
  int id;
  String lastSync;
  String knackId;
  String name;
  int employeeChecklistId;
  String employeeChecklistKnackId;
  String problemDescription;
  String yesno;
  bool optional;

  SafetyRecord({
    this.id,
    this.lastSync,
    this.knackId,
    this.name,
    this.employeeChecklistId,
    this.employeeChecklistKnackId,
    this.problemDescription,
    this.yesno,
    this.optional,
  });

  factory SafetyRecord.fromJson(Map<String, dynamic> data) => SafetyRecord(
        id: data["id"],
        lastSync: data["lastSync"],
        knackId: data["knackId"],
        name: data["name"],
        employeeChecklistId: data["employeeChecklistId"],
        employeeChecklistKnackId: data["employeeChecklistKnackId"],
        problemDescription: data["problemDescription"],
        yesno: data["yesno"],
        optional: data["optional"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastSync": lastSync,
        "knackId": knackId,
        "name": name,
        "employeeChecklistId": employeeChecklistId,
        "employeeChecklistKnackId": employeeChecklistKnackId,
        "problemDescription": problemDescription,
        "yesno": yesno,
        "optional": optional == true ? 1 : 0,
      };

  Map<String, dynamic> toJsonNoId() => {
        "lastSync": lastSync,
        "knackId": knackId,
        "name": name,
        "employeeChecklistId": employeeChecklistId,
        "employeeChecklistKnackId": employeeChecklistKnackId,
        "problemDescription": problemDescription,
        "yesno": yesno,
        "optional": optional == true ? 1 : 0,
      };
}
