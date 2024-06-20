import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWrapper extends StatefulWidget {
  final String? mediaPath;

  const VideoPlayerWrapper({super.key, required this.mediaPath});

  @override
  State<VideoPlayerWrapper> createState() => _VideoPlayerWrapperState();
}

class _VideoPlayerWrapperState extends State<VideoPlayerWrapper> {
  static const Duration maxVideoDuration = Duration(seconds: 15);

  final ScreenUtil screenUtil = ScreenUtil();

  late final VideoPlayerController videoPlayerController;

  bool initialized = false;

  @override
  void initState() {
    if (widget.mediaPath?.isEmpty ?? true) {
      throw Exception('Media path cannot be empty');
    }

    videoPlayerController = VideoPlayerController.file(File(widget.mediaPath!));
    videoPlayerController.initialize().whenComplete(() {
      videoPlayerController.play();

      if (videoPlayerController.value.duration > maxVideoDuration) {
        videoPlayerController.addListener(maxDurationListener);
      } else {
        videoPlayerController.setLooping(true);
      }

      setState(() => initialized = true);
    });

    super.initState();
  }

  void maxDurationListener() {
    if (videoPlayerController.value.position >= maxVideoDuration) {
      videoPlayerController.seekTo(Duration.zero);
      videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenUtil.screenWidth,
      child: FittedBox(
        fit: BoxFit.cover,
        child: initialized
            ? SizedBox(
                width: videoPlayerController.value.size.width,
                height: videoPlayerController.value.size.height,
                child: VideoPlayer(videoPlayerController),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.removeListener(maxDurationListener);
    videoPlayerController.dispose();

    super.dispose();
  }
}
