import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../theme.dart';

/// مشغل فيديو: mp4 و m3u8 (HLS) و mpd (DASH) وغيرها مما يدعمه نظام الجهاز (ExoPlayer).
class PlayerScreen extends StatefulWidget {
  final String url;
  final String title;
  const PlayerScreen({super.key, required this.url, required this.title});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final VideoPlayerController _vc;
  ChewieController? _cc;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final u = widget.url.toLowerCase();
    final VideoFormat? hint = u.contains('.m3u8')
        ? VideoFormat.hls
        : u.contains('.mpd')
            ? VideoFormat.dash
            : null;
    _vc = VideoPlayerController.networkUrl(Uri.parse(widget.url), formatHint: hint);
    try {
      await _vc.initialize();
      _cc = ChewieController(
        videoPlayerController: _vc,
        autoPlay: true,
        aspectRatio: _vc.value.aspectRatio,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        materialProgressColors: ChewieProgressColors(
          playedColor: kPrimary,
          handleColor: kPrimary,
          bufferedColor: Colors.white30,
          backgroundColor: Colors.white12,
        ),
      );
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cc?.dispose();
    _vc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Center(
        child: _cc != null
            ? Chewie(controller: _cc!)
            : _error != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70)),
                  )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
