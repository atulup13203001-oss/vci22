import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late String videoUrl;
  late String title;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    videoUrl = args['url'] as String;
    title = args['title'] as String;
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl) ?? '';
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        autoPlay: true,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadVideoById(videoId: videoId);
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Column(
        children: [
          YoutubePlayerScaffold(
            controller: _controller,
            aspectRatio: 16 / 9,
            builder: (context, player) => player,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
