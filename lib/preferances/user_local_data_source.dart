// lib/data/datasources/user_local_data_source.dart
import 'dart:convert';
import 'package:hipstarvideocall/models/user_list/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDataSource {
  static const _cacheKey = 'cached_users';

  // Singleton instance
  static final UserLocalDataSource _instance = UserLocalDataSource._internal();

  // Private constructor
  UserLocalDataSource._internal();

  // Public getter to access the instance
  static UserLocalDataSource get instance => _instance;

  /// Cache users to SharedPreferences
  Future<void> cacheUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((user) => user.toJson()).toList();
    await prefs.setString(_cacheKey, json.encode(jsonList));
  }

  /// Get cached users from SharedPreferences
  Future<List<UserModel>?> getCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);

    if (cachedData != null && cachedData.isNotEmpty) {
      final List<dynamic> decoded = json.decode(cachedData);
      return decoded.map((e) => UserModel.fromJson(e)).toList();
    }
    return null;
  }

  /// Clear cached users
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
