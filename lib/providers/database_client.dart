import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloctest/models/user.dart';
import 'package:bloctest/models/jobsite.dart';
import 'package:bloctest/models/jobsite_notes.dart';

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
  create table _job_site_notes (
  id integer primary key autoincrement,
  knackId text,
  dateTime text not null,
  employeeKnackId text,
  dailyNotes text not null,
  jobSiteId integer not null,
  jobSiteKnackId text not null,
  lastSync text,
    CONSTRAINT fk_jobSite
    FOREIGN KEY (jobSiteId)
    REFERENCES _job_site(id)
  )''',
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
    //await _createData();
  }

  Future<void> createData() async {
    var user = User();
    user.knackId = 'AAAAAA';
    user.userEmail = 'test@abc.com';
    user.userRoleNum = 2;
    user.userName = 'First, Last';
    createUser(user);

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

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_user', user.userEmail);
  }

// SQL code to upgrade the database table
  Future _onUpgrade(Database db, int prevVersion, int newVersion) async {
    migrationsScript.forEach(
      (script) async => await db.execute(script),
    );
  }

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

  Future<List<dynamic>> getDropDownJobSiteInfo() async {
    final db = await instance.database;
    //final res = await db.rawQuery('SELECT id, customerSite from _job_site');
    final res = await db.rawQuery(
        'SELECT id, customerSite, knackId from _job_site where active = 1');
    return res;
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

  Future<void> addJobSiteDailyNote(int jobSiteId, String jobSiteNote) async {
    var _jobSiteDailyNote = JobSiteNote();
    final _jobSite = await queryJobSiteById(jobSiteId);
    final _currentUser = await getCurrentUserInfo();
    _jobSiteDailyNote.jobSiteId = jobSiteId;
    _jobSiteDailyNote.jobSiteKnackId = _jobSite.knackId;
    _jobSiteDailyNote.employeeKnackId = _currentUser.knackId;
    _jobSiteDailyNote.dailyNotes = jobSiteNote;
    _jobSiteDailyNote.dateTime = DateTime.now();
    createJobSiteDailyNote(_jobSiteDailyNote);
  }

  Future<List<JobSiteNote>> getJobSiteNotesData(int id) async {
    final db = await instance.database;
    //final res = await db.rawQuery(
    //    'SELECT id, dateTime, dailyNotes from _job_site_notes where jobSiteId = "${id}"');
    final res = await db.query('_job_site_notes',
        where: 'jobSiteId = ?', whereArgs: [id], orderBy: 'dateTime DESC');
    //final res = await db.rawQuery(
    //'SELECT heading, type, description, localFileName from _company_manuals');
    //print('${res}');
    print('getJobSitesNotesData res: ${res}');
    List<JobSiteNote> list =
        res.isNotEmpty ? res.map((c) => JobSiteNote.fromJson(c)).toList() : [];
    return list;
  }

  // Create JobSite Daily Note Record
  createJobSiteDailyNote(JobSiteNote jobSiteNote) async {
    print('In createJobSiteDailyNote: with jobSiteNote: ${jobSiteNote}');
    Database db = await instance.database;
    try {
      return await db.insert('_job_site_notes', jobSiteNote.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (e) {
      print('native_error: $e');
    }
  }
}
