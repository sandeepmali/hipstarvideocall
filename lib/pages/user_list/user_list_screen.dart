import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/bloc/user_list/user_list_cubit.dart';
import 'package:hipstarvideocall/bloc/user_list/user_list_state.dart';
import 'package:hipstarvideocall/pages/meeting_screen/chime_meeting_screen.dart';
import 'package:hipstarvideocall/utils/colors.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserListCubit()
        ..loadUsers()
        ..joinMeeting(), // 🔹 Fetch meeting data at screen load
      child: BlocConsumer<UserListCubit, UserListState>(
        listener: (context, state) {
          if (state is MeetingJoined) {
            // Meeting data ready (fetched once at screen load)
            // No need to navigate here automatically.
          } else if (state is MeetingJoinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserListCubit>();

          final isLoading = state is UserListLoading || state is MeetingJoining;

          // ❌ Error while loading users
          if (state is UserListError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Online Users')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
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
              ),
            );
          }

          // ✅ Users loaded or joining meeting
          final users = cubit.latestUsers;

          return Scaffold(
            backgroundColor: AppColors.loginBackground,
            appBar: AppBar(
              title: const Text('Online Users'),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                if (users.isNotEmpty)
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
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(user.email),
                                trailing: const Icon(Icons.video_call,
                                    color: Colors.green),
                                onTap: () {
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

                // 🔄 Unified overlay loader
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
