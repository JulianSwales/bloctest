import 'dart:async';
import 'dart:io';

import 'package:bloctest/models/employee_checklist_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloctest/models/user.dart';
import 'package:bloctest/models/jobsite.dart';
import 'package:bloctest/models/checklist.dart';
import 'package:bloctest/models/equipment.dart';
import 'package:bloctest/models/safety_record.dart';
import 'package:bloctest/models/employee_checklist.dart';

class DatabaseClient {
  static final _databaseName = "BlocTest.db";
  static final _databaseVersion = 1;

  final initialScript = [
    '''
create table _user (
  id integer primary key autoincrement,
  userEmail text not null unique,
  userName text,
  userToken text,
  userTokenExpire text,
  knackId text,
  userPassword text,
  userRole,
  userRoleNum,
  lastSyncData
  )
''',
    '''
create table _job_site (
  id integer primary key autoincrement,
  knackId text not null,
  jobSiteName text not null,
  customerSite text not null,
  active integer not null,
  fileURLResponsePlan text,
  localFileNameResponsePlan text,
  fileURLHospital text,
  localFileNameHospital text,
  lastSync text,
  lastDocumentSync text
)
''',
    '''
create table _checklist (
  id integer primary key autoincrement,
  knackId text not null,
  name text not null,
  optional integer not null,
  lastSync text
)
''',
    '''
create table _equipment (
  id integer primary key autoincrement,
  knackId text not null,
  type text not null,
  equipmentName text not null,
  unitNoWithName text not null,
  checkListKnackIds text,
  lastSync text,
  safetyRecordsExpected integer not null
)
''',
    '''
create table _employee_checklist (
  id integer primary key autoincrement,
  knackId text,
  jobSiteId integer not null,
  jobSiteKnackId text,
  type text not null,
  equipmentId integer not null,
  equipmentKnackId text,
  workDate text not null,
  employeeKnackId text,
  recordCreatedDate text not null,
  recordComplete integer,
  approved integer,
  approvedBy text,
  approvedDate text,
  lastSync text,
  safetyRecordsExpected integer,
  CONSTRAINT fk_jobSite
    FOREIGN KEY (jobSiteId)
    REFERENCES _job_site(id),
  CONSTRAINT fk_equipment
    FOREIGN KEY (equipmentId)
    REFERENCES _equipment(id)
)
''',
    '''
create table _safety_record (
  id integer primary key autoincrement,
  knackId text,
  name text not null,
  yesno text not null,
  problemDescription text,
  employeeChecklistId integer not null,
  employeeChecklistKnackId text,
  optional integer not null,
  lastSync text,
  CONSTRAINT fk_employeeChecklist
    FOREIGN KEY (employeeChecklistId)
    REFERENCES _employee_checklist(id)
)
''',
  ];

  final migrationsScript = [];
//  final migrationsScript = [
//    '''
//  alter table _task add column done integer default 0;
//  '''
//  ];

  // make this a singleton class
  DatabaseClient._privateConstructor();
  static final DatabaseClient instance = DatabaseClient._privateConstructor();

// only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    initialScript.forEach(
      (script) async => await db.execute(script),
    );
    await _createData();
  }

  Future _createData() async {
    var user = User();
    user.knackId = 'AAAAAA';
    user.userEmail = 'test@abc.com';
    user.userRoleNum = 1;
    user.userName = 'First, Last';
    createUser(user);

    var equipment = Equipment();
    equipment.knackId = 'EQUIPA';
    equipment.unitNoWithName = '1 - Equipment A';
    equipment.type = 'Equipment';
    equipment.equipmentName = 'Equipment A';
    equipment.safetyRecordsExpected = 3;
    equipment.checkListKnackIds = 'CHECKA;CHECKB;CHECKC';
    createEquipment(equipment);

    equipment = Equipment();
    equipment.knackId = 'EQUIPB';
    equipment.unitNoWithName = '2 - Equipment B';
    equipment.type = 'Equipment';
    equipment.equipmentName = 'Equipment B';
    equipment.safetyRecordsExpected = 3;
    equipment.checkListKnackIds = 'CHECKA;CHECKB;CHECKC';
    createEquipment(equipment);

    var jobSite = JobSite();
    jobSite.knackId = 'JOBSITEA';
    jobSite.jobSiteName = 'Job Site A';
    jobSite.customerSite = 'Customer A';
    jobSite.active = true;
    createJobSite(jobSite);

    jobSite = JobSite();
    jobSite.knackId = 'JOBSITEB';
    jobSite.jobSiteName = 'Job Site B';
    jobSite.customerSite = 'Customer B';
    jobSite.active = true;
    createJobSite(jobSite);

    var checkList = CheckList();
    checkList.knackId = 'CHECKA';
    checkList.optional = false;
    checkList.name = 'CheckList Item A';
    createCheckList(checkList);

    checkList = CheckList();
    checkList.knackId = 'CHECKB';
    checkList.optional = false;
    checkList.name = 'CheckList Item B';
    createCheckList(checkList);

    checkList = CheckList();
    checkList.knackId = 'CHECKC';
    checkList.optional = false;
    checkList.name = 'CheckList Item C';
    createCheckList(checkList);

    var employeeChecklist = EmployeeCheckList();
    employeeChecklist.knackId = 'EMPCHECKA';
    employeeChecklist.recordCreatedDate = DateTime.now().toIso8601String();
    employeeChecklist.employeeKnackId = 'AAAAAA';
    employeeChecklist.equipmentId = 1;
    employeeChecklist.equipmentKnackId = 'EQUIPA';
    employeeChecklist.type = 'Equipment';
    employeeChecklist.jobSiteKnackId = 'JOBSITEA';
    employeeChecklist.jobSiteId = 1;
    employeeChecklist.workDate = DateTime.now();
    createEmployeeChecklist(employeeChecklist);

    employeeChecklist = EmployeeCheckList();
    employeeChecklist.knackId = 'EMPCHECKB';
    employeeChecklist.recordCreatedDate = DateTime.now().toIso8601String();
    employeeChecklist.employeeKnackId = 'AAAAAA';
    employeeChecklist.equipmentId = 2;
    employeeChecklist.equipmentKnackId = 'EQUIPB';
    employeeChecklist.type = 'Equipment';
    employeeChecklist.jobSiteKnackId = 'JOBSITEB';
    employeeChecklist.jobSiteId = 1;
    employeeChecklist.workDate = DateTime.now();
    createEmployeeChecklist(employeeChecklist);

    var safetyRecord = SafetyRecord();
    safetyRecord.knackId = 'SAFEA1';
    safetyRecord.name = 'Safe Rec 1';
    safetyRecord.optional = false;
    safetyRecord.yesno = 'No';
    safetyRecord.employeeChecklistId = 1;
    safetyRecord.employeeChecklistKnackId = 'EMPCHECKA';
    createSafetyRecord(safetyRecord);

    safetyRecord = SafetyRecord();
    safetyRecord.knackId = 'SAFEA2';
    safetyRecord.name = 'Safe Rec 2';
    safetyRecord.optional = false;
    safetyRecord.yesno = 'No';
    safetyRecord.employeeChecklistId = 1;
    safetyRecord.employeeChecklistKnackId = 'EMPCHECKA';
    createSafetyRecord(safetyRecord);

    safetyRecord = SafetyRecord();
    safetyRecord.knackId = 'SAFEA3';
    safetyRecord.name = 'Safe Rec 3';
    safetyRecord.optional = false;
    safetyRecord.yesno = 'No';
    safetyRecord.employeeChecklistId = 1;
    safetyRecord.employeeChecklistKnackId = 'EMPCHECKA';
    createSafetyRecord(safetyRecord);

    safetyRecord = SafetyRecord();
    safetyRecord.knackId = 'SAFEB1';
    safetyRecord.name = 'Safe Rec 1';
    safetyRecord.optional = false;
    safetyRecord.yesno = 'No';
    safetyRecord.employeeChecklistId = 2;
    safetyRecord.employeeChecklistKnackId = 'EMPCHECKB';
    createSafetyRecord(safetyRecord);

    safetyRecord = SafetyRecord();
    safetyRecord.knackId = 'SAFEB2';
    safetyRecord.name = 'Safe Rec 2';
    safetyRecord.optional = false;
    safetyRecord.yesno = 'No';
    safetyRecord.employeeChecklistId = 2;
    safetyRecord.employeeChecklistKnackId = 'EMPCHECKB';
    createSafetyRecord(safetyRecord);

    safetyRecord = SafetyRecord();
    safetyRecord.knackId = 'SAFEB3';
    safetyRecord.name = 'Safe Rec 3';
    safetyRecord.optional = false;
    safetyRecord.yesno = 'No';
    safetyRecord.employeeChecklistId = 2;
    safetyRecord.employeeChecklistKnackId = 'EMPCHECKB';
    createSafetyRecord(safetyRecord);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', user.userEmail);
  }

// SQL code to upgrade the database table
  Future _onUpgrade(Database db, int prevVersion, int newVersion) async {
    migrationsScript.forEach(
      (script) async => await db.execute(script),
    );
  }

  // Database Table Access Methods
  //Future<List<Map<String, dynamic>>> queryUser(String userEmail) async {
  //  Database db = await instance.database;
  //int id = row['userEmail'];
  //  return await db.query('_user', where: 'userEmail = ?', whereArgs: [userEmail]);
  //}
  Future<List<Map>> queryAllUsers() async {
    print('In queryAllUsers');
    Database db = await instance.database;
    List<Map> results = await db.query('_user');
    print(results);
    return results;
  }

  Future<User> queryUser(String userEmail) async {
    print('queryUser: userEmail: $userEmail');
    Database db = await instance.database;
    List<Map> results =
        await db.query('_user', where: 'userEmail = ?', whereArgs: [userEmail]);
    print('results: ${results}');
    if (results.length > 0) {
      print('found User: ${results.first}');
      return new User.fromJson(results.first);
    }
    print('No User found');
    return null;
  }

  // Database Table Access Methods
  Future<int> createUser(User user) async {
    print('In createUser: with user: ${user}');
    Database db = await instance.database;
    //new row = User.toJson(user);
    //int id = row['userEmail'];
    return await db.insert('_user', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update User Records
  Future<int> updateUser(User user) async {
    print(
        'In updateUser with User email: ${user.userEmail} token: ${user.userToken}');
    final isuser = await queryUser(user.userEmail);
    print('isuser: $isuser');
    if (isuser != null) {
      Database db = await instance.database;
      return await db.update('_user', user.toJsonNoId(),
          where: 'knackId = ?', whereArgs: [user.knackId]);
    } else {
      return await createUser(user);
    }
  }

  // Database Table Access Methods

  // Create JobSite Records
  createJobSite(JobSite jobSite) async {
    print('In createJobSite: with jobSite: ${jobSite}');
    Database db = await instance.database;
    try {
      return await db.insert('_job_site', jobSite.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (e) {
      print('native_error: $e');
    }
  }

  // Query JobSite Records
  Future<List<JobSite>> getAllJobSites() async {
    final db = await instance.database;
    final res = await db.query('_job_site');
    print('getAllJobSites res: ${res}');
    List<JobSite> list =
        res.isNotEmpty ? res.map((c) => JobSite.fromJson(c)).toList() : [];
    return list;
  }

  // Query Active JobSite Records
  Future<List<JobSite>> getAllActiveJobSites() async {
    final db = await instance.database;
    final res =
        await db.query('_job_site', where: 'active = ?', whereArgs: [1]);
    print('getAllJobSites res: ${res}');
    List<JobSite> list =
        res.isNotEmpty ? res.map((c) => JobSite.fromJson(c)).toList() : [];
    return list;
  }

// Query JobSite Records by KnackId
  Future<JobSite> queryJobSiteByKnackId(String knackId) async {
    print('In queryJobSiteByKnackId: with id: ${knackId}');
    Database db = await instance.database;
    List<Map> results =
        await db.query('_job_site', where: 'knackId = ?', whereArgs: [knackId]);
    if (results.length > 0) {
      print('found JobSite: ${results.first}');
      return new JobSite.fromJson(results.first);
    }
    print('No JobSite found');
    return null;
  }

// Query JobSite Records by KnackId
  Future<JobSite> queryJobSiteById(int id) async {
    print('In queryJobSiteByKnackId: with id: ${id}');
    Database db = await instance.database;
    List<Map> results =
        await db.query('_job_site', where: 'id = ?', whereArgs: [id]);
    if (results.length > 0) {
      print('found JobSite: ${results.first}');
      return new JobSite.fromJson(results.first);
    }
    print('No JobSite found');
    return null;
  }

  Future<dynamic> getJobSiteManuals() async {
    final db = await instance.database;
    final res = await db.rawQuery(
        'SELECT id, customerSite, jobSiteName, localFileNameResponsePlan, localFileNameHospital from _job_site where active = 1');
    //final res = await db.rawQuery(
    //'SELECT heading, type, description, localFileName from _company_manuals');
    print('${res}');
    return res;
  }

// Update JobSite Records
  updateJobSite(JobSite jobSite) async {
    print('In update JobSite: with JobSite: ${jobSite}');
    Database db = await instance.database;
    return await db.update('_job_site', jobSite.toJsonNoId(),
        where: 'knackId = ?', whereArgs: [jobSite.knackId]);
  }

  returnJobSite(data) {
    return JobSite.fromJson(data);
  }

// CheckList Database Functions
// Create CheckList Record
  createCheckList(CheckList checkList) async {
    print('In createCheckList: with checklist: ${checkList}');
    Database db = await instance.database;
    return await db.insert('_checklist', checkList.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update JobSite Records
  updateCheckList(CheckList checkList) async {
    print('In update CheckList: with checklist: ${checkList}');
    Database db = await instance.database;
    return await db.update('_checklist', checkList.toJsonNoId(),
        where: 'knackId = ?', whereArgs: [checkList.knackId]);
  }

// Query All CheckList Records
  Future<List<CheckList>> getAllCheckLists() async {
    final db = await instance.database;
    final res = await db.query('_checklist');
    List<CheckList> list =
        res.isNotEmpty ? res.map((c) => CheckList.fromJson(c)).toList() : [];
    return list;
  }

  // Query CheckList by KnackId Records
  Future<List<CheckList>> getCheckListByKnackId(String knackId) async {
    final db = await instance.database;
    final res = await db
        .query('_checklist', where: 'knackId = ?', whereArgs: [knackId]);
    List<CheckList> list =
        res.isNotEmpty ? res.map((c) => CheckList.fromJson(c)).toList() : [];
    return list;
  }

  // Query CheckList by list of KnackId Records
  Future<List<CheckList>> getCheckListByKnackIds(knackId) async {
    final db = await instance.database;
    //final res = await db.query('_checklist', where: 'knackId in (?, ?, ?...?)', whereArgs: [knackId]);
    final res = await db.query('_checklist',
        where: 'knackId in ("${knackId.join('", "')}")', orderBy: 'optional');
    print('query res is: ${res}');

    List<CheckList> list =
        res.isNotEmpty ? res.map((c) => CheckList.fromJson(c)).toList() : [];
    return list;
  }

  returnChecklist(data) {
    return CheckList.fromJson(data);
  }

// Equipment Database Functions
// Create Equipment Record
  createEquipment(Equipment equipment) async {
    print('In createEquipment: with equipment: ${equipment}');
    print(equipment.unitNoWithName);
    //print(equipment.knackId);
    //print(equipment.checkListKnackIds);
    //print(equipment.lastSync);
    Database db = await instance.database;
    return await db.insert('_equipment', equipment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update Equipment Records
  updateEquipment(Equipment equipment) async {
    print('In updateEquipment: with equipment: ${equipment}');
    Database db = await instance.database;
    return await db.update('_equipment', equipment.toJsonNoId(),
        where: 'knackId = ?', whereArgs: [equipment.knackId]);
  }

// Query All Equipment Records
  Future<List<Equipment>> getAllEquipment() async {
    final db = await instance.database;
    final res = await db.query('_equipment');
    List<Equipment> list =
        res.isNotEmpty ? res.map((c) => Equipment.fromJson(c)).toList() : [];
    return list;
  }

  returnEquipment(data) {
    return Equipment.fromJson(data);
  }

  // Query equipment Records by KnackId
  Future<Equipment> queryEquipmentByKnackId(String knackId) async {
    print('In queryEquipmentByKnackId: with id: ${knackId}');
    Database db = await instance.database;
    List<Map> results = await db
        .query('_equipment', where: 'knackId = ?', whereArgs: [knackId]);
    if (results.length > 0) {
      print('found Equipment: ${results.first}');
      return new Equipment.fromJson(results.first);
    }
    print('No Equipment record found');
    return null;
  }

  // Query equipment Records by KnackId
  Future<Equipment> queryEquipmentById(int id) async {
    print('In queryEquipmentByKnackId: with id: ${id}');
    Database db = await instance.database;
    List<Map> results =
        await db.query('_equipment', where: 'id = ?', whereArgs: [id]);
    if (results.length > 0) {
      print('found Equipment: ${results.first}');
      return new Equipment.fromJson(results.first);
    }
    print('No Equipment record found');
    return null;
  }

// Employee Checklist Database Functions
// Create Employee Checklist Record
  createEmployeeChecklist(EmployeeCheckList employeeCheckList) async {
    print('In createEmployeeChecklist: with equipment: ${employeeCheckList}');
    //print(equipment.knackId);
    //print(equipment.checkListKnackIds);
    //print(equipment.lastSync);
    Database db = await instance.database;
    return await db.insert('_employee_checklist', employeeCheckList.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update Employee Checklist Records
  updateEmployeeChecklist(EmployeeCheckList employeeCheckList) async {
    print('In updateEmployeeChecklist: with equipment: ${employeeCheckList}');
    Database db = await instance.database;
    return await db.update(
        '_employee_checklist', employeeCheckList.toJsonNoId(),
        where: 'knackId = ?', whereArgs: [employeeCheckList.knackId]);
  }

  // Update Safety Record Records with Knack Id by id
  updateEmployeeChecklistKnackId(
      String knackId, DateTime lastSync, int id) async {
    print('Sqflite: updateEmployeeChecklistKnackId');
    print('Values: knackId: ${knackId} lastSync: ${lastSync} id: ${id}');
    final lastSynctxt = lastSync.toIso8601String();
    Database db = await instance.database;
    return await db.rawUpdate(
        '''Update _employee_checklist SET knackId = ?, lastSync = ? WHERE id = ?''',
        [knackId, lastSynctxt, id]);
  }

// Query All EmployeeChecklist Records
  Future<List<EmployeeCheckList>> getAllEmployeeChecklists() async {
    final db = await instance.database;
    final res = await db.query('_employee_checklist');
    //print('employee quer output: ');
    //print(res);
    List<EmployeeCheckList> list = res.isNotEmpty
        ? res.map((c) => EmployeeCheckList.fromJson(c)).toList()
        : [];
    return list;
  }

  returnEmployeeChecklist(data) {
    return EmployeeCheckList.fromJson(data);
  }

// Query employee Checklist by KnackId
  Future<EmployeeCheckList> queryEmployeeChecklistByKnackId(
      String knackId) async {
    print('In queryEmployeeChecklistByKnackId: with id: ${knackId}');
    Database db = await instance.database;
    List<Map> results = await db.query('_employee_checklist',
        where: 'knackId = ?', whereArgs: [knackId]);
    if (results.length > 0) {
      print('found EmployeeChecklist: ${results.first}');
      return new EmployeeCheckList.fromJson(results.first);
    }
    print('No EmployeeChecklist record found');
    return null;
  }

// Query employee Checklist by Id
  Future<EmployeeCheckList> queryEmployeeChecklistById(int id) async {
    print('In queryEmployeeChecklistById: with id: ${id}');
    Database db = await instance.database;
    List<Map> results =
        await db.query('_employee_checklist', where: 'id = ?', whereArgs: [id]);
    if (results.length > 0) {
      print('found EmployeeChecklist: ${results.first}');
      return new EmployeeCheckList.fromJson(results.first);
    }
    print('No EmployeeChecklist record found');
    return null;
  }

  // Query employee Checklist by LastSyncDate
  Future<List<EmployeeCheckList>> queryEmployeeChecklistBy(
      String where, String whereArgs) async {
    print(
        'In queryEmployeeChecklistBy: with where: ${where} whereArgs: ${whereArgs}');
    Database db = await instance.database;
    //List<Map> results = await db.query('_employee_checklist',
    //    where: where, whereArgs: [whereArgs]);
    List<Map> results =
        await db.query('_employee_checklist', where: 'lastSync IS NULL');
    List<EmployeeCheckList> list = results.isNotEmpty
        ? results.map((c) => EmployeeCheckList.fromJson(c)).toList()
        : [];
    return list;
  }

// Safety Record Database Functions
// Create Safety Record Record
  createSafetyRecord(SafetyRecord safetyRecord) async {
    print('In createSafetyRecord: with: ${safetyRecord}');
    //print(equipment.knackId);
    //print(equipment.checkListKnackIds);
    //print(equipment.lastSync);
    //Database db = await instance.database;
    //return await db.insert('_safety_record', safetyRecord.toJson(),
    //    conflictAlgorithm: ConflictAlgorithm.replace);
    Database db = await instance.database;
    try {
      await db.insert('_safety_record', safetyRecord.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException {
      print('Database Insert Failed');
    }
  }

  // Update Safety Record Records
  updateSafetyRecord(SafetyRecord safetyRecord) async {
    print('In updateSafetyRecord: with: ${safetyRecord}');
    Database db = await instance.database;
    return await db.update('_safety_record', safetyRecord.toJsonNoId(),
        where: 'knackId = ?', whereArgs: [safetyRecord.knackId]);
  }

  // Update Safety Record Records with Employee Checklist Knack Id by id
  updateSafetyRecordChecklistKnackId(String knackId, int checklistId) async {
    print('Sqflite: updateSafetyRecordChecklistKnackId');
    print('Values: knackId: ${knackId} checklistId: ${checklistId}');
    Database db = await instance.database;
    return await db.rawUpdate(
        '''Update _safety_record SET employeeChecklistKnackId = ? WHERE employeeChecklistId = ?''',
        [knackId, checklistId]);
  }

// Update Safety Record Records with Knack Id by id
  updateSafetyRecordKnackId(String knackId, DateTime lastSync, int id) async {
    print('Sqflite: updateSafetyRecordChecklistKnackId');
    print('Values: knackId: ${knackId} lastSync: ${lastSync} id: ${id}');
    final lastSynctxt = lastSync.toIso8601String();
    Database db = await instance.database;
    return await db.rawUpdate(
        '''Update _safety_record SET knackId = ?, lastSync = ? WHERE id = ?''',
        [knackId, lastSynctxt, id]);
  }

// Query All Safety Record Records
  Future<List<SafetyRecord>> getAllSafetyRecords() async {
    print('Sqflite: getAllSafetyRecords');
    final db = await instance.database;
    final res = await db.query('_safety_record');
    //print('employee quer output: ');
    //print(res);
    List<SafetyRecord> list =
        res.isNotEmpty ? res.map((c) => SafetyRecord.fromJson(c)).toList() : [];
    return list;
  }

// Query Safety Records by Employee CheckList Id
  Future<List<SafetyRecord>> getAllSafetyRecordsByCheckListId(
      checkListId) async {
    print('Sqflite: getAllSafetyRecordsByCheckListId');

    final db = await instance.database;
    final res = await db.query('_safety_record',
        where: 'employeeChecklistId = ?', whereArgs: [checkListId]);
    print('safety record query output: ');
    print(res);
    List<SafetyRecord> list =
        res.isNotEmpty ? res.map((c) => SafetyRecord.fromJson(c)).toList() : [];
    return list;
  }

// Query Safety Records by Employee CheckList Id
  Future<List<SafetyRecord>> getAllSafetyRecordsNotSynced() async {
    print('Sqflite: getAllSafetyRecordsNotSynced');
    final db = await instance.database;
    final res = await db.query('_safety_record', where: 'lastSync is NULL');
    print('safety record query output: ');
    print(res);
    List<SafetyRecord> list =
        res.isNotEmpty ? res.map((c) => SafetyRecord.fromJson(c)).toList() : [];
    return list;
  }

  returnSafetyRecord(data) {
    return SafetyRecord.fromJson(data);
  }

  Future<dynamic> getAllEmployeeChecklistInfo() async {
    final db = await instance.database;
    final res = await db.rawQuery(
        'SELECT t1.id as id, t1.knackId as knackId, (SELECT customerSite from _job_site t2 where t1.jobSiteId = t2.id) as customerSite, (SELECT unitNoWithName from _equipment t3 where t1.equipmentId = t3.id) as unitNoWithName, t1.workDate as workDate from _employee_checklist t1');
    return res;
  }

  Future<List<EmployeeCheckListSite>> getUserAllEmployeeChecklistInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final _currentUser = prefs.getString('current_user');
    final userInfo = await queryUser(_currentUser);
    final db = await instance.database;
    final res = await db.rawQuery(
        'SELECT t1.id as id, t1.knackId as knackId, (SELECT customerSite from _job_site t2 where t1.jobSiteId = t2.id) as customerSite, (SELECT unitNoWithName from _equipment t3 where t1.equipmentId = t3.id) as unitNoWithName, t1.workDate as workDate from _employee_checklist t1 where employeeKnackId = "${userInfo.knackId}" order by workDate DESC');
    var _abc = <EmployeeCheckListSite>[];
    res.forEach((element) {
      final _js = EmployeeCheckListSite(element['id'], element['knackId'], element['customerSite'],element['unitNowithName'],DateTime.parse(element['workDate']));
      _abc.add(_js);
    });
    return _abc;
  }

  Future<List<dynamic>> getDropDownJobSiteInfo() async {
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    final res = await db.rawQuery(
        'SELECT id, customerSite, knackId from _job_site where active = 1');
    return res;
  }

  Future<List<dynamic>> getDropDownEquipmentInfo() async {
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    final res =
        await db.rawQuery('SELECT id, unitNoWithName, knackId from _equipment');
    return res;
  }

  Future<List<dynamic>> getDropDownEquipmentInfoByType(String type) async {
    if (type == 'Operator') {
      type = 'Equipment';
    }
    if (type == 'NonOperator') {
      type = 'Safety';
    }
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    final res = await db.rawQuery(
        'SELECT id, unitNoWithName, knackId from _equipment where type = "$type"');
    return res;
  }

  Future<List<dynamic>> getDropDownPayEmployeeChecklistInfo(
      DateTime workDate, String type) async {
    print('Function: getDropDownPayEmployeeChecklistInfo');
    print('workDate: $workDate type: $type');
    final workDateText = '${workDate.toIso8601String()}';
    final workDateTextZ = '${workDate.toIso8601String()}Z';
    print('workDateText: $workDateText');
    final prefs = await SharedPreferences.getInstance();
    final _currentUser = prefs.getString('current_user');
    final userInfo = await queryUser(_currentUser);
    print('userInfo.knackId: ${userInfo.knackId}');
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    final res = await db.rawQuery(
        'SELECT t1.id as id, (SELECT customerSite from _job_site t2 where t1.jobSiteId = t2.id) as customerSite, (SELECT unitNoWithName from _equipment t3 where t1.equipmentId = t3.id) as unitNoWithName, t1.workDate as workDate from _employee_checklist t1 where t1.employeeKnackId = "${userInfo.knackId}" and t1.type = "$type" and (t1.workDate = "${workDateText}" or t1.workDate = "${workDateTextZ}")');
    return res;
  }

  Future<List<dynamic>> getDropDownEmployeePayPeriodInfo() async {
    print('Function: getDropDownEmployeePayPeriodInfo');
    final prefs = await SharedPreferences.getInstance();
    final _currentUser = prefs.getString('current_user');
    final userInfo = await queryUser(_currentUser);
    print('userInfo.knackId: ${userInfo.knackId}');
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    try {
      final res = await db.rawQuery(
          'SELECT id, startDate, endDate from _employee_pay_period where employeeKnackId = "${userInfo.knackId}" order by startDate DESC');
      return res;
    } catch (error) {
      print('Db error: ${error}');
      return null;
    }
    //final res = await db.rawQuery(
    //'SELECT id, startDate, endDate from _employee_pay_period where employeeKnackId = "${userInfo.knackId}"" order by startDate DESC');
    //print('res: ${res}');
    //return res;
  }

  Future<List<dynamic>> getEquipmentCheckLists(int id) async {
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    final res = await db
        .rawQuery('SELECT checkListKnackIds from _equipment where id = ${id}');
    print('res for equipmentCheckLists: ${res}');
    final temp = res[0]['checkListKnackIds'];
    print('temp equipmentChecklists is: ${temp}');
    final list = temp.split(';');
    print('list is: ${list}');
    final checklists = await getCheckListByKnackIds(list);
    //final checklists = temp.split(';').map((String value) async {
    //  final resjs = await getCheckListByKnackId(value);
    //  print('temp value is: ${value}');
    //}).toList();
    print('checklists found: ${checklists}');
    //return res;
    return checklists;
  }

  Future<void> addEmployeeSafetyRecord(
      int jobSiteValue,
      //String jobSiteKnackId,
      int equipmentValue,
      //String equipmentKnackId,
      DateTime dateValue,
      List list) async {
    print('in Add Safety');
    print(
        'jobSiteValue: ${jobSiteValue} equipmentValue: ${equipmentValue} dateValue: ${dateValue}');
    final prefs = await SharedPreferences.getInstance();
    final _currentUser = prefs.getString('current_user');
    final userInfo = await queryUser(_currentUser);
    final jobSiteInfo = await queryJobSiteById(jobSiteValue);
    final equipmentInfo = await queryEquipmentById(equipmentValue);
    var employeeCheckList = EmployeeCheckList();
    employeeCheckList.jobSiteId = jobSiteValue;
    employeeCheckList.jobSiteKnackId = jobSiteInfo.knackId;
    employeeCheckList.equipmentId = equipmentValue;
    employeeCheckList.type = equipmentInfo.type;
    employeeCheckList.equipmentKnackId = equipmentInfo.knackId;
    employeeCheckList.employeeKnackId = userInfo.knackId;
    employeeCheckList.recordComplete = true;
    employeeCheckList.safetyRecordsExpected =
        equipmentInfo.safetyRecordsExpected;
    //employeeCheckList.workDate = dateValue.toIso8601String();
    employeeCheckList.workDate = new DateTime(
        dateValue.year, dateValue.month, dateValue.day, 0, 0, 0, 0, 0);
    //employeeCheckList.workDate = dateValue;
    employeeCheckList.recordCreatedDate = DateTime.now().toIso8601String();
    final res = await createEmployeeChecklist(employeeCheckList);
    print('add record result: ${res}');
    list.forEach((f) {
      var safetyRecord = SafetyRecord();
      safetyRecord.name = f.data.name;
      safetyRecord.employeeChecklistId = res;
      if (f.isSelected) {
        safetyRecord.yesno = 'Repair';
        safetyRecord.problemDescription = f.repairData;
      } else {
        safetyRecord.yesno = 'Ok';
      }
      final abc = createSafetyRecord(safetyRecord);
      print('abc is: ${abc}');
    });
  }

  Future<dynamic> getEmployeeChecklistInfoById(int id) async {
    final db = await instance.database;
    final res = await db.rawQuery(
        'SELECT t1.id as id, t1.knackId as knackId, t1.type as type, (SELECT customerSite from _job_site t2 where t1.jobSiteId = t2.id) as customerSite, (SELECT unitNoWithName from _equipment t3 where t1.equipmentId = t3.id) as unitNoWithName, t1.workDate as workDate from _employee_checklist t1 where t1.id = "${id}"');
    print('${res}');
    return res;
  }

// Query table Records by KnackId
  Future<dynamic> queryTableByKnackId(
      String knackId, String table, Function tableFunction) async {
    print('In queryTableByKnackId: with id: ${knackId} and table ${table}');
    Database db = await instance.database;
    List<Map> results =
        await db.query(table, where: 'knackId = ?', whereArgs: [knackId]);
    if (results.length > 0) {
      print('found record: ${results.first}');
      //return new tableClass.fromJson(results.first);
      return tableFunction(results.first);
    }
    print('No record found in table ${table} with knackID: ${knackId}');
    return null;
  }

  // Delete all data in table
  Future<int> deleteRecord(String table, String field, int id) async {
    final db = await database;
    //final res = await db.delete(table, where: 'equipmentId = ?', whereArgs: [id]);
    final res = await db.delete(table, where: '${field} = ?', whereArgs: [id]);

    return res;
  }

  Future<User> getCurrentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final _currentUser = prefs.getString('current_user');
    if (_currentUser == null) {
      return new User();
    }
    final userInfo = await queryUser(_currentUser);
    return userInfo;
  }

  Future<void> jobSiteDbUpdateFunction(dynamic recData) async {
    var jobSite = JobSite();
    jobSite.knackId = recData['id'];
    jobSite.jobSiteName = recData['field_97'];
    jobSite.customerSite = recData['field_117'];
    print('active: ${recData['field_362']}');
    jobSite.active = recData['field_362'] == 'Yes';
    jobSite.lastSync = DateTime.now().toIso8601String();
    jobSite.lastDocumentSync = DateTime.now().subtract(Duration(days: 2910));

    //final qrc = await dennyDb.queryJobSiteByKnackId(jobSite.knackId);
    final qrc =
        await queryTableByKnackId(jobSite.knackId, '_job_site', returnJobSite);
    print('jobsitequery results: ${qrc}');
    if (qrc == null) {
      //print('creating JobSite');
      final rc = await createJobSite(jobSite);
      print('create Result: ${rc}');
    } else {
      //print('updating JobSite')
      final rc = await updateJobSite(jobSite);
    }
    //print('create rc: $rc');
  }

  Future<void> checkListDbUpdateFunction(dynamic recData) async {
    var checkList = CheckList();
    checkList.knackId = recData['id'];
    checkList.name = recData['field_228'];
    checkList.optional = recData['field_363_raw'];
    checkList.lastSync = DateTime.now().toIso8601String();

    final qrc = await queryTableByKnackId(
        checkList.knackId, '_checklist', returnChecklist);
    print('checklist results: ${qrc}');
    if (qrc == null) {
      //print('creating JobSite');
      final rc = await createCheckList(checkList);
      //print('create Result: ${rc}');
    } else {
      //print('updating JobSite')
      final rc = await updateCheckList(checkList);
    }
    //print('create rc: $rc');
  }

  Future<void> equipmentDbUpdateFunction(dynamic recData) async {
    print('In equipmentDbUpdateFunction');
    var equipment = Equipment();
    equipment.knackId = recData['id'];
    equipment.type = recData['field_367'];
    equipment.equipmentName = recData['field_1'];
    equipment.unitNoWithName = recData['field_60'];
    equipment.safetyRecordsExpected = recData['field_353'];
    equipment.lastSync = DateTime.now().toIso8601String();

    List<String> abcd = [];

    for (var f in recData['field_238_raw']) {
      //print(f['id']);
      abcd.add(f['id']);
    }
//print(abcd);
    print(
        'checkListKanckIds: ${abcd} for equipment: ${equipment.unitNoWithName}');
    //print('abcd is: ${abcd}');
    //print('abcd length is: ${abcd.length}');
    if (abcd.length == 0) {
      print('No checkLists assigned');
      equipment.checkListKnackIds = "";
    } else {
      equipment.checkListKnackIds =
          abcd.reduce((value, element) => value + ';' + element);
    }
    print(equipment.checkListKnackIds);

    final qrc = await queryTableByKnackId(
        equipment.knackId, '_equipment', returnChecklist);
    print('equipment results: ${qrc}');
    if (qrc == null) {
      //print('creating JobSite');
      final rc = await createEquipment(equipment);
      //print('create Result: ${rc}');
    } else {
      //print('updating JobSite')
      final rc = await updateEquipment(equipment);
    }
    //print('create rc: $rc');
  }

  Future<void> employeeChecklistDbUpdateFunction(dynamic recData) async {
    print('In employeeChecklistDbUpdateFunction');
    var employeeChecklist = EmployeeCheckList();

    employeeChecklist.jobSiteKnackId = recData['field_230_raw'][0]['id'];
    final jobsite =
        await queryJobSiteByKnackId(recData['field_230_raw'][0]['id']);
    employeeChecklist.jobSiteId = jobsite.id;
    //print('jobSite: ${employeeChecklist.jobSite}');
    employeeChecklist.type = recData['field_368'];
    employeeChecklist.equipmentKnackId = recData['field_231_raw'][0]['id'];
    final equipment =
        await queryEquipmentByKnackId(recData['field_231_raw'][0]['id']);
    employeeChecklist.equipmentId = equipment.id;
    //print('${employeeChecklist.equipmentId}');
    employeeChecklist.employeeKnackId = recData['field_237_raw'][0]['id'];
    //print('${employeeChecklist.employeeKnackId}');
    employeeChecklist.workDate =
        DateTime.parse(recData['field_239_raw']['iso_timestamp']);
    //print('${employeeChecklist.workDate}');
    employeeChecklist.recordCreatedDate =
        recData['field_240_raw']['iso_timestamp'];
    //print('${employeeChecklist.recordCreatedDate}');
    //print('recordComplete: ${recData['field_241_raw']}');
    employeeChecklist.recordComplete = recData['field_241_raw'];
    //print('${employeeChecklist.recordComplete}');
    employeeChecklist.approved = recData['field_242_raw'];
    //print('${employeeChecklist.approved}');
    employeeChecklist.approvedby = recData['field_243'];
    //print('${employeeChecklist.approvedby}');
    //print('${recData['field_350']}');
    employeeChecklist.safetyRecordsExpected = recData['field_350_raw'];

    //print('${employeeChecklist.safetyRecordsExpected}');
    print('${recData['field_244_raw']}');
    if (recData['field_244_raw'] != null) {
      employeeChecklist.approvedDate =
          recData['field_244_raw']['iso_timestamp'];
    } else {
      employeeChecklist.approvedDate = "";
    }
    //employeeChecklist.approvedDate = recData['field_244_raw']['iso_timestamp'];
    //print('${employeeChecklist.approvedDate}');
    employeeChecklist.knackId = recData['id'];

    employeeChecklist.lastSync = DateTime.now().toIso8601String();

    final qrc = await queryTableByKnackId(
        employeeChecklist.knackId, '_employee_checklist', returnChecklist);
    print('employee_checklist results: ${qrc}');
    if (qrc == null) {
      //print('creating JobSite');
      final rc = await createEmployeeChecklist(employeeChecklist);
      //print('create Result: ${rc}');
    } else {
      //print('updating JobSite')
      final rc = await updateEmployeeChecklist(employeeChecklist);
    }
    //print('create rc: $rc');
  }

  Future<void> safetyRecordDbUpdateFunction(dynamic recData) async {
    print('In safetyRecordDbUpdateFunction');
    var safetyRecord = SafetyRecord();

    safetyRecord.employeeChecklistKnackId = recData['field_335_raw'][0]['id'];
    final employeeChecklist = await queryEmployeeChecklistByKnackId(
        recData['field_335_raw'][0]['id']);
    safetyRecord.employeeChecklistId = employeeChecklist.id;
    //print('jobSite: ${employeeChecklist.jobSite}');
    safetyRecord.name = recData['field_233'];
    //print('${employeeChecklist.equipment}');
    safetyRecord.yesno = recData['field_234'];
    //print('${employeeChecklist.employee}');
    safetyRecord.problemDescription = recData['field_235'];
    //print('${employeeChecklist.workDate}');
    safetyRecord.optional = recData['field_366_raw'];
    safetyRecord.knackId = recData['id'];
    safetyRecord.lastSync = DateTime.now().toIso8601String();
    //safetyRecord.appId = recData['appId'];
    final qrc = await queryTableByKnackId(
        safetyRecord.knackId, '_safety_record', returnChecklist);
    print('_safety_record results: ${qrc}');
    if (qrc == null) {
      //print('creating JobSite');
      final rc = await createSafetyRecord(safetyRecord);
      //print('create Result: ${rc}');
    } else {
      //print('updating JobSite')
      final rc = await updateSafetyRecord(safetyRecord);
    }
    //print('create rc: $rc');
  }
}
