import 'package:bloctest/providers/database_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloctest/screens/main_foreman_screen.dart';
import 'package:bloctest/screens/add_job_site_notes_screen.dart';
import 'package:bloctest/screens/jobsite_notes_screen.dart';

import 'package:bloctest/bloc/jobsite/jobsite_bloc.dart';
import 'package:bloctest/bloc/add_jobsite_note/add_jobsite_note_bloc.dart';

import 'package:bloctest/class/simple_bloc_delegate.dart';
import 'package:bloctest/class/data_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final dataRepository = DataRepository();

  final _dennyDb = DatabaseClient.instance;
  //_dennyDb.createData();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AddJobSiteNoteBloc>(
          create: (context) =>
              AddJobSiteNoteBloc(dataRepository: dataRepository),
        ),
        BlocProvider<JobSiteBloc>(
          create: (context) => JobSiteBloc(
              dataRepository: dataRepository,
              addJobSiteNoteBloc: BlocProvider.of<AddJobSiteNoteBloc>(context)),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final db = DatabaseClient.instance;

  @override
  Widget build(BuildContext context) {
    //db.createData();
    db.queryAllUsers();
    return MaterialApp(
      title: 'Bloc Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlueAccent,
        fontFamily: 'Lato',
      ),
      home: MainForemanScreen(),
      routes: {
        MainForemanScreen.routeName: (ctx) => MainForemanScreen(),
        JobSiteNotesScreen.routeName: (ctx) => JobSiteNotesScreen(),
        AddJobSiteNoteScreen.routeName: (ctx) => AddJobSiteNoteScreen(),
      },
    );
  }
}
