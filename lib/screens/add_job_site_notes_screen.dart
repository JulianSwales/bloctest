import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctest/bloc/add_jobsite_note/add_jobsite_note_bloc.dart';

int jobSiteId;

class AddJobSiteNoteScreen extends StatelessWidget {
  static const routeName = '/add-jobsite-notes';

  TextEditingController notesController = new TextEditingController();

  AddJobSiteNoteBloc _addJobSiteNoteBloc;

  @override
  Widget build(BuildContext context) {
    print('Screen: AddJobSiteNotesScreen');
    Map data = ModalRoute.of(context).settings.arguments;
    print('id: ${data['id']}');
    print('jobSites ${data['jobSites']}');
    jobSiteId = data['id'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Daily Notes'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: notesController,
                        decoration: InputDecoration(
                          hintText: "Add Daily Notes",
                        ),
                        scrollPadding: EdgeInsets.all(20.0),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: true,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    print('jobSiteId: $jobSiteId text: ${notesController.text}');
                    BlocProvider.of<AddJobSiteNoteBloc>(context).add(AddJobSiteDailyNote(jobSiteId, data['jobSites'], notesController.text,));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomPadding: true,
      ),
    );
  }
}
