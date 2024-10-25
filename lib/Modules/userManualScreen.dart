



import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../Resource/Colors/app_colors.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';

class userManualScreen extends StatefulWidget {
  String vurl;

  userManualScreen(this.vurl);

  @override
  State<userManualScreen> createState() => _userManualScreenState();
}

class _userManualScreenState extends State<userManualScreen> {
  bool scroll = true;
  String vendorVideoUrl = '';

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    // Call the method to fetch video URL and initialize video player
    getUserName();
  }

  @override
  void dispose() {
    // Dispose video player and chewie controllers to release resources
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  getUserName() async {
    vendorVideoUrl = widget.vurl;

    // Ensure that the video URL exists
    if (vendorVideoUrl.isNotEmpty) {
      // Initialize the VideoPlayerController
      _videoPlayerController = VideoPlayerController.network(vendorVideoUrl);

      // Assign the future to initialize the video player controller
      _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
        // Initialize the Chewie controller
        _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: false,
            looping: false,
            allowFullScreen: true,  // Enable fullscreen button
            fullScreenByDefault: false,
            deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            ],
            deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            ],);
        setState(() {}); // Update the UI after initialization
      });
    } else {
      // Handle the case where video URL is not available
      print('Vendor video URL is not available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: SingleChildScrollView(
        child: Container(
          color: appcolors.whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: appcolors.screenBckColor,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  'User Manual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appcolors.primaryColor,
                  ),
                  maxLines: 2,
                ),
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Chewie(controller: _chewieController);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
