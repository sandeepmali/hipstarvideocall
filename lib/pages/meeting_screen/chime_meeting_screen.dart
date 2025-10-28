import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_chime/models/join_info.model.dart';
import 'package:hipstarvideocall/pages/meeting_screen/my_meeting_view.dart';

class ChimeMeetingScreen extends StatefulWidget {
  final Map<String, dynamic> meetingData;

  const ChimeMeetingScreen({super.key, required this.meetingData});

  @override
  State<ChimeMeetingScreen> createState() => _ChimeMeetingScreenState();
}

class _ChimeMeetingScreenState extends State<ChimeMeetingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    // Restore to default when leaving
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meeting = widget.meetingData['meeting'];
    final attendee = widget.meetingData['attendee'];

    final joinInfo = JoinInfo(
      MeetingInfo.fromJson(meeting),
      AttendeeInfo.fromJson(attendee),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyMeetingView(joinInfo),
        ),
      ),
    );
  }
}
