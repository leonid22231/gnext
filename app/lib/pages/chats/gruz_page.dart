import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/MessageEntity.dart';
import 'package:app/api/entity/StorisEntity.dart';
import 'package:app/api/entity/enums/StoryType.dart';
import 'package:app/pages/models/UserStoryModel.dart';
import 'package:app/pages/story_view.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GruzPage extends StatefulWidget{
  const GruzPage({super.key});

  @override
  State<StatefulWidget> createState() => _GruzPageState();
}
class _GruzPageState extends State<GruzPage>{
  Future<List<MessageEntity>> messages = Future.value([]);
  late Socket socket;
  final TextEditingController _controller = TextEditingController();
  bool storyLoad = false;
  String chat_name = GlobalsWidgets.chats[4];
  List<UserStoryModel> allStories = [];
  @override
  void initState() {
    super.initState();
    getMessages();
    getStories();
    connectToServer();
  }
  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _storis(),
          Expanded(child: FutureBuilder(
              future: messages,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  print(snapshot.data);
                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.reversed.map((message) => ChatBubble(
                          margin: const EdgeInsets.only(bottom: 20),
                          clipper: ChatBubbleClipper1(type: _getType(message)),
                          alignment: _getAlignment(message),
                          backGroundColor: _getBackGround(message),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 70.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${message.user.name}:",
                                  style: TextStyle(color: _getType(message)==BubbleType.sendBubble?Colors.white:Colors.black),
                                ),
                                Text(
                                  message.content,
                                  style: TextStyle(color: _getType(message)==BubbleType.sendBubble?Colors.white:Colors.black),
                                )
                              ],
                            ),
                          )
                      )).toList(),
                    ),
                  );
                }else{
                  print("Message Error ${snapshot.error}");
                  return Text("Загрузка...");
                }
              })),
          SizedBox(
            height: 7.h,
            width: double.maxFinite,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Введите сообщение",
                hintStyle: TextStyle(fontSize: 16.sp),
                suffixIcon: InkWell(
                  onTap: (){
                    print("Send message");
                    if(_controller.value.text.isNotEmpty && _controller.value.text.replaceAll(" ", "").isNotEmpty){
                      sendMessage();
                    }
                  },
                  child: Icon(Icons.send),
                ),
                contentPadding: EdgeInsets.only(left: 5.w).copyWith(top: 2.h, bottom: 2.h),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: GlobalsColor.border)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: GlobalsColor.border)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _storis(){
    return FutureBuilder(future: getStories(), builder: (context, snapshot){
      allStories = [];
      if(snapshot.hasData){
        List<UserStoryModel> list = [];
        List<StorisEntity> storis = snapshot.data!;
        List<StorisEntity> currentUserStories = [];
        for(int i = 0; i < storis.length; i++){
          bool exist = false;
          int index = 0;
          for(int j = 0; j < list.length; j++){
            if(list[j].user!.uid.contains(storis[i].user.uid)){
              exist = true;
              index = j;
              break;
            }
          }
          if(exist){
            if(storis[i].user.uid.contains(GlobalsWidgets.uid)){
              currentUserStories.add(storis[i]);
            }else{
              list[index].story.add(storis[i]);
            }
          }else{
            if(storis[i].user.uid.contains(GlobalsWidgets.uid)){
              currentUserStories.add(storis[i]);
            }else{
              UserStoryModel userStoryModel = UserStoryModel();
              userStoryModel.user = storis[i].user;
              userStoryModel.story.add(storis[i]);
              list.add(userStoryModel);
            }
          }
        }
        if(currentUserStories.isNotEmpty){
          storyLoad = true;
          UserStoryModel userStoryModel = UserStoryModel();
          userStoryModel.user = currentUserStories.first.user;
          userStoryModel.story = currentUserStories;
          allStories.add(
              userStoryModel
          );
        }
        print("List l ${list.length}");
        allStories.addAll(
            list
        );
        for(int i = 0; i > allStories.length; i++){
          list[i].index = i;
        }
        List<Widget> widgets = [
          currentUser("${GlobalsWidgets.name} (Вы)", currentUserStories.isEmpty),
        ];
        widgets.addAll(list.map((e) => user(e.user!.name, false, true)).toList());
        return SizedBox(
          height: 12.h,
          width: double.maxFinite,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              },
              itemCount: widgets.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 2.w,);
              },
            ),
          ),
        );
      }else{
        return Text("Загрузка...");
      }
    });
  }
  Future<List<StorisEntity>> getStories(){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getStoris(GlobalsWidgets.uid ,chat_name);
  }
  Widget currentUser(String name, bool active){
    return InkWell(
      onLongPress: !active?(){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>StoryViewPage(usersStory: allStories)));
      }:null,
      onTap: () async {
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("Добавить историю"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);
                        print("Media ${image!.name}");
                        File file = File.fromUri(Uri.parse(image.path));
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
                        print("ID ${id}");
                        client.addStory(id, GlobalsWidgets.uid, StoryType.PHOTO, file).then((value){
                          setState(() {

                          });
                          Navigator.pop(context);
                        }).onError((error, stackTrace){
                          print("Error image ${error}");
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white
                      ),
                      child: Text("Фото", style: TextStyle(color: Color(0xff317EFA)),)),

                ),
                SizedBox(height: 1.h,),
                SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.camera);
                        print("Media ${image!.name}");
                        File file = File.fromUri(Uri.parse(image.path));
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
                        print("ID ${id}");
                        client.addStory(id, GlobalsWidgets.uid, StoryType.PHOTO, file).then((value){
                          setState(() {

                          });
                          Navigator.pop(context);
                        }).onError((error, stackTrace){
                          print("Error image ${error}");
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white
                      ),
                      child: Text("Фото (Камера)", style: TextStyle(color: Color(0xff317EFA)),)),

                ),
                SizedBox(height: 2.h,),
                SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
                        print("Media ${video!.name}");
                        File file = File.fromUri(Uri.parse(video.path));
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
                        client.addStory(id, GlobalsWidgets.uid, StoryType.VIDEO, file).then((value){
                          setState(() {

                          });
                          Navigator.pop(context);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white
                      ),
                      child: const Text("Видео", style: TextStyle(color: Color(0xff317EFA)),)),

                ),
                SizedBox(height: 1.h,),
                SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? video = await picker.pickVideo(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
                        print("Media ${video!.name}");
                        File file = File.fromUri(Uri.parse(video.path));
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
                        client.addStory(id, GlobalsWidgets.uid, StoryType.VIDEO, file).then((value){
                          setState(() {

                          });
                          Navigator.pop(context);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white
                      ),
                      child: const Text("Видео (Камера)", style: TextStyle(color: Color(0xff317EFA)),)),

                )
              ],
            ),
          );
        });
      },
      child: Row(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(29), // Image radius
                          child: Container(
                            decoration: BoxDecoration(
                                color: !storyLoad?Colors.transparent:null,
                                gradient: storyLoad?const LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Color(0xffee2a7b),
                                      Colors.blueAccent
                                    ]
                                ):null
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(27), // Image radius
                          child: Container(
                            color: storyLoad?Colors.white:Colors.transparent,
                          ),
                        ),
                      ),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(25), // Image radius
                          child: Image.network(GlobalsWidgets.getUserPhoto(), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  !storyLoad&&active?Container(
                    height: 2.h,
                    width: 2.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: GlobalsColor.blue
                    ),
                    child: Align(alignment: Alignment.center,child: Icon(Icons.add, color: Colors.white,size: 2.h,),),
                  ):SizedBox.shrink()
                ],
              ),
              Text(name)
            ],
          ),
          SizedBox(width: 2.w,)
        ],
      ),
    );
  }
  Widget user(String name, bool active,bool current){
    return InkWell(
      onTap: !current?() async {
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("Добавить историю"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        print("Media ${image!.name}");
                        File file = File.fromUri(Uri.parse(image.path));
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
                        print("ID ${id}");
                        client.addStory(id, GlobalsWidgets.uid, StoryType.PHOTO, file).then((value){

                        }).onError((error, stackTrace){
                          print("Error image ${error}");
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white
                      ),
                      child: Text("Фото", style: TextStyle(color: Color(0xff317EFA)),)),

                ),
                SizedBox(height: 2.h,),
                SizedBox(
                  width: double.maxFinite,
                  height: 5.h,
                  child: OutlinedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
                        print("Media ${video!.name}");
                        File file = File.fromUri(Uri.parse(video.path));
                        Dio dio = Dio();
                        RestClient client = RestClient(dio);
                        String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
                        client.addStory(id, GlobalsWidgets.uid, StoryType.VIDEO, file).then((value){

                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white
                      ),
                      child: Text("Видео", style: TextStyle(color: Color(0xff317EFA)),)),

                )
              ],
            ),
          );
        });
      }:null,
      child: Row(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      storyLoad||current?ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(29), // Image radius
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Color(0xffee2a7b),
                                      Colors.blueAccent
                                    ]

                                )
                            ),
                          ),
                        ),
                      ):SizedBox.shrink(),
                      storyLoad||current?ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(27), // Image radius
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ):SizedBox.shrink(),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(25), // Image radius
                          child: Image.network(GlobalsWidgets.getUserPhoto(), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  !storyLoad&&active?Container(
                    height: 2.h,
                    width: 2.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: GlobalsColor.blue
                    ),
                    child: Align(alignment: Alignment.center,child: Icon(Icons.add, color: Colors.white,size: 2.h,),),
                  ):SizedBox.shrink()
                ],
              ),
              Text(name)
            ],
          ),
          SizedBox(width: 2.w,)
        ],
      ),
    );
  }
  Color _getBackGround(MessageEntity message){
    BubbleType type = _getType(message);
    if(type == BubbleType.sendBubble){
      return const Color(0xff317EFA);
    }else{
      return const Color(0xffF8F8FA);
    }
  }
  Alignment _getAlignment(MessageEntity message){
    BubbleType type = _getType(message);
    if(type == BubbleType.sendBubble){
      return Alignment.topRight;
    }else{
      return Alignment.topLeft;
    }
  }
  BubbleType _getType(MessageEntity message){
    if(message.user.uid.contains(GlobalsWidgets.uid)){
      return BubbleType.sendBubble;
    }else{
      return BubbleType.receiverBubble;
    }
  }
  void disconnectFromServer(){
    if(socket.active){
      socket.off('connect');
      socket.off('disconnect');
      socket.off('read_message');
      socket.disconnect();
      socket.dispose();
      socket.close();
    }else{
      socket.off('connect');
      socket.off('disconnect');
      socket.off('read_message');
      socket.dispose();
      socket.close();
    }
  }
  void connectToServer() {
    try {
      print("Connect to room ${chat_name}");
      OptionBuilder optionBuilder = OptionBuilder();
      Map<String, dynamic> opt = optionBuilder
          .disableAutoConnect()
          .setTransports(["websocket"])
          .setQuery({
        "room": chat_name,
        "uid": GlobalsWidgets.uid
      }).build();
      opt.addAll({
        "forceNew": true
      });
      socket = io('http://${GlobalsWidgets.ip}:8081', opt);
      socket.connect();
      socket.on('connect', (_){
        debugPrint("Connect");
      });
      socket.on('disconnect', (_){
        debugPrint("Disconnect");
      });
      socket.on("read_message", (data) async {
        getMessages();
        setState(() {

        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  Future<void> getMessages() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    print("Uid ${GlobalsWidgets.uid} name $chat_name");
    String id = await client.getChatId(GlobalsWidgets.uid, chat_name);
    print("ChatId $id");
    setState(() {
      messages = client.getMessages(GlobalsWidgets.uid,id);
    });
  }

  Future<void> sendMessage() async {
    print("Send");
    socket.emit("send_message", {
      "content":_controller.value.text
    });
    _controller.clear();
    getMessages();
    setState(() {

    });
  }
}