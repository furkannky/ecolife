import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // Chrome/Safari WebView politikalarından dolayı otomatik oynatma hatasını engeller!
        mute: false,
        showLiveFullscreenButton: false,
        disableDragSeek: false,
        enableCaption: true,
        useHybridComposition: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.green.shade700,
        progressColors: const ProgressBarColors(
          playedColor: Colors.green,
          handleColor: Colors.greenAccent,
        ),
        onReady: () {
          _controller.addListener(() {});
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ders Videosu", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green.shade800,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
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