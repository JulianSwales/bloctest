part of 'checklist_bloc.dart';

@immutable
abstract class ChecklistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChecklists extends ChecklistEvent {
  @override
  String toString() => 'LoadChecklists';
}

class AddChecklist extends ChecklistEvent {
  final int jobSiteValue;
  final int equipmentValue;
  final DateTime dateValue;
  final List list;
  
  AddChecklist(
      this.jobSiteValue, this.equipmentValue, this.dateValue, this.list);
  @override
  List<Object> get props => [jobSiteValue, equipmentValue, dateValue, list];

  @override
  String toString() => 'AddChecklists';
}

class ChecklistsUpdated extends ChecklistEvent {
  final List<EmployeeCheckListSite> checklists;

  ChecklistsUpdated(this.checklists);

  @override
  List<Object> get props => [checklists];
}
