import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/bloc/user_list/user_list_cubit.dart';
import 'package:hipstarvideocall/bloc/user_list/user_list_state.dart';
import 'package:hipstarvideocall/pages/meeting_screen/chime_meeting_screen.dart';
import 'package:hipstarvideocall/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _initPermissions(); // Request permissions at screen load
  }

  /// Request camera, mic & storage permissions
  Future<void> _initPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    final granted = statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted;

    if (granted) {
      setState(() => _permissionsGranted = true);
    } else {
      setState(() => _permissionsGranted = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Camera & Microphone permissions are required.\nPlease enable them in Settings.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserListCubit()
        ..loadUsers()
        ..joinMeeting(), // Fetch users + meeting data on load
      child: BlocConsumer<UserListCubit, UserListState>(
        listener: (context, state) {
          if (state is MeetingJoinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserListCubit>();
          final isLoading = state is UserListLoading || state is MeetingJoining;
          final users = cubit.latestUsers;

          return Scaffold(
            backgroundColor: AppColors.loginBackground,
            appBar: AppBar(
              title: const Text('Online Users'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    cubit.loadUsers();
                    cubit.joinMeeting();
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                if (state is UserListError)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 10),
                        Text(state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            cubit.loadUsers();
                            cubit.joinMeeting();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (users.isNotEmpty)
                  RefreshIndicator(
                    onRefresh: () async {
                      await cubit.loadUsers();
                      await cubit.joinMeeting();
                    },
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.avatar),
                                ),
                                title: Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(user.email),
                                trailing: const Icon(Icons.video_call,
                                    color: Colors.green),
                                onTap: () {
                                  if (!_permissionsGranted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please allow camera & mic permissions from Settings.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (cubit.meetingData != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChimeMeetingScreen(
                                          meetingData: cubit.meetingData!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Meeting not ready yet. Please wait...'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                else if (!isLoading)
                    const Center(child: Text('No users found.')),

                if (isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
