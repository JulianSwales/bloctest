class User {
  int id;
  String userName;
  String userEmail;
  String userToken;
  String knackId;
  String userTokenExpire;
  String userPassword;
  String userRole;
  int userRoleNum;
  DateTime lastSyncData;

  User(
      {this.id,
      this.userName,
      this.userEmail,
      this.userToken,
      this.knackId,
      this.userTokenExpire,
      this.userPassword,
      this.userRole,
      this.userRoleNum,
      this.lastSyncData});

  factory User.fromJson(Map<String, dynamic> data) => new User(
      id: data["id"],
      userName: data["userName"],
      userEmail: data["userEmail"],
      userToken: data["userToken"],
      knackId: data["knackId"],
      userTokenExpire: data["userTokenExpire"] ,
      userPassword: data["userPassword"],
      userRole: data["userRole"],
      userRoleNum: data["userRoleNum"],
      lastSyncData: data["lastSyncData"] != null ? DateTime.parse(data["lastSyncData"]) : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "userEmail": userEmail,
        "userToken": userToken,
        "knackId": knackId,
        "userTokenExpire": userTokenExpire,
        "userPassword": userPassword,
        "userRole": userRole,
        "userRoleNum": userRoleNum,
        "lastSyncData": lastSyncData != null ? lastSyncData.toIso8601String() : lastSyncData,
      };

  Map<String, dynamic> toJsonNoId() => {
        "userName": userName,
        "userEmail": userEmail,
        "userToken": userToken,
        "knackId": knackId,
        "userTokenExpire": userTokenExpire,
        "userPassword": userPassword,
        "userRole": userRole,
        "userRoleNum": userRoleNum,
        "lastSyncData": lastSyncData != null ? lastSyncData.toIso8601String() : lastSyncData,
      };
}
