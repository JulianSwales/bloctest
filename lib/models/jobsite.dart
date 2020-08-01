import 'dart:convert';

List<JobSite> jobSiteFromJson(String str) =>
    List<JobSite>.from(json.decode(str).map((x) => JobSite.fromJson(x)));

String jobSiteToJson(List<JobSite> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobSite {
  int id;
  String jobSiteName;
  String customerSite;
  bool active;
  String lastSync;
  String knackId;
  String fileUrlResponsePlan;
  String localFileNameResponsePlan;
  String fileUrlHospital;
  String localFileNameHospital;
  DateTime lastDocumentSync;

  JobSite({
    this.id,
    this.jobSiteName,
    this.customerSite,
    this.active,
    this.lastSync,
    this.knackId,
    this.fileUrlResponsePlan,
    this.localFileNameResponsePlan,
    this.fileUrlHospital,
    this.localFileNameHospital,
    this.lastDocumentSync,
  });

  String get getCustomerSite => customerSite;

  factory JobSite.fromJson(Map<String, dynamic> data) => JobSite(
        id: data["id"],
        jobSiteName: data["jobSiteName"],
        customerSite: data["customerSite"],
        active: data["active"] == 1,
        lastSync: data["lastSync"],
        knackId: data["knackId"],
        fileUrlResponsePlan: data["fileUrlResponsePlan"],
        localFileNameResponsePlan: data["localFileNameResponsePlan"],
        fileUrlHospital: data["fileUrlHospital"],
        localFileNameHospital: data["localFileNameHospital"],
        lastDocumentSync: data["lastDocumentSync"] != null
            ? DateTime.parse(data["lastDocumentSync"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobSiteName": jobSiteName,
        "customerSite": customerSite,
        "active": active == true ? 1 : 0,
        "lastSync": lastSync,
        "knackId": knackId,
        "fileUrlResponsePlan": fileUrlResponsePlan,
        "localFileNameResponsePlan": localFileNameResponsePlan,
        "fileUrlHospital": fileUrlHospital,
        "localFileNameHospital": localFileNameHospital,
        "lastDocumentSync": lastDocumentSync != null
            ? lastDocumentSync.toIso8601String()
            : lastDocumentSync,
      };

  Map<String, dynamic> toJsonNoId() => {
        "jobSiteName": jobSiteName,
        "customerSite": customerSite,
        "active": active == true ? 1 : 0,
        "lastSync": lastSync,
        "knackId": knackId,
        "fileUrlResponsePlan": fileUrlResponsePlan,
        "localFileNameResponsePlan": localFileNameResponsePlan,
        "fileUrlHospital": fileUrlHospital,
        "localFileNameHospital": localFileNameHospital,
        "lastDocumentSync": lastDocumentSync != null
            ? lastDocumentSync.toIso8601String()
            : lastDocumentSync,
      };
}
