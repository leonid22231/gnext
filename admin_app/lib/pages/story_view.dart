import 'package:admin_app/api/entity/enums/StoryType.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:admin_app/models/UserStoryModel.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:story/story_image.dart';
import 'package:story/story_page_view.dart';
import 'package:video_player/video_player.dart';

class StoryViewPage extends StatefulWidget{
  final List<UserStoryModel> usersStory;
  final int? index;
  const StoryViewPage({required this.usersStory,this.index, super.key});

  @override
  State<StatefulWidget> createState() => _StoryViewPage();
}
class _StoryViewPage extends State<StoryViewPage>{
  late VideoPlayerController _controller;
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  bool init = false;
  Duration storyDuration = const Duration(seconds: 15);
  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(IndicatorAnimationCommand.pause);
  }
  @override
  void dispose() {
    indicatorAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<UserStoryModel> users = widget.usersStory;
    return Scaffold(
      body: StoryPageView(
        indicatorAnimationController: indicatorAnimationController,
        indicatorDuration: storyDuration,
        initialPage: widget.index??0,
        itemBuilder: (context, pageIndex, storyIndex) {
          final user = users[pageIndex].user!;
          final story = users[pageIndex].story[storyIndex];
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black),
              ),
              story.type==StoryType.PHOTO?Positioned.fill(
                child: StoryImage(
                  key: ValueKey(story.content),
                  loadingBuilder: (_,__,___){
                    if(___==null){
                      indicatorAnimationController.value = IndicatorAnimationCommand.resume;
                      return __;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  imageProvider: NetworkImage(
                    getStoryPhoto(story.content),
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ):Positioned.fill(
                child: FutureBuilder(
                  future: restartController(story.content),
                  builder: (context, snapshot){
                   if(snapshot.connectionState == ConnectionState.done){
                     return StoryImage(
                         key: ValueKey(story.content),
                         fit: BoxFit.fitWidth,
                         loadingBuilder: (_,__,___){
                           if(___==null){
                             indicatorAnimationController.value = IndicatorAnimationCommand.resume;
                             return FutureBuilder(
                               future: _controller.initialize(),
                               builder: (context, snapshot){
                                 if (snapshot.connectionState == ConnectionState.done) {
                                   WidgetsBinding.instance.addPostFrameCallback((_) {
                                     _controller.play();
                                   });
                                   return VideoPlayer(_controller);
                                 } else {
                                   return const Center(
                                     child: CircularProgressIndicator(),
                                   );
                                 }
                               },
                             );
                           }
                           return const Center(
                             child: CircularProgressIndicator(),
                           );
                         },
                         imageProvider: const NetworkImage(
                           "https://source.unsplash.com/random/200x200?sig=1",
                         )
                     );
                   }else{
                     return Text(S.of(context).loading);
                   }

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44, left: 8),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(getPhoto(user.photo)),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        pageLength: users.length,
        storyLength: (int pageIndex) {
          return users[pageIndex].story.length;
        },
        onPageLimitReached: () {
          Navigator.pop(context);
        },
      ),
    );
  }
Future<void> restartController(String content) async {
      if(init){
        await _controller.dispose();
      }


    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        getStoryVideo(content),
      ),
    );
      init = true;
}
}