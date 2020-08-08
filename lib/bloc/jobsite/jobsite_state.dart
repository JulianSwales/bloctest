part of 'jobsite_bloc.dart';

class JobSiteState {
  const JobSiteState({
    @required this.jobSites,
    @required this.jobSite,
    @required this.jobSiteNotes,
  });

  final List<JobSite> jobSites;
  final int jobSite;
  final List<JobSiteNote> jobSiteNotes;

  const JobSiteState.initial()
      : this(
          jobSites: const <JobSite>[],
          jobSite: null,
          jobSiteNotes: const <JobSiteNote>[],
        );

  const JobSiteState.jobSiteLoadInProgress()
      : this(
          jobSites: const <JobSite>[],
          jobSite: null,
          jobSiteNotes: const <JobSiteNote>[],
        );
        
  const JobSiteState.jobSiteLoadSuccess({@required List<JobSite> jobSites})
      : this(
          jobSites: jobSites,
          jobSite: null,
          jobSiteNotes: const <JobSiteNote>[],
        );

  const JobSiteState.jobSiteNotesLoadInProgress({
    @required List<JobSite> jobSites,
    @required int jobSite,
  }) : this(
          jobSites: jobSites,
          jobSite: jobSite,
          jobSiteNotes: const <JobSiteNote>[],
        );

  const JobSiteState.jobSiteNotesLoadSuccess({
    @required List<JobSite> jobSites,
    @required int jobSite,
    @required List<JobSiteNote> jobSiteNotes,
  }) : this(
          jobSites: jobSites,
          jobSite: jobSite,
          jobSiteNotes: jobSiteNotes,
        );

  JobSiteState copyWith({
    List<JobSite> jobSites,
    int jobSite,
    List<JobSiteNote> jobSiteNotes,
  }) {
    return JobSiteState(
      jobSites: jobSites ?? this.jobSites,
      jobSite: jobSite ?? this.jobSite,
      jobSiteNotes: jobSiteNotes ?? this.jobSiteNotes,
    );
  }
}

class JobSiteNoteInitial extends JobSiteState {}
