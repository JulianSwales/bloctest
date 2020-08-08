import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:bloctest/class/data_repository.dart';
import 'package:bloctest/models/jobsite.dart';

part 'add_jobsite_note_event.dart';
part 'add_jobsite_note_state.dart';

class AddJobSiteNoteBloc extends Bloc<AddJobSiteNoteEvent, AddJobSiteNoteState> {
  final DataRepository _dataRepository;

  AddJobSiteNoteBloc({@required DataRepository dataRepository})
      : assert(dataRepository != null),
        _dataRepository = dataRepository,
        super(AddJobSiteNoteInitial());

  @override
  Stream<AddJobSiteNoteState> mapEventToState(
    AddJobSiteNoteEvent event,
  ) async* {
    if (event is AddJobSiteDailyNote) {
      yield* _mapAddJobSiteDailyNoteToState(event);
    }
  }

  Stream<AddJobSiteNoteState> _mapAddJobSiteDailyNoteToState(AddJobSiteDailyNote event) async* {
    print('Bloc: _mapAddJobSiteDailyNoteToState');
    yield StateLoading();
    print('Bloc: after StateLoading');
    await _dataRepository.addJobSiteDailyNote(
        event.jobSiteId, event.dailyNote);
    print('Bloc: after addJobSiteDailyNote');
    yield AddJobSiteNoteStateSuccess(event.jobSiteId, event.jobSites);
    print('Bloc: after AddJobSiteNoteStateSuccess');
  }

}
