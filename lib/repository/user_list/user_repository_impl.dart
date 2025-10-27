import 'package:hipstarvideocall/helper/logs.dart';
import 'package:hipstarvideocall/httpServices/http_client.dart';
import 'package:hipstarvideocall/models/user_list/user_model.dart';
import 'user_repository.dart';
import 'package:hipstarvideocall/preferances/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpClient httpClient = HttpClient.instance;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  /// Fetch users from remote API or fallback to local cache
  @override
  Future<List<UserModel>> getUsers({int page = 1}) async {
    try {
      Logs.info('UserRepositoryImpl: Fetching users for page $page');

      // Fetch from remote
      final data = await httpClient.get('users?page=$page');

      if (data.containsKey('data')) {
        final List<dynamic> usersData = data['data'];
        final users = usersData.map((e) => UserModel.fromJson(e)).toList();

        Logs.info('UserRepositoryImpl: Fetched ${users.length} users from remote');

        // Cache locally
        await localDataSource.cacheUsers(users);

        return users;
      } else {
        Logs.error('UserRepositoryImpl: Invalid response format: $data');
        throw Exception('Invalid response format from server');
      }
    } catch (e) {
      Logs.error('UserRepositoryImpl: Exception during fetchUsers - $e');

      // Fallback to local cache
      final cachedUsers = await localDataSource.getCachedUsers();
      if (cachedUsers != null && cachedUsers.isNotEmpty) {
        Logs.info('UserRepositoryImpl: Returning ${cachedUsers.length} users from cache');
        return cachedUsers;
      }

      rethrow;
    }
  }
}
