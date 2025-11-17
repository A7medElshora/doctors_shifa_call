import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:doctors_shifa_call/core/services/agora_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

// State (بدون تغيير)
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
  static const String appId = '5aec2ab98801443988fedf8149eee82c'; 
  final AgoraService _agoraService = AgoraService();

  AgoraCubit() : super(AgoraState());

  void _updateStatus(String message) {
    emit(state.copyWith(statusMessage: message));
  }

  Future<void> connect(String userId, String channelName) async {
    if (state.isConnected) return;

    // تحقق من المدخلات
    if (channelName.isEmpty || userId.isEmpty) {
      _updateStatus('خطأ: اسم القناة أو UID فارغ.');
      return;
    }

    _updateStatus('جاري الاتصال بالقناة "$channelName" كـ $userId...');

    // 1. Request Permissions
    try {
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (cameraStatus != PermissionStatus.granted ||
          micStatus != PermissionStatus.granted) {
        _updateStatus(
            'تم رفض الإذن. يرجى منح صلاحيات الكاميرا والميكروفون.');
        return;
      }
    } catch (e) {
      _updateStatus('خطأ في طلب الإذن: $e');
      return;
    }

    // 2. Initialize Engine
    try {
      final engine = await _agoraService.initializeEngine(appId);
      
      // إضافة: تمكين الفيديو والصوت صراحة لتجنب الشاشة البيضاء
      await engine.enableVideo();
      await engine.enableAudio();
      
      emit(state.copyWith(engine: engine, channelId: channelName));
      _setupEngineCallbacks(engine);
    } catch (e) {
      _updateStatus('خطأ في تهيئة محرك Agora: $e');
      return;
    }

    // 3. Get Token and Join Channel
    try {
      _updateStatus('جاري جلب التوكن...');
      final tokenData = await _agoraService.getToken(channelName, userId);
      
      // تحقق من الاستجابة
      if (tokenData.isEmpty || !tokenData.containsKey('token')) {
        throw Exception('استجابة التوكن غير صالحة: ${tokenData.toString()}');
      }
      
      final token = tokenData['token'] as String;
      
      _updateStatus('جاري الانضمام للقناة...');
      
      // تعديل: استخدم userId كـ UID (حوله إلى int إن أمكن)، وأضف تحذيراً إذا كان 0
      final uid = int.tryParse(userId) ?? 0;
      if (uid == 0) {
        debugPrint('تحذير: UID غير رقمي، سيتم استخدام UID تلقائي (0)');
      }
      
      await state.engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,  // UID = userId (مثل 0 إذا لم يكن رقمياً)
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
      
      // إضافة جديدة: تمكين مراقبة حجم الصوت للتحقق من الكتم (مع البارامترات المطلوبة)
      await state.engine!.enableAudioVolumeIndication(
        interval: 200,  // كل 200ms
        smooth: 3,      // عامل التنعيم (1-10)
        reportVad: true // تمكين كشف نشاط الصوت
      );
      
      emit(state.copyWith(isConnected: true));
    } catch (e) {
      debugPrint('فشل في جلب التوكن أو الانضمام: $e');
      _updateStatus('خطأ في الانضمام للقناة: $e');
      await disconnect();
    }
  }

  void _setupEngineCallbacks(RtcEngine engine) {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("المستخدم المحلي ${connection.localUid} انضم");
          emit(state.copyWith(isJoined: true, statusMessage: 'تم الانضمام للقناة بنجاح.'));
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("المستخدم البعيد $remoteUid انضم");
          emit(state.copyWith(remoteUid: remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) async {
          debugPrint("المستخدم البعيد $remoteUid غادر");
          if (state.remoteUid == remoteUid) {
            emit(state.copyWith(remoteUid: null));
            _updateStatus('غادر المستخدم $remoteUid القناة. إنهاء المكالمة...');
            // تعديل: أضف تأخيراً قصيراً (2 ثوانٍ) قبل الإنهاء لتجنب المفاجآت
            await Future.delayed(const Duration(seconds: 2));
            await disconnect();
          }
        },
        onLeaveChannel: (connection, stats) {
          debugPrint("غادر المستخدم المحلي ${connection.localUid}");
          emit(state.copyWith(isJoined: false, remoteUid: null));
        },
        onError: (err, msg) {
          debugPrint('خطأ Agora: $err, $msg');
          _updateStatus('خطأ Agora: $msg');
        },
        // إضافة جديدة: مراقبة حجم الصوت للتحقق من الكتم (مع البارامترات الكاملة)
        onAudioVolumeIndication: (RtcConnection connection, List<AudioVolumeInfo> speakers, int speakerNumber, int totalVolume) {
          debugPrint('حجم الصوت: $totalVolume (عدد المتحدثين: $speakerNumber)');  // لو 0 بعد الكتم، معناها نجح
          // إذا كان هناك متحدث محلي، يمكن طباعة تفاصيل إضافية
          if (speakers.isNotEmpty) {
            final localSpeaker = speakers.firstWhere(
              (info) => info.uid == connection.localUid,
              orElse: () => speakers[0],
            );
            debugPrint('حجم الصوت المحلي: ${localSpeaker.volume}');
          }
        },
      ),
    );
  }

  Future<void> disconnect() async {
    if (state.engine != null) {
      await state.engine!.leaveChannel();
      await state.engine!.release();
      emit(AgoraState(statusMessage: 'تم الإفصاح عن الاتصال.'));
    }
  }

  // تعديل كامل: إصلاح المنطق للكتم المحلي فقط، مع توافق مع الواجهة
  void toggleMute() {
    if (state.engine == null) {
      _updateStatus('المحرك غير متاح.');
      return;
    }
    try {
      // قلب الحالة: localAudioEnabled = true (مفعل) → false (مُكْتَم)
      final newAudioEnabled = !state.localAudioEnabled;
      // تطبيق على المحلي فقط (لا تكتم البعيد)
      state.engine!.enableLocalAudio(newAudioEnabled);  // مفعل/معطل التقاط الصوت
      state.engine!.muteLocalAudioStream(!newAudioEnabled);  // كتم الإرسال إذا مُكْتَم
      // إصدار الحدث الجديد
      emit(state.copyWith(localAudioEnabled: newAudioEnabled));
      _updateStatus(newAudioEnabled ? 'تم تشغيل الصوت' : 'تم كتم الصوت');
    } catch (e) {
      debugPrint('خطأ في تبديل الصوت: $e');
      _updateStatus('خطأ في تبديل الصوت: $e');
    }
  }

  // تعديل: أضف try-catch للأمان
  void toggleCamera() {
    if (state.engine == null) {
      _updateStatus('المحرك غير متاح.');
      return;
    }
    try {
      final newCameraState = !state.localVideoEnabled;
      state.engine!.enableLocalVideo(newCameraState);
      emit(state.copyWith(localVideoEnabled: newCameraState));
      _updateStatus(newCameraState ? 'تم تشغيل الكاميرا' : 'تم إغلاق الكاميرا');
    } catch (e) {
      debugPrint('خطأ في تبديل الكاميرا: $e');
      _updateStatus('خطأ في تبديل الكاميرا: $e');
    }
  }

  void switchCamera() {
    if (state.engine == null) {
      _updateStatus('المحرك غير متاح.');
      return;
    }
    try {
      state.engine!.switchCamera();
      _updateStatus('تم تبديل الكاميرا');
    } catch (e) {
      debugPrint('خطأ في تبديل الكاميرا: $e');
      _updateStatus('خطأ في تبديل الكاميرا: $e');
    }
  }

  @override
  Future<void> close() {
    disconnect();
    return super.close();
  }
}