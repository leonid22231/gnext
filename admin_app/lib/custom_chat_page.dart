import 'dart:io';

import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/LocationEntity.dart';
import 'package:admin_app/api/entity/MessageEntity.dart';
import 'package:admin_app/api/entity/StorisEntity.dart';
import 'package:admin_app/api/entity/enums/UserRole.dart';
import 'package:admin_app/models/UserStoryModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:admin_app/api/entity/enums/StoryType.dart';
class CustomChatPage extends StatefulWidget{
  LocationEntity location;
  String title;
  String chatName;
  bool? privateMode;
  bool? subscription;
  bool? history;
  CustomChatPage({required this.location,this.privateMode,required this.title,required this.chatName,this.subscription,this.history, super.key});

  @override
  State<StatefulWidget> createState() => _CustomChatPage();
}
class _CustomChatPage extends State<CustomChatPage>{
  Future<List<MessageEntity>> messages = Future.value([]);
  List<UserStoryModel> allStories = [];
  late Socket socket;
  final TextEditingController _controller = TextEditingController();
  bool storyLoad = false;
  String name = "";
  bool privateMode = false;
  bool subscription = false;
  bool history = false;
  @override
  void initState() {
    super.initState();
    name = widget.chatName;
    getMessages();
    connectToServer();
  }
  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.privateMode!=null){
      privateMode = widget.privateMode!;
    }
    if(widget.subscription!=null){
      subscription = widget.subscription!;
    }
    if(widget.history!=null){
      history = widget.history!;
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title,style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700)),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              history?_storis():SizedBox.shrink(),
              Expanded(child: FutureBuilder(
                  future: messages,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.reversed.map((message) => InkWell(
                            // onTap: subscription?(){
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context)=>UserProfile(user: message.user,)));
                            // }:null,
                            child: ChatBubble(
                                margin: const EdgeInsets.only(bottom: 20),
                                clipper: ChatBubbleClipper1(type: _getType(message)),
                                alignment: _getAlignment(message),
                                backGroundColor: _getBackGround(message),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 70.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: _getAlignment(message)==Alignment.topRight?CrossAxisAlignment.end:CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _getAlignment(message)==Alignment.topRight?Text(
                                            DateTime.now().difference(message.time).inHours<24?DateFormat("(HH:mm)").format(message.time.toLocal()):DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 12.sp,color: _getType(message)==BubbleType.sendBubble?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6)),
                                          ):const SizedBox.shrink(),
                                          _getAlignment(message)==Alignment.topRight?SizedBox(width: 2.w,):SizedBox.shrink(),
                                          Text(
                                            (message.user.role==UserRole.USER||message.user.role==UserRole.SPECIALIST)?"${message.user.name}:":widget.title,
                                            style: TextStyle(color: _getType(message)==BubbleType.sendBubble?Colors.white:Colors.black),
                                          ),
                                          subscription&&message.user.uid!=uid&&(message.user.role!=UserRole.ADMIN&&message.user.role!=UserRole.MANAGER)?SizedBox(width: 2.w,):const SizedBox.shrink(),
                                          subscription&&message.user.uid!=uid&&(message.user.role!=UserRole.ADMIN&&message.user.role!=UserRole.MANAGER)?Icon(Icons.person, color: mainColor,):SizedBox.shrink(),
                                          _getAlignment(message)==Alignment.topLeft?SizedBox(width: 2.w,):const SizedBox.shrink(),
                                          _getAlignment(message)==Alignment.topLeft?Text(
                                            DateTime.now().difference(message.time).inHours<24?DateFormat("(HH:mm)").format(message.time.toLocal()):DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 12.sp,color: _getType(message)==BubbleType.sendBubble?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6)),
                                          ):const SizedBox.shrink()
                                        ],
                                      ),
                                      Text(
                                        message.content,
                                        style: TextStyle(color: _getType(message)==BubbleType.sendBubble?Colors.white:Colors.black),
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          )).toList(),
                        ),
                      );
                    }else{
                      print("Error ${snapshot.error}");
                      return Text("Загрузка...");
                    }
                  })),
              !privateMode?SizedBox(
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
                        borderSide: BorderSide(color: border)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: border)
                    ),
                  ),
                ),
              ):const SizedBox.shrink()
            ],
          ),
        )
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
            if(storis[i].user.uid.contains(uid)){
              currentUserStories.add(storis[i]);
            }else{
              list[index].story.add(storis[i]);
            }
          }else{
            if(storis[i].user.uid.contains(uid)){
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
        List<Widget> widgets = [
          currentUser("${name} (Вы)", currentUserStories.isEmpty),
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
    return client.getStoris(uid ,name);
  }
  Widget currentUser(String name, bool active){
    return InkWell(
      // onLongPress: !active?(){
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context)=>StoryViewPage(usersStory: allStories)));
      // }:null,
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
                        String id = await client.getChatId(uid, widget.chatName);
                        print("ID ${id}");
                        client.addStory(id, uid, StoryType.PHOTO, file).then((value){
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
                        String id = await client.getChatId(uid, widget.chatName);
                        print("ID ${id}");
                        client.addStory(id, uid, StoryType.PHOTO, file).then((value){
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
                        String id = await client.getChatId(uid, widget.chatName);
                        client.addStory(id, uid, StoryType.VIDEO, file).then((value){
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
                        String id = await client.getChatId(uid, widget.chatName);
                        client.addStory(id, uid, StoryType.VIDEO, file).then((value){
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
                          child: Image.network(getUserPhoto(), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  !storyLoad&&active?Container(
                    height: 2.h,
                    width: 2.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: mainColor
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
                        String id = await client.getChatId(uid, widget.chatName);
                        print("ID ${id}");
                        client.addStory(id, uid, StoryType.PHOTO, file).then((value){

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
                        String id = await client.getChatId(uid, widget.chatName);
                        client.addStory(id, uid, StoryType.VIDEO, file).then((value){

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
                          child: Image.network(getUserPhoto(), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  !storyLoad&&active?Container(
                    height: 2.h,
                    width: 2.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: mainColor
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
    if(message.user.uid.contains(uid)){
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
      print("Connect to room ${name}");
      OptionBuilder optionBuilder = OptionBuilder();
      Map<String, dynamic> opt = optionBuilder
          .disableAutoConnect()
          .setTransports(["websocket"])
          .setQuery({
        "room": name,
        "uid": uid
      }).build();
      opt.addAll({
        "forceNew": true
      });
      socket = io('http://${ip}:8081', opt);
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
    print("Uid ${uid} name $name");
    setState(() {
      messages = client.getMessagesByLocation(widget.location.country.id, widget.location.city.id,widget.chatName);
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