import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class ChimeMeetingService {
  ChimeMeetingService._internal();

  static final ChimeMeetingService _instance = ChimeMeetingService._internal();

  factory ChimeMeetingService() => _instance;

  final String baseUrl = "http://192.168.31.31:3000";
  final String userId = "eve.holt@reqres.in";

  Future<Map<String, dynamic>> createMeeting() async {
    final res = await http.post(
      Uri.parse('$baseUrl/createMeeting'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to create Chime meeting');
    }
  }

  Future<void> sendCandidate(String userId, RTCIceCandidate candidate) async {
    await http.post(
      Uri.parse('$baseUrl/sendCandidate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'candidate': candidate.toMap(),
        'userId': userId,
      }),
    );
  }

  Future<RTCSessionDescription> sendOffer(
    String meetingId,
    String attendeeId,
    String offerSdp,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/receiveOffer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'meetingId': meetingId,
        'attendeeId': attendeeId,
        'sdp': offerSdp,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return RTCSessionDescription(data['sdp'], data['type'] ?? 'answer');
    } else {
      throw Exception(
        'Failed to send offer. Status: ${res.statusCode}, Body: ${res.body}',
      );
    }
  }
}
