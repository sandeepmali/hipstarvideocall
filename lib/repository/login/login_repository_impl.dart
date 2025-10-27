import 'package:hipstarvideocall/helper/logs.dart';
import 'package:hipstarvideocall/httpServices/http_client.dart';
import 'package:hipstarvideocall/repository/login/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final HttpClient httpClient = HttpClient.instance;

  LoginRepositoryImpl();

  @override
  Future<String> login(String email, String password) async {
    try {
      Logs.info('LoginRepository: Attempting login for $email');

      final data = await httpClient.post(
        'login/',
        {
          'email': email,
          'password': password,
        },
      );

      if (data.containsKey('token')) {
        Logs.info('LoginRepository: Login successful for $email');
        return data['token'];
      } else if (data.containsKey('error')) {
        Logs.error('LoginRepository: Login failed - ${data['error']}');
        throw Exception(data['error']);
      } else {
        Logs.error('LoginRepository: Unexpected response: $data');
        throw Exception('Unexpected response from server');
      }
    } on Exception catch (e) {
      Logs.error('LoginRepository: Exception during login - $e');
      rethrow;
    }
  }
}
