part of 'add_jobsite_note_bloc.dart';

@immutable
abstract class AddJobSiteNoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/*class AddChecklist extends AddChecklistEvent {
  @override
  String toString() => 'AddChecklist';
}*/

class AddJobSiteDailyNote extends AddJobSiteNoteEvent {
  final int jobSiteId;
  final List<JobSite> jobSites;
  final String dailyNote;
  
  AddJobSiteDailyNote(
      this.jobSiteId, this.jobSites, this.dailyNote);
  @override
  List<Object> get props => [jobSiteId, jobSites, dailyNote];

  @override
  String toString() => 'AddJobSitedailyNote { jobSiteId: $jobSiteId dailyNote: $dailyNote }';
}

/*class ChecklistsUpdated extends ChecklistEvent {
  final List<EmployeeCheckListSite> checklists;

  ChecklistsUpdated(this.checklists);

  @override
  List<Object> get props => [checklists];
}*/
