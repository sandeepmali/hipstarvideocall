import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/httpServices/http_client.dart';
import 'package:hipstarvideocall/pages/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'bloc/login/login_screen_bloc.dart';
import 'bloc/user_list/user_list_cubit.dart';
import 'helper/logs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HttpClient singleton
  HttpClient.init(baseUrl: 'https://reqres.in/api');
  Logs.init(isDebug: true);
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
        BlocProvider<UserListCubit>(
          create: (_) => UserListCubit(),
        ),
      ],
      child: const MeetifyApp(),
    ),
  );
}

class MeetifyApp extends StatelessWidget {
  const MeetifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meetify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
