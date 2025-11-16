import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:doctors_shifa_call/core/services/agora_service.dart';

// State
class AgoraState {
  final RtcEngine? engine;
  final bool isConnected;
  final String? statusMessage;
  final String? channelId;
  final int? remoteUid;
  final bool localVideoEnabled;
  final bool localAudioEnabled;
  final bool isJoined;

  AgoraState({
    this.engine,
    this.isConnected = false,
    this.statusMessage,
    this.channelId,
    this.remoteUid,
    this.localVideoEnabled = true,
    this.localAudioEnabled = true,
    this.isJoined = false,
  });

  AgoraState copyWith({
    RtcEngine? engine,
    bool? isConnected,
    String? statusMessage,
    String? channelId,
    int? remoteUid,
    bool? localVideoEnabled,
    bool? localAudioEnabled,
    bool? isJoined,
  }) {
    return AgoraState(
      engine: engine ?? this.engine,
      isConnected: isConnected ?? this.isConnected,
      statusMessage: statusMessage ?? this.statusMessage,
      channelId: channelId ?? this.channelId,
      remoteUid: remoteUid ?? this.remoteUid,
      localVideoEnabled: localVideoEnabled ?? this.localVideoEnabled,
      localAudioEnabled: localAudioEnabled ?? this.localAudioEnabled,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}

// Cubit
class AgoraCubit extends Cubit<AgoraState> {
  // NOTE: Replace with your actual Agora App ID
  // The App ID is hardcoded in the reference project, I will keep it for now, 
  // but it should ideally be loaded from a secure source like environment variables or remote config.
  static const String appId = 'b06bf3d27812421e864cf85d527f8d89'; 
  final AgoraService _agoraService = AgoraService();

  AgoraCubit() : super(AgoraState());

  void _updateStatus(String message) {
    emit(state.copyWith(statusMessage: message));
  }

  Future<void> connect(String userId, String channelName) async {
    if (state.isConnected) return;

    _updateStatus('Connecting to channel "$channelName" as $userId...');

    // 1. Request Permissions
    try {
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (cameraStatus != PermissionStatus.granted ||
          micStatus != PermissionStatus.granted) {
        _updateStatus(
            'Permissions denied. Please grant camera and microphone access.');
        return;
      }
    } catch (e) {
      _updateStatus('Error requesting permissions: $e');
      return;
    }

    // 2. Initialize Engine
    try {
      final engine = await _agoraService.initializeEngine(appId);
      emit(state.copyWith(engine: engine, channelId: channelName));
      _setupEngineCallbacks(engine);
    } catch (e) {
      _updateStatus('Error initializing Agora engine: $e');
      return;
    }

    // 3. Get Token and Join Channel
    try {
      _updateStatus('Fetching token...');
      // The user wants the room name to be auto-populated from the API.
      // The channelName is passed from the booking card, which will be derived from the API data.
      final tokenData = await _agoraService.getToken(channelName, userId);
      final token = tokenData['token'];
      
      _updateStatus('Joining channel...');
      await state.engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: 0, // Use 0 for auto-assigned UID
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
      emit(state.copyWith(isConnected: true));
    } catch (e) {
      _updateStatus('Error joining channel: $e');
      await disconnect();
    }
  }

  void _setupEngineCallbacks(RtcEngine engine) {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          emit(state.copyWith(isJoined: true, statusMessage: 'Joined channel successfully.'));
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("remote user $remoteUid joined");
          emit(state.copyWith(remoteUid: remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("remote user $remoteUid left");
          if (state.remoteUid == remoteUid) {
            emit(state.copyWith(remoteUid: null));
          }
          _updateStatus('User $remoteUid left the channel.');
        },
        onLeaveChannel: (connection, stats) {
          debugPrint("local user ${connection.localUid} left");
          emit(state.copyWith(isJoined: false, remoteUid: null));
        },
        onError: (err, msg) {
          debugPrint('Agora Error: $err, $msg');
          _updateStatus('Agora Error: $msg');
        },
      ),
    );
  }

  Future<void> disconnect() async {
    if (state.engine != null) {
      await state.engine!.leaveChannel();
      await state.engine!.release();
      emit(AgoraState(statusMessage: 'Disconnected.'));
    }
  }

  void toggleMute() {
    if (state.engine != null) {
      final newMuteState = !state.localAudioEnabled;
      state.engine!.muteLocalAudioStream(newMuteState);
      emit(state.copyWith(localAudioEnabled: !newMuteState));
    }
  }

  void toggleCamera() {
    if (state.engine != null) {
      final newCameraState = !state.localVideoEnabled;
      state.engine!.enableLocalVideo(newCameraState);
      emit(state.copyWith(localVideoEnabled: newCameraState));
    }
  }

  void switchCamera() {
    if (state.engine != null) {
      state.engine!.switchCamera();
    }
  }

  @override
  Future<void> close() {
    disconnect();
    return super.close();
  }
}
