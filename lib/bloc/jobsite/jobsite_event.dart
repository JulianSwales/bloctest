part of 'jobsite_bloc.dart';

@immutable
abstract class JobSiteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class JobSiteInitial extends JobSiteEvent {
  @override
  String toString() => 'JobSiteInitial';
}

class JobSiteFormLoaded extends JobSiteEvent {
  @override
  String toString() => 'JobSiteFormLoaded';
}

class JobSiteChanged extends JobSiteEvent {
  final int jobSiteId;

  JobSiteChanged(
      this.jobSiteId,);
  @override
  List<Object> get props => [jobSiteId,];

  @override
  String toString() => 'JobSiteChanged $jobSiteId ';
}

class JobSiteAddNoteChanged extends JobSiteEvent {
  final int jobSiteId;
  final List<JobSite> jobSites;

  JobSiteAddNoteChanged(
      this.jobSiteId, this.jobSites);
  @override
  List<Object> get props => [jobSiteId,jobSites,];

  @override
  String toString() => 'JobSiteAddNoteChanged { jobSite: $jobSiteId jobSites: $jobSites }';
}
