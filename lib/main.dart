import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'chew_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://go.wootly.ch/dash?source=web&id=d88f13e073d550450f4ac0d101015c3fc215fc61&sig=dL4IfhWpNk77Zz-0lnyF5A&expire=1710362801&ofs=11&usr=182711',
        //'https://service.besheger.com/movie/video/Found/s1e1.mp4',
        //'https://go.wootly.ch/dash?source=web&id=6762f1b631d2d12d0484ca13d4bcc5d1ce240399&sig=IUuYp74I9PZcjpdZAOOauQ&expire=1710358720&ofs=11&usr=182714'
        //'https://go.wootly.ch/dash?source=web&id=83bdc2c587471d48494a7659e5c1dabee74087cc&sig=sG679LRfFMklPo0xJ4EiHQ&expire=1710359019&ofs=11&usr=182719'
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Found'),
          ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: //VideoPlayer(_controller),
                  Chewie(
                controller: _chewieController,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
