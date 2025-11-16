import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctors_shifa_call/core/helpers/extensions.dart'; // Assuming this extension exists
import 'package:doctors_shifa_call/features/video_call/presentation/cubits/agora_cubit.dart';
// Assuming the target project uses easy_localization and has these keys
import 'package:doctors_shifa_call/generated/locale_keys.g.dart'; 
import 'package:easy_localization/easy_localization.dart';

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
      create: (context) => AgoraCubit()..connect(userId, channelName),
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
          // You can show a toast or snackbar here for status messages
          debugPrint('Agora Status: ${state.statusMessage}');
        }
      },
      builder: (context, state) {
        final cubit = context.read<AgoraCubit>();

        if (state.engine == null || !state.isConnected) {
          return Scaffold(
            appBar: AppBar(title: Text(LocaleKeys.video_call.tr())),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 20.h),
                  Text(state.statusMessage ?? LocaleKeys.connecting.tr()),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              // 1. Remote Video (Full Screen)
              if (state.remoteUid != null && state.remoteUid! > 0)
                Positioned.fill(
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: state.engine!,
                      canvas: VideoCanvas(uid: state.remoteUid!),
                      connection: RtcConnection(channelId: state.channelId!),
                    ),
                  ),
                )
              else
                Center(
                  child: Text(
                    LocaleKeys.waiting_for_other_user.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

              // 2. Local Video (Small Overlay)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100.w,
                  height: 150.h,
                  margin: EdgeInsets.fromLTRB(10.w, 40.h, 10.w, 10.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: state.localVideoEnabled
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: state.engine!,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.videocam_off, color: Colors.white),
                        ),
                ),
              ),

              // 3. Control Buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mute/Unmute
                      FloatingActionButton(
                        heroTag: 'mute',
                        onPressed: cubit.toggleMute,
                        backgroundColor: state.localAudioEnabled ? Colors.white : Colors.red,
                        child: Icon(
                          state.localAudioEnabled ? Icons.mic : Icons.mic_off,
                          color: state.localAudioEnabled ? Colors.blue : Colors.white,
                        ),
                      ),
                      // End Call
                      FloatingActionButton(
                        heroTag: 'end',
                        onPressed: () {
                          cubit.disconnect();
                          // Assuming the target project uses a navigation extension like 'pop'
                          // If not, it should be Navigator.of(context).pop();
                          context.pop(); 
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.call_end, color: Colors.white),
                      ),
                      // Toggle Camera
                      FloatingActionButton(
                        heroTag: 'camera',
                        onPressed: cubit.toggleCamera,
                        backgroundColor: state.localVideoEnabled ? Colors.white : Colors.red,
                        child: Icon(
                          state.localVideoEnabled ? Icons.videocam : Icons.videocam_off,
                          color: state.localVideoEnabled ? Colors.blue : Colors.white,
                        ),
                      ),
                      // Switch Camera
                      FloatingActionButton(
                        heroTag: 'switch',
                        onPressed: cubit.switchCamera,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.switch_camera, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
