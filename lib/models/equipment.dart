import 'dart:convert';

List<Equipment> EquipmentFromJson(String str) =>
    List<Equipment>.from(json.decode(str).map((x) => Equipment.fromJson(x)));

String EquipmentToJson(List<Equipment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Equipment {
  int id;
  String type;
  String equipmentName;
  String unitNoWithName;
  String lastSync;
  String knackId;
  String checkListKnackIds;
  int safetyRecordsExpected;

  Equipment({
    this.id,
    this.type,
    this.equipmentName,
    this.unitNoWithName,
    this.lastSync,
    this.knackId,
    this.checkListKnackIds,
    this.safetyRecordsExpected,
  });

  factory Equipment.fromJson(Map<String, dynamic> data) => Equipment(
        id: data["id"],
        type: data["type"],
        equipmentName: data["equipmentName"],
        unitNoWithName: data["unitNoWithName"],
        lastSync: data["lastSync"],
        knackId: data["knackId"],
        checkListKnackIds: data["checkListKnackIds"],
        safetyRecordsExpected: data["safetyRecordsExpected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "equipmentName": equipmentName,
        "unitNoWithName": unitNoWithName,
        "lastSync": lastSync,
        "knackId": knackId,
        "checkListKnackIds": checkListKnackIds,
        "safetyRecordsExpected": safetyRecordsExpected,
      };

      Map<String, dynamic> toJsonNoId() => {
        "type": type,
        "equipmentName": equipmentName,
        "unitNoWithName": unitNoWithName,
        "lastSync": lastSync,
        "knackId": knackId,
        "checkListKnackIds": checkListKnackIds,
        "safetyRecordsExpected": safetyRecordsExpected,
      };
}
