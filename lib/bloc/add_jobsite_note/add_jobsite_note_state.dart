part of 'add_jobsite_note_bloc.dart';

@immutable
abstract class AddJobSiteNoteState extends Equatable {
  const AddJobSiteNoteState();
  @override
  List<Object> get props => [];
}

class AddJobSiteNoteInitial extends AddJobSiteNoteState {}

class StateLoading extends AddJobSiteNoteState {
  @override
  String toString() => 'StateLoading ';
}

class AddJobSiteNoteStateSuccess extends AddJobSiteNoteState {
  int jobSiteId;
  List<JobSite> jobSites;
  AddJobSiteNoteStateSuccess(this.jobSiteId, this.jobSites);

  @override
  List<Object> get props => [jobSiteId, jobSites];

  @override
  String toString() => 'AddJobSiteNoteStateSuccess { jobSiteID: $jobSiteId jobSites: $jobSites }';

}
