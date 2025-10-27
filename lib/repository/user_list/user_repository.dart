import 'package:hipstarvideocall/models/user_list/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers({int page = 1});
}
