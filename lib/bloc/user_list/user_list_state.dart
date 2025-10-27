import 'package:hipstarvideocall/models/user_list/user_model.dart';

abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserModel> users;
  final bool fromCache;

  UserListLoaded({required this.users, this.fromCache = false});
}

class UserListError extends UserListState {
  final String message;
  UserListError({required this.message});
}

class MeetingJoining extends UserListState {}

class MeetingJoined extends UserListState {
  final Map<String, dynamic> meetingData;
  MeetingJoined(this.meetingData);
}

class MeetingJoinError extends UserListState {
  final String message;
  MeetingJoinError(this.message);
}
