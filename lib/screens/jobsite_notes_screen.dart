import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloctest/bloc/jobsite/jobsite_bloc.dart';
import 'package:bloctest/bloc/add_jobsite_note/add_jobsite_note_bloc.dart';

import 'package:bloctest/class/data_repository.dart';

import 'package:bloctest/screens/add_job_site_notes_screen.dart';

class JobSiteNotesScreen extends StatelessWidget {
  static const routeName = '/jobsite-notes';
  @override
  Widget build(BuildContext context) {
    print('Screen: JobSiteNotesScreen');
    BlocProvider.of<JobSiteBloc>(context).add(
      JobSiteInitial(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Test'),
      ),
      body: BlocProvider(
        create: (_) => JobSiteBloc(
            dataRepository: DataRepository(),
            addJobSiteNoteBloc: BlocProvider.of<AddJobSiteNoteBloc>(context))
          ..add(JobSiteFormLoaded()),
        child: _buildBody(),
      ),
    );
  }
}

class _buildBody extends StatefulWidget {
  @override
  __buildBodyState createState() => __buildBodyState();
}

class __buildBodyState extends State<_buildBody> {
  int _jobSiteSelected;

  @override
  Widget build(BuildContext context) {
    void _onJobSiteChanged(int jobSiteId) {
      setState(() {
        _jobSiteSelected = jobSiteId;
      });
      context.bloc<JobSiteBloc>().add(JobSiteChanged(_jobSiteSelected));
    }

    return BlocBuilder<JobSiteBloc, JobSiteState>(builder: (context, state) {
      print('state: ${state.jobSites}');
      print('state: ${state.jobSiteNotes}');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  items: state.jobSites?.isNotEmpty == true
                      ? state.jobSites.map((jobSite) {
                          //print('DropDownItem is: ${jobSite}');
                          //print('${jobSite.id} - ${jobSite.jobSiteName}');
                          return DropdownMenuItem(
                            value: jobSite.id,
                            child: Text(jobSite.jobSiteName),
                          );
                        }).toList()
                      : const [],
                  value: state.jobSite,
                  hint: Text('Select a JobSite'),
                  onChanged: _onJobSiteChanged,
                ),
              ),
              _jobSiteSelected != null
                  ? RaisedButton(
                      onPressed: () {
                        Map data = {
                          'id': _jobSiteSelected,
                          'jobSites': state.jobSites
                        };
                        Navigator.of(context).pushNamed(
                            AddJobSiteNoteScreen.routeName,
                            arguments: data);
                      },
                      child: Icon(Icons.add),
                    )
                  : Container(),
            ],
          ),
          //state.jobSiteNotes?.isNotEmpty == true
          state.jobSiteNotes.length > 0
              ? Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15.0),
                    itemCount: state.jobSiteNotes.length,
                    itemBuilder: (BuildContext context, position) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Divider(height: 5.0),
                            Text(
                                'Date: ${new DateFormat.yMMMd().format(state.jobSiteNotes[position].dateTime)}'),
                            Text(state.jobSiteNotes[position].dailyNotes),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Text('No Daily Notes for Selected JobSite'),
        ],
      );
      //} else {
      //  return Text('No Data');
      //}
    });
  }
}
