import 'dart:convert';

List<CheckList> checkListFromJson(String str) =>
    List<CheckList>.from(json.decode(str).map((x) => CheckList.fromJson(x)));

String checkListToJson(List<CheckList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckList {
  int id;
  String name;
  bool optional;
  String lastSync;
  String knackId;

  CheckList({
    this.id,
    this.name,
    this.optional,
    this.lastSync,
    this.knackId,
  });

  factory CheckList.fromJson(Map<String, dynamic> data) => CheckList(
        id: data["id"],
        name: data["name"],
        optional: data["optional"] == 1,
        lastSync: data["lastSync"],
        knackId: data["knackId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "optional": optional == true ? 1 : 0,
        "lastSync": lastSync,
        "knackId": knackId,
      };

  Map<String, dynamic> toJsonNoId() => {
        "name": name,
        "optional": optional == true ? 1 : 0,
        "lastSync": lastSync,
        "knackId": knackId,
      };
}
