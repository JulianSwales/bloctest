import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:bloctest/class/checklist_repository.dart';

import 'package:bloctest/models/employee_checklist_bloc.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final ChecklistRepository _checklistRepository;
  StreamSubscription _checklistSubscription;

  ChecklistBloc({@required ChecklistRepository checklistRepository})
      : assert(checklistRepository != null),
        _checklistRepository = checklistRepository,
        super(ChecklistInitial());

  @override
  Stream<ChecklistState> mapEventToState(
    ChecklistEvent event,
  ) async* {
    if (event is LoadChecklists) {
      yield* _mapLoadChecklistToState();
    } else if (event is AddChecklist) {
      yield* _mapAddChecklistToState(event);
    } else if (event is ChecklistsUpdated) {
      yield* _mapChecklistsUpdatedToState(event);
    }
  }

  Stream<ChecklistState> _mapLoadChecklistToState() async* {
    print('Stream: _mapLoadChecklistToState');
    _checklistSubscription?.cancel();
    _checklistSubscription = _checklistRepository.checklists().listen(
          (checklists) => add(ChecklistsUpdated(checklists)),
        );
  }

  Stream<ChecklistState> _mapAddChecklistToState(AddChecklist event) async* {
    print('Bloc: _mapAddChecklistToState');
    await _checklistRepository.addNewChecklist(
        event.jobSiteValue, event.equipmentValue, event.dateValue, event.list);
  }

  Stream<ChecklistState> _mapChecklistsUpdatedToState(
      ChecklistsUpdated event) async* {
    yield ChecklistsLoaded(event.checklists);
  }

  @override
  Future<void> close() {
    _checklistSubscription?.cancel();
    return super.close();
  }
}
