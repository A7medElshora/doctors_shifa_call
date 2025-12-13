import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgoraService {
  final String _baseUrl =
      'https://185.135.137.90:5000'; // Assuming the server is running on this IP and port 5000

  Future<Map<String, dynamic>> getToken(String channelName, String uid) async {
    final url = Uri.parse('$_baseUrl/token?channel=$channelName&uid=$uid');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load token: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching token: $e');
      rethrow;
    }
  }

  Future<RtcEngine> initializeEngine(String appId) async {
    RtcEngine engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    return engine;
  }
}
