import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:bloctest/class/data_repository.dart';

import 'package:bloctest/models/jobsite.dart';
import 'package:bloctest/models/jobsite_notes.dart';

import 'package:bloctest/bloc/add_jobsite_note/add_jobsite_note_bloc.dart';

part 'jobsite_event.dart';
part 'jobsite_state.dart';

class JobSiteBloc extends Bloc<JobSiteEvent, JobSiteState> {
  final DataRepository _dataRepository;
  final AddJobSiteNoteBloc _addJobSiteNoteBloc;
  StreamSubscription _addJobSiteNoteSubscription;

  JobSiteBloc(
      {@required DataRepository dataRepository,
      @required AddJobSiteNoteBloc addJobSiteNoteBloc})
      : assert(dataRepository != null),
        _dataRepository = dataRepository,
        assert(addJobSiteNoteBloc != null),
        _addJobSiteNoteBloc = addJobSiteNoteBloc,
        super(JobSiteState.initial());

  @override
  Stream<JobSiteState> mapEventToState(
    JobSiteEvent event,
  ) async* {
    print('Event is $event');
    if (event is JobSiteInitial) {
      _addJobSiteNoteSubscription?.cancel();
      _addJobSiteNoteSubscription = _addJobSiteNoteBloc.listen(
        (addJobSiteState) {
          print('In _addJobSiteNoteSubcription listen');
          if (addJobSiteState is AddJobSiteNoteStateSuccess) {
            add(JobSiteAddNoteChanged(addJobSiteState.jobSiteId, addJobSiteState.jobSites));
          }
        },
      );
    } else if (event is JobSiteChanged) {
      yield* _mapJobSiteChangedToState(event, state);
    } else if (event is JobSiteFormLoaded) {
      yield* _mapJobSiteFormLoadedToState();
    } else if (event is JobSiteAddNoteChanged) {
      yield* _mapJobSiteAddNoteChangedToState(event.jobSiteId, event.jobSites);
    }
  }

  Stream<JobSiteState> _mapJobSiteFormLoadedToState() async* {
    yield JobSiteState.jobSiteLoadInProgress();
    final jobSites = await _dataRepository.getAllJobSites();
    yield JobSiteNoteInitial();
    yield JobSiteState.jobSiteLoadSuccess(jobSites: jobSites);
  }

  Stream<JobSiteState> _mapJobSiteChangedToState(
    JobSiteChanged event,
    JobSiteState state,
  ) async* {
    yield JobSiteState.jobSiteNotesLoadInProgress(
      jobSites: state.jobSites,
      jobSite: event.jobSiteId,
    );
    final jobSiteNotes =
        await _dataRepository.getAllNotesForJobSites(event.jobSiteId);
    yield JobSiteState.jobSiteNotesLoadSuccess(
      jobSites: state.jobSites,
      jobSite: event.jobSiteId,
      jobSiteNotes: jobSiteNotes,
    );
  }

  Stream<JobSiteState> _mapJobSiteAddNoteChangedToState(
    int jobSiteId,
    List<JobSite> jobSites,
  ) async* {
    yield JobSiteState.jobSiteNotesLoadInProgress(
      jobSites: jobSites,
      jobSite: jobSiteId,
    );
    print('BloC: _mapJobSiteAddNoteChangedToState');
    print('jobSiteId: $jobSiteId');
    //final jobSites = await _dataRepository.getAllJobSites();
    yield JobSiteState.jobSiteNotesLoadInProgress(
      jobSites: jobSites,
      jobSite: jobSiteId,
    );
    final jobSiteNotes =
        await _dataRepository.getAllNotesForJobSites(jobSiteId);
    yield JobSiteState.jobSiteNotesLoadSuccess(
      jobSites: jobSites,
      jobSite: jobSiteId,
      jobSiteNotes: jobSiteNotes,
    );
  }

  @override
  Future<void> close() {
    _addJobSiteNoteSubscription?.cancel();
    return super.close();
  }
}
