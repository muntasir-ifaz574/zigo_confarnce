import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import '../utils/constant.dart';

final userId = Random().nextInt(1000).toString();

class VideoConferenceScreen extends StatelessWidget {
  final String conferenceID;
  const VideoConferenceScreen({Key? key, required this.conferenceID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
          appID: ZegoCloudKey.appID,
          appSign: ZegoCloudKey.appSignID,
          conferenceID: conferenceID,
          userID: userId,
          userName: "User Name: $userId",
          config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
