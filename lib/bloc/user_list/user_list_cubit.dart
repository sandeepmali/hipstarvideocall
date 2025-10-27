import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/bloc/user_list/user_list_state.dart';
import 'package:hipstarvideocall/helper/logs.dart';
import 'package:hipstarvideocall/preferances/user_local_data_source.dart';
import 'package:hipstarvideocall/repository/user_list/user_repository_impl.dart';
import 'package:hipstarvideocall/services/aws_chime/chime_meeting_service.dart';

class UserListCubit extends Cubit<UserListState> {
  late final UserRepositoryImpl _repository;
  late final UserLocalDataSource _localDataSource;
  final ChimeMeetingService _chimeService = ChimeMeetingService();

  List<dynamic> latestUsers = [];
  Map<String, dynamic>? meetingData;

  UserListCubit() : super(UserListInitial()) {
    _localDataSource = UserLocalDataSource.instance;
    _repository = UserRepositoryImpl(localDataSource: _localDataSource);
  }

  Future<void> loadUsers({int page = 1}) async {
    emit(UserListLoading());

    try {
      final cachedUsers = await _localDataSource.getCachedUsers();
      if (cachedUsers != null && cachedUsers.isNotEmpty) {
        latestUsers = cachedUsers;
        emit(UserListLoaded(users: cachedUsers, fromCache: true));
      }

      final remoteUsers = await _repository.getUsers(page: page);
      if (remoteUsers.isNotEmpty) {
        latestUsers = remoteUsers;
        await _localDataSource.cacheUsers(remoteUsers);
        emit(UserListLoaded(users: remoteUsers, fromCache: false));
      } else {
        emit(UserListError(message: 'No users found.'));
      }
    } catch (e) {
      Logs.error('UserListCubit: Error loading users - $e');
      emit(UserListError(message: e.toString()));
    }
  }

  Future<void> joinMeeting() async {
    emit(MeetingJoining());
    try {
      meetingData = await _chimeService.createMeeting();
      emit(MeetingJoined(meetingData!));
    } catch (e) {
      emit(MeetingJoinError(e.toString()));
    }
  }
}
