import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoURL;
  final String thumbnail;
  const VideoPlayerItem(
      {super.key, required this.videoURL, required this.thumbnail});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool isLoading = true;
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((value) {
        setState(() {
          isLoading = false;
        });
        setState(() {});
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          videoPlayerController.value.isPlaying
              ? videoPlayerController.pause()
              : videoPlayerController.play();
        });
      },
      child: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  VideoPlayer(videoPlayerController),
                  !videoPlayerController.value.isPlaying
                      ? const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 70,
                            color: Colors.white60,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
