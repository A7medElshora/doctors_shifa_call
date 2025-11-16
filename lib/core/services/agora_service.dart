import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgoraService {
  // The user provided a separate backend server for token generation.
  // The base URL for the token server.
  // NOTE: This IP is from the reference project. The user should replace it with their actual server IP.
  final String _baseUrl = 'http://138.199.239.20:5000'; 

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
