import 'dart:async';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/ChatEntity.dart';
import 'package:app/api/entity/CompanyEntity.dart';
import 'package:app/api/entity/MessageEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/pages/seconds/chat_page.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget{
  final UserEntity user;
  const ChatPage({required this.user,super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();

}
class _ChatPageState extends State<ChatPage>{
  final GlobalKey<_TopBar> _key = GlobalKey();
  Future<List<MessageEntity>> messages = Future.value([]);
  late Socket socket;
  final TextEditingController _controller = TextEditingController();
  bool storyLoad = false;
  String name = GlobalsWidgets.chats[3];
  int unreadChats = 0;
  @override
  void initState() {
    super.initState();
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
    List<Widget> singleMode = [
      Padding(padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            //_storis(),
            //SizedBox(height: 3.h,),
            Expanded(child: FutureBuilder(future: myChats(), builder: (context, snapshot){
              if(snapshot.hasData){
                List<ChatEntity> list = snapshot.data!;
                print("List ${list.length}");
                int temp_unread = 0;
                return ListView.separated(
                    itemBuilder: (context,index){
                      if(list[index].unread>0){
                        temp_unread++;
                      }
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _key.currentState?.methodInChild(temp_unread));
                      return _chat(list[index],_client(list[index].member1!, list[index].member2!), list[index].name, list[index].unread, list[index].lastMessage);
                    },
                    separatorBuilder:(_,__){
                      return SizedBox(height: 1.h,);
                    },
                    itemCount: list.length
                );
              }else{
                debugPrint("Error chats ${snapshot.error}");
                return const Text("Загрузка..");
              }
            })
            )
          ],
        ),),
    ];
    List<Widget> multiMode = [
      Padding(padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            //_storis(),
            //SizedBox(height: 3.h,),
            Expanded(child: FutureBuilder(future: myChats(), builder: (context, snapshot){
              if(snapshot.hasData){
                List<ChatEntity> list = snapshot.data!;
                print("List ${list.length}");
                int temp_unread = 0;
                return ListView.separated(
                    itemBuilder: (context,index){
                      if(list[index].unread>0){
                        temp_unread++;
                      }
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _key.currentState?.methodInChild(temp_unread));
                      return _chat(list[index],_client(list[index].member1!, list[index].member2!), list[index].name, list[index].unread, list[index].lastMessage);
                    },
                    separatorBuilder:(_,__){
                      return SizedBox(height: 1.h,);
                    },
                    itemCount: list.length
                );
              }else{
                debugPrint("Error chats ${snapshot.error}");
                return const Text("Загрузка..");
              }
            })
            )
          ],
        ),),
      CustomChatPage(history: true, showTitle: false, title:"Общий чат", chatName: name)
    ];

    return DefaultTabController(
        length: widget.user.role==UserRole.USER?1:2,
        child: Column(
      children: [
        TopBar(widget.user, key: _key),
        Expanded(
            child: TabBarView(
              children: widget.user.role==UserRole.USER?singleMode:multiMode,
            )
        )
      ],
    ));
  }
  UserEntity _client(UserEntity member1, UserEntity member2){
    if(member1.uid==GlobalsWidgets.uid){
      return member2;
    }else{
      return member1;
    }
  }
  Future<List<ChatEntity>> myChats() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.myChats(GlobalsWidgets.uid);
  }
  Widget _chat(ChatEntity chatEntity,UserEntity user, String chatName, int unread, MessageEntity? lastMessage){
    return InkWell(
      onTap: () async {
        if(user.role==UserRole.MANAGER){
            CompanyEntity companyEntity = await _findCompany(user.uid);
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: companyEntity.name, chatName: chatName))).then((value){
              setState(() {

              });
            });
        }else if(chatEntity.company!=null && chatEntity.company!.manager!.uid!=GlobalsWidgets.uid){
          CompanyEntity companyEntity = chatEntity.company!;
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: companyEntity.name, chatName: chatName))).then((value){
            setState(() {

            });
          });
        }else{
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>CustomChatPage(showTitle: true,title: user.name, chatName: chatName))).then((value){
              setState(() {

              });
            });
          }
        }
      },
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0xffEDEEEF),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Row(
                mainAxisAlignment: (user.role==UserRole.MANAGER || chatEntity.company!=null && chatEntity.company!.manager!.uid!=GlobalsWidgets.uid)?MainAxisAlignment.center:MainAxisAlignment.start,
                children: [
                  (user.role==UserRole.MANAGER || chatEntity.company!=null && chatEntity.company!.manager!.uid!=GlobalsWidgets.uid)?const SizedBox.shrink():ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(25), // Image radius
                      child: Image.network(GlobalsWidgets.getPhoto(user.photo), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 3.w,),
                  user.role==UserRole.MANAGER?FutureBuilder(
                      future: _findCompany(user.uid),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data!.name),
                              Text("+${snapshot.data!.phone}")
                            ],
                          );
                        }else{
                          return SizedBox.shrink();
                        }
                      }):(chatEntity.company==null || chatEntity.company!.manager!.uid==GlobalsWidgets.uid)?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${user.name} ${user.surname}"),
                      (chatEntity.company!=null && chatEntity.company!.manager!.uid==GlobalsWidgets.uid)?Text("(${chatEntity.company!.name})"):SizedBox.shrink(),
                      Text("+${user.phone}")
                    ],
                  ):Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(chatEntity.company!.name),
                      Text("+${chatEntity.company!.phone}")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(1.w),
            child: Column(
              children: [
                unread>0?Container(
                  height: Size.fromRadius(15).height,
                  width: Size.fromRadius(15).width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Center(
                    child: Text("$unread", style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600, color: Colors.white),),
                  ),
                ):const SizedBox.shrink(),
                unread<1?Container(height: const Size.fromRadius(15).height, width: const Size.fromRadius(15).width,):SizedBox.shrink(),
                SizedBox(height: 1.h,),
                lastMessage!=null?Text(DateTime.now().difference(lastMessage.time).inHours<12?DateFormat("(HH:mm)").format(lastMessage.time.toLocal()):DateFormat("(dd.MM HH:mm)").format(lastMessage.time.toLocal()),):const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<CompanyEntity> _findCompany(String uid){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findCompany(uid);
  }
  Widget _storis(){
    return SizedBox(
      height: 10.h,
      width: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            user("${GlobalsWidgets.name} (Вы)", true),
          ],
        ),
      ),
    );
  }
  Widget user(String name, bool active){
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? media = await picker.pickMedia();
        if(media!=null){
          setState(() {
            storyLoad = true;
          });
        }
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
                      storyLoad?ClipOval(
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
                      storyLoad?ClipOval(
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
      socket.off('update');
      socket.disconnect();
      socket.dispose();
      socket.close();
    }else{
      socket.off('connect');
      socket.off('disconnect');
      socket.off('read_message');
      socket.off('update');
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
      socket.on("update", (data) => setState(() {
        debugPrint("Update");
      }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  Future<void> getMessages() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    print("Uid ${GlobalsWidgets.uid} name $name");
    String id = await client.getChatId(GlobalsWidgets.uid, name);
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
class TopBar extends StatefulWidget{
  final UserEntity user;
  const TopBar(this.user,{super.key});

  @override
  State<StatefulWidget> createState() => _TopBar();
}
class _TopBar extends State<TopBar>{
  int unreadChats = 0;
  @override
  Widget build(BuildContext context) {
    List<Tab> singleList = [
      Tab(
        text: "Личные сообщения",
        icon: unreadChats>0?Container(
          height: Size.fromRadius(15).height,
          width: Size.fromRadius(15).width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
          ),
          child: Center(
            child: Text("$unreadChats", style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600, color: Colors.white),),
          ),
        ):null,
      )
    ];
    List<Tab> doubleList = [
      Tab(
        text: "Личные сообщения",
        icon: unreadChats>0?Container(
          height: Size.fromRadius(15).height,
          width: Size.fromRadius(15).width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
          ),
          child: Center(
            child: Text("$unreadChats", style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600, color: Colors.white),),
          ),
        ):null,
      ),
      const Tab(
        text: "Общий чат",
      )
    ];
    return ButtonsTabBar(
      backgroundColor: GlobalsColor.blue,
      unselectedBackgroundColor: Colors.white,
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      labelStyle:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      tabs: widget.user.role==UserRole.USER?singleList:doubleList,
    );
  }
  methodInChild(int unread) => setState(() {
    unreadChats = unread;
  });
}