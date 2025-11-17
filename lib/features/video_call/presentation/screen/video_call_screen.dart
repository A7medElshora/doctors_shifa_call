import 'dart:ui';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctors_shifa_call/core/helpers/extensions.dart';
import 'package:doctors_shifa_call/features/video_call/presentation/cubits/agora_cubit.dart';

class VideoCallScreen extends StatelessWidget {
  final String channelName;
  final String userId;

  const VideoCallScreen({
    super.key,
    required this.channelName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AgoraCubit()..connect(userId, channelName),
      child: const _VideoCallView(),
    );
  }
}

class _VideoCallView extends StatelessWidget {
  const _VideoCallView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgoraCubit, AgoraState>(
      listener: (context, state) {
        if (state.statusMessage != null) {
          debugPrint('Agora: ${state.statusMessage}');
        }
      },
      builder: (context, state) {
        final cubit = context.read<AgoraCubit>();

        if (state.engine == null || !state.isConnected) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20.h),
                  Text(
                    "Connecting...",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              // Fullscreen Remote Video
              Positioned.fill(
                child: state.remoteUid != null
                    ? AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: state.engine!,
                          canvas: VideoCanvas(uid: state.remoteUid!),
                          connection:
                              RtcConnection(channelId: state.channelId!),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Waiting for patient to join...",
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
              ),

              // Dark Transparent Overlay
              Container(
                color: Colors.black.withOpacity(0.25),
              ),

              // Local video container (Glass Style)
              Positioned(
                top: 50.h,
                left: 15.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: 120.w,
                      height: 170.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: state.localVideoEnabled
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: state.engine!,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.videocam_off,
                                color: Colors.white,
                                size: 32.sp,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              // Bottom Controls
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _roundButton(
                      active: state.localAudioEnabled,
                      activeColor: Colors.white,
                      icon: state.localAudioEnabled ? Icons.mic_off : Icons.mic,  // mic_off عند المفعل (للكتم)، mic عند المُكْتَم (للاستئناف)
                      onPressed: () {
                        cubit.toggleMute();  // تنفيذ التبديل بين mute/unmute
                      },
                      activeIconColor: Colors.blue,
                      inactiveIconColor: Colors.white,
                    ),
                    _roundButton(
                      isEndButton: true,
                      icon: Icons.call_end,
                      onPressed: () {
                        cubit.disconnect();
                        context.pop();
                      },
                    ),
                    _roundButton(
                      active: state.localVideoEnabled,
                      activeColor: Colors.white,
                      icon: state.localVideoEnabled
                          ? Icons.videocam
                          : Icons.videocam_off,
                      onPressed: cubit.toggleCamera,
                      activeIconColor: Colors.blue,
                      inactiveIconColor: Colors.white,
                    ),
                    _roundButton(
                      icon: Icons.switch_camera,
                      onPressed: cubit.switchCamera,
                      activeColor: Colors.white,
                      activeIconColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// --- Reusable Button Widget (Modern UI) ---
  Widget _roundButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool active = true,
    bool isEndButton = false,
    Color activeColor = Colors.white,
    Color activeIconColor = Colors.blue,
    Color inactiveIconColor = Colors.white,
  }) {
    return Container(
      width: 65.w,
      height: 65.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEndButton
            ? Colors.red
            : (active ? activeColor : Colors.red),  // أحمر عند الكتم للتحذير
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 30.sp,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isEndButton
              ? Colors.white
              : (active ? activeIconColor : inactiveIconColor),
        ),
      ),
    );
  }
}