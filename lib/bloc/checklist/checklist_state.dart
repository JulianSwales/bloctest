part of 'checklist_bloc.dart';

@immutable
abstract class ChecklistState extends Equatable {

  const ChecklistState();
  @override
  List<Object> get props => [];

}

class ChecklistInitial extends ChecklistState {}

class ChecklistsLoaded extends ChecklistState {
  final List<dynamic> checkLists;

  ChecklistsLoaded(this.checkLists);

  @override
  List<Object> get props => [checkLists];

  @override
  String toString() => 'ChecklistsLoaded { displayName: $checkLists }';
}

class ChecklistsLoading extends ChecklistState {
  @override
  String toString() => 'ChecklistsLoading';
}

class ChecklistsLoadFailure extends ChecklistState {
  @override
  String toString() => 'ChecklistsLoadFailure';
}
/*class AuthenticationSuccessEmployee extends AuthenticationState {
  final String displayName;

  AuthenticationSuccessEmployee(this.displayName);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Authenticated Employee { displayName: $displayName }';
}
class AuthenticationFailure extends AuthenticationState {
  @override
  String toString() => 'AuthenticationFailure';
}*/
