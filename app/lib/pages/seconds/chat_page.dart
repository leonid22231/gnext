import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/MessageEntity.dart';
import 'package:app/api/entity/StorisEntity.dart';
import 'package:app/api/entity/enums/MessageType.dart';
import 'package:app/api/entity/enums/StoryType.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/pages/models/UserStoryModel.dart';
import 'package:app/pages/seconds/user_profile.dart';
import 'package:app/pages/story_view.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:voice_message_package/voice_message_package.dart';

class CustomChatPage extends StatefulWidget {
  final String title;
  final String chatName;
  final bool? subscription;
  final bool? history;
  final bool? companyChat;
  final bool showTitle;
  final UserRole? readOnlyUser;
  final Function(int count)? onUpdate;
  const CustomChatPage(
      {this.companyChat,
      this.onUpdate,
      this.readOnlyUser,
      required this.showTitle,
      required this.title,
      required this.chatName,
      this.subscription,
      this.history,
      super.key});

  @override
  State<StatefulWidget> createState() => _CustomChatPage();
}

class _CustomChatPage extends State<CustomChatPage> {
  Future<List<MessageEntity>> messages = Future.value([]);
  late final RecorderController recorderController;
  List<UserStoryModel> allStories = [];
  late Socket socket;
  final TextEditingController _controller = TextEditingController();
  bool storyLoad = false;
  String name = "";
  bool subscription = false;
  bool history = false;
  bool showTitle = true;
  UserRole? readOnlyUser;
  bool audio = true;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  @override
  void initState() {
    super.initState();
    _initialiseControllers();
    name = widget.chatName;
    getMessages();
    connectToServer();
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC_HE_V2
      ..sampleRate = 44100;
  }

  @override
  void dispose() {
    disconnectFromServer();
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnlyUser != null) {
      readOnlyUser = widget.readOnlyUser!;
    }
    if (widget.subscription != null) {
      subscription = widget.subscription!;
    }
    if (widget.history != null) {
      history = widget.history!;
    }
    showTitle = widget.showTitle;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: showTitle
            ? AppBar(
                centerTitle: true,
                title: Text(widget.title,
                    style: TextStyle(
                        fontSize: 22.sp, fontWeight: FontWeight.w700)),
              )
            : null,
        body: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              history ? _storis() : const SizedBox.shrink(),
              Expanded(
                  child: FutureBuilder(
                      future: messages,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              reverse: true,
                              children: snapshot.data!
                                  .map((message) => Column(
                                        children: [
                                          message.type == MessageType.USER
                                              ? InkWell(
                                                  onTap: subscription &&
                                                          (message.user.role !=
                                                                  UserRole
                                                                      .ADMIN &&
                                                              message.user
                                                                      .role !=
                                                                  UserRole
                                                                      .MANAGER)
                                                      ? () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UserProfile(
                                                                            user:
                                                                                message.user,
                                                                          )));
                                                        }
                                                      : null,
                                                  child: ChatBubble(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 20),
                                                      clipper:
                                                          ChatBubbleClipper1(
                                                              type: _getType(
                                                                  message)),
                                                      alignment: _getAlignment(
                                                          message),
                                                      backGroundColor:
                                                          _getBackGround(
                                                              message),
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: 70.w,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: _getAlignment(
                                                                      message) ==
                                                                  Alignment
                                                                      .topRight
                                                              ? CrossAxisAlignment
                                                                  .end
                                                              : CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                _getAlignment(
                                                                            message) ==
                                                                        Alignment
                                                                            .topRight
                                                                    ? Text(
                                                                        DateTime.now().difference(message.time).inHours <
                                                                                12
                                                                            ? DateFormat("(HH:mm)").format(message.time.toLocal())
                                                                            : DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontSize: 12
                                                                                .sp,
                                                                            color: _getType(message) == BubbleType.sendBubble
                                                                                ? Colors.white.withOpacity(0.6)
                                                                                : Colors.black.withOpacity(0.6)),
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink(),
                                                                _getAlignment(
                                                                            message) ==
                                                                        Alignment
                                                                            .topRight
                                                                    ? SizedBox(
                                                                        width:
                                                                            2.w,
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink(),
                                                                Text(
                                                                  (message.user.role == UserRole.USER ||
                                                                          message.user.role ==
                                                                              UserRole
                                                                                  .SPECIALIST ||
                                                                          (message.user.uid == GlobalsWidgets.uid &&
                                                                              message.user.role == UserRole.MANAGER))
                                                                      ? "${message.user.name}:"
                                                                      : message.user.role == UserRole.MANAGER
                                                                          ? message.user.name
                                                                          : widget.title,
                                                                  style: TextStyle(
                                                                      color: _getType(message) ==
                                                                              BubbleType
                                                                                  .sendBubble
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                                subscription &&
                                                                        message.user.uid !=
                                                                            GlobalsWidgets
                                                                                .uid &&
                                                                        (message.user.role != UserRole.ADMIN &&
                                                                            message.user.role !=
                                                                                UserRole
                                                                                    .MANAGER)
                                                                    ? SizedBox(
                                                                        width:
                                                                            2.w,
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink(),
                                                                subscription &&
                                                                        message.user.uid !=
                                                                            GlobalsWidgets
                                                                                .uid &&
                                                                        (message.user.role != UserRole.ADMIN &&
                                                                            message.user.role !=
                                                                                UserRole
                                                                                    .MANAGER)
                                                                    ? Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: GlobalsColor
                                                                            .blue,
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink(),
                                                                _getAlignment(
                                                                            message) ==
                                                                        Alignment
                                                                            .topLeft
                                                                    ? SizedBox(
                                                                        width:
                                                                            2.w,
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink(),
                                                                _getAlignment(
                                                                            message) ==
                                                                        Alignment
                                                                            .topLeft
                                                                    ? Text(
                                                                        DateTime.now().difference(message.time).inHours <
                                                                                12
                                                                            ? DateFormat("(HH:mm)").format(message.time.toLocal())
                                                                            : DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontSize: 12
                                                                                .sp,
                                                                            color: _getType(message) == BubbleType.sendBubble
                                                                                ? Colors.white.withOpacity(0.6)
                                                                                : Colors.black.withOpacity(0.6)),
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink()
                                                              ],
                                                            ),
                                                            Text(
                                                              message.content,
                                                              style: TextStyle(
                                                                  color: _getType(
                                                                              message) ==
                                                                          BubbleType
                                                                              .sendBubble
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                )
                                              : message.type ==
                                                      MessageType.AUDIO
                                                  ? InkWell(
                                                      onTap: subscription &&
                                                              (message.user
                                                                          .role !=
                                                                      UserRole
                                                                          .ADMIN &&
                                                                  message.user
                                                                          .role !=
                                                                      UserRole
                                                                          .MANAGER)
                                                          ? () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          UserProfile(
                                                                            user:
                                                                                message.user,
                                                                          )));
                                                            }
                                                          : null,
                                                      child: ChatBubble(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20),
                                                          clipper:
                                                              ChatBubbleClipper1(
                                                                  type: _getType(
                                                                      message)),
                                                          alignment: _getAlignment(
                                                              message),
                                                          backGroundColor:
                                                              _getBackGround(
                                                                  message),
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxWidth: double
                                                                  .maxFinite,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: _getAlignment(
                                                                          message) ==
                                                                      Alignment
                                                                          .topRight
                                                                  ? CrossAxisAlignment
                                                                      .end
                                                                  : CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topRight
                                                                        ? Text(
                                                                            DateTime.now().difference(message.time).inHours < 12
                                                                                ? DateFormat("(HH:mm)").format(message.time.toLocal())
                                                                                : DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(fontSize: 12.sp, color: _getType(message) == BubbleType.sendBubble ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6)),
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topRight
                                                                        ? SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                    Text(
                                                                      (message.user.role == UserRole.USER ||
                                                                              message.user.role == UserRole.SPECIALIST ||
                                                                              (message.user.uid == GlobalsWidgets.uid && message.user.role == UserRole.MANAGER))
                                                                          ? "${message.user.name}:"
                                                                          : widget.title,
                                                                      style: TextStyle(
                                                                          color: _getType(message) == BubbleType.sendBubble
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                    subscription &&
                                                                            message.user.uid !=
                                                                                GlobalsWidgets.uid &&
                                                                            (message.user.role != UserRole.ADMIN && message.user.role != UserRole.MANAGER)
                                                                        ? SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                    subscription &&
                                                                            message.user.uid !=
                                                                                GlobalsWidgets.uid &&
                                                                            (message.user.role != UserRole.ADMIN && message.user.role != UserRole.MANAGER)
                                                                        ? Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                GlobalsColor.blue,
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topLeft
                                                                        ? SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topLeft
                                                                        ? Text(
                                                                            DateTime.now().difference(message.time).inHours < 12
                                                                                ? DateFormat("(HH:mm)").format(message.time.toLocal())
                                                                                : DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(fontSize: 12.sp, color: _getType(message) == BubbleType.sendBubble ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6)),
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink()
                                                                  ],
                                                                ),
                                                                VoiceMessageView(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  activeSliderColor:
                                                                      GlobalsColor
                                                                          .blue,
                                                                  innerPadding:
                                                                      1.w,
                                                                  circlesColor:
                                                                      GlobalsColor
                                                                          .blue,
                                                                  controller:
                                                                      VoiceController(
                                                                    audioSrc:
                                                                        "http://${GlobalsWidgets.ip}:8080/api/v1/chat/audio/${message.content}",
                                                                    maxDuration:
                                                                        const Duration(
                                                                            days:
                                                                                1),
                                                                    isFile:
                                                                        false,
                                                                    onComplete:
                                                                        () {},
                                                                    onPause:
                                                                        () {},
                                                                    onPlaying:
                                                                        () {},
                                                                    onError:
                                                                        (err) {},
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  : InkWell(
                                                      onTap: subscription &&
                                                              (message.user
                                                                          .role !=
                                                                      UserRole
                                                                          .ADMIN &&
                                                                  message.user
                                                                          .role !=
                                                                      UserRole
                                                                          .MANAGER)
                                                          ? () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          UserProfile(
                                                                            user:
                                                                                message.user,
                                                                          )));
                                                            }
                                                          : null,
                                                      child: ChatBubble(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20),
                                                          clipper:
                                                              ChatBubbleClipper1(
                                                                  type: _getType(
                                                                      message)),
                                                          alignment: _getAlignment(
                                                              message),
                                                          backGroundColor:
                                                              _getBackGround(
                                                                  message),
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: 70.w,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: _getAlignment(
                                                                          message) ==
                                                                      Alignment
                                                                          .topRight
                                                                  ? CrossAxisAlignment
                                                                      .end
                                                                  : CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topRight
                                                                        ? Text(
                                                                            DateTime.now().difference(message.time).inHours < 12
                                                                                ? DateFormat("(HH:mm)").format(message.time.toLocal())
                                                                                : DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(fontSize: 12.sp, color: _getType(message) == BubbleType.sendBubble ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6)),
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topRight
                                                                        ? SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                    Text(
                                                                      (message.user.role == UserRole.USER ||
                                                                              message.user.role == UserRole.SPECIALIST ||
                                                                              (message.user.uid == GlobalsWidgets.uid && message.user.role == UserRole.MANAGER))
                                                                          ? "${message.user.name}:"
                                                                          : widget.title,
                                                                      style: TextStyle(
                                                                          color: _getType(message) == BubbleType.sendBubble
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                    subscription &&
                                                                            message.user.uid !=
                                                                                GlobalsWidgets.uid &&
                                                                            (message.user.role != UserRole.ADMIN && message.user.role != UserRole.MANAGER)
                                                                        ? SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                    subscription &&
                                                                            message.user.uid !=
                                                                                GlobalsWidgets.uid &&
                                                                            (message.user.role != UserRole.ADMIN && message.user.role != UserRole.MANAGER)
                                                                        ? Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                GlobalsColor.blue,
                                                                          )
                                                                        : const SizedBox.shrink(),
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topLeft
                                                                        ? SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                    _getAlignment(message) ==
                                                                            Alignment
                                                                                .topLeft
                                                                        ? Text(
                                                                            DateTime.now().difference(message.time).inHours < 12
                                                                                ? DateFormat("(HH:mm)").format(message.time.toLocal())
                                                                                : DateFormat("(dd.MM HH:mm)").format(message.time.toLocal()),
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(fontSize: 12.sp, color: _getType(message) == BubbleType.sendBubble ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6)),
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink()
                                                                  ],
                                                                ),
                                                                Image.network(
                                                                    GlobalsWidgets
                                                                        .getPhoto(
                                                                            message.content)),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                          SizedBox(
                                            height: 1.h,
                                          )
                                        ],
                                      ))
                                  .toList(),
                            ),
                          );
                        } else {
                          debugPrint("Error ${snapshot.error}");
                          return const Text("Загрузка...");
                        }
                      })),
              readOnlyUser != null && readOnlyUser == GlobalsWidgets.role
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isRecording
                              ? AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(50.w, 50),
                                  recorderController: recorderController,
                                  waveStyle: const WaveStyle(
                                    waveColor: Colors.white,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: const Color(0xFF1E1B26),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                )
                              : Container(
                                  width: 100.w - 25.w,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1B26),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  //margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: TextField(
                                    readOnly: false,
                                    style: const TextStyle(color: Colors.white),
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: S.of(context).text,
                                      hintStyle: const TextStyle(
                                          color: Colors.white54),
                                      border: InputBorder.none,
                                      prefixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      S.of(context).add_photo),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: double.maxFinite,
                                                        height: 5.h,
                                                        child: OutlinedButton(
                                                            onPressed:
                                                                () async {
                                                              final ImagePicker
                                                                  picker =
                                                                  ImagePicker();
                                                              final XFile? image = await picker.pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .gallery,
                                                                  preferredCameraDevice:
                                                                      CameraDevice
                                                                          .rear);
                                                              debugPrint(
                                                                  "Media ${image!.name}");
                                                              File file = File
                                                                  .fromUri(Uri
                                                                      .parse(image
                                                                          .path));
                                                              Dio dio = Dio();
                                                              RestClient
                                                                  client =
                                                                  RestClient(
                                                                      dio);
                                                              client
                                                                  .fileMessage(
                                                                      GlobalsWidgets
                                                                          .uid,
                                                                      widget
                                                                          .chatName,
                                                                      MessageType
                                                                          .PHOTO,
                                                                      file)
                                                                  .then(
                                                                      (value) {
                                                                getMessages();
                                                                Navigator.pop(
                                                                    context);
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                debugPrint(
                                                                    "Error image $error");
                                                              });
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                                side: BorderSide
                                                                    .none,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white),
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .photo,
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xff317EFA)),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      SizedBox(
                                                        width: double.maxFinite,
                                                        height: 5.h,
                                                        child: OutlinedButton(
                                                            onPressed:
                                                                () async {
                                                              final ImagePicker
                                                                  picker =
                                                                  ImagePicker();
                                                              final XFile?
                                                                  image =
                                                                  await picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.camera);
                                                              debugPrint(
                                                                  "Media ${image!.name}");
                                                              File file = File
                                                                  .fromUri(Uri
                                                                      .parse(image
                                                                          .path));
                                                              Dio dio = Dio();
                                                              RestClient
                                                                  client =
                                                                  RestClient(
                                                                      dio);
                                                              client
                                                                  .fileMessage(
                                                                      GlobalsWidgets
                                                                          .uid,
                                                                      widget
                                                                          .chatName,
                                                                      MessageType
                                                                          .PHOTO,
                                                                      file)
                                                                  .then(
                                                                      (value) {
                                                                getMessages();
                                                                Navigator.pop(
                                                                    context);
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                debugPrint(
                                                                    "Error image $error");
                                                              });
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                                side: BorderSide
                                                                    .none,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white),
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .photo_,
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xff317EFA)),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(
                                          isRecording
                                              ? Icons.refresh
                                              : Icons.photo_camera_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _refreshWave,
                                        icon: Icon(
                                          isRecording
                                              ? Icons.refresh
                                              : Icons.send,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                        SizedBox(width: 1.w),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _startOrStopRecording,
                          icon: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            size: 8.w,
                          ),
                          color: Colors.black,
                        ),
                      ],
                    )
            ],
          ),
        ));
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();
        var path = await recorderController.stop(false);
        debugPrint(path);
        File file = File(path!);
        debugPrint("Recorded file size: ${file.lengthSync()}");
        Dio dio = Dio();
        RestClient client = RestClient(dio);
        client
            .fileMessage(
                GlobalsWidgets.uid, widget.chatName, MessageType.AUDIO, file)
            .then((value) {
          getMessages();
        });
      } else {
        await recorderController.record(
            androidEncoder: AndroidEncoder.he_aac,
            bitRate: 128000,
            sampleRate: 16000); // Path is optional
      }
    } catch (e) {
      debugPrint("E ${e.toString()}");
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
    sendMessage();
  }

  Widget _storis() {
    return FutureBuilder(
        future: getStories(),
        builder: (context, snapshot) {
          allStories = [];
          if (snapshot.hasData) {
            List<UserStoryModel> list = [];
            List<StorisEntity> storis = snapshot.data!;
            List<StorisEntity> currentUserStories = [];
            for (int i = 0; i < storis.length; i++) {
              bool exist = false;
              int index = 0;
              for (int j = 0; j < list.length; j++) {
                if (list[j].user!.uid.contains(storis[i].user.uid)) {
                  exist = true;
                  index = j;
                  break;
                }
              }
              if (exist) {
                if (storis[i].user.uid.contains(GlobalsWidgets.uid)) {
                  currentUserStories.add(storis[i]);
                } else {
                  list[index].story.add(storis[i]);
                }
              } else {
                if (storis[i].user.uid.contains(GlobalsWidgets.uid)) {
                  currentUserStories.add(storis[i]);
                } else {
                  UserStoryModel userStoryModel = UserStoryModel();
                  userStoryModel.user = storis[i].user;
                  userStoryModel.story.add(storis[i]);
                  list.add(userStoryModel);
                }
              }
            }
            if (currentUserStories.isNotEmpty) {
              storyLoad = true;
              UserStoryModel userStoryModel = UserStoryModel();
              userStoryModel.user = currentUserStories.first.user;
              userStoryModel.story = currentUserStories;
              allStories.add(userStoryModel);
            }
            debugPrint("List l ${list.length}");
            allStories.addAll(list);
            for (int i = 0; i > allStories.length; i++) {
              list[i].index = i;
            }
            if (currentUserStories.isNotEmpty) {
              for (int i = 0; i < list.length; i++) {
                list[i].index = i + 1;
              }
            } else {
              for (int i = 0; i < list.length; i++) {
                list[i].index = i;
              }
            }
            List<Widget> widgets = [];
            debugPrint("Role ${GlobalsWidgets.role}");
            if (GlobalsWidgets.role != UserRole.USER && subscription) {
              widgets.add(currentUser(
                  "${GlobalsWidgets.name} (Вы)", currentUserStories.isEmpty));
            }
            widgets.addAll(list
                .map((e) =>
                    user(e.user!.name, false, true, e.index!, e.user!.photo))
                .toList());
            debugPrint("${GlobalsWidgets.role} && ${storis.length}");

            if (storis.length < 2 &&
                currentUserStories.isNotEmpty &&
                GlobalsWidgets.role == UserRole.USER) {
              return const SizedBox.shrink();
            } else {
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
                      return SizedBox(
                        width: 2.w,
                      );
                    },
                  ),
                ),
              );
            }
          } else {
            return Text(S.of(context).loading);
          }
        });
  }

  Future<List<StorisEntity>> getStories() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getStoris(GlobalsWidgets.uid, name);
  }

  Widget currentUser(String name, bool active) {
    return InkWell(
      onLongPress: !active
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StoryViewPage(usersStory: allStories)));
            }
          : null,
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(S.of(context).add_stor),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: 5.h,
                      child: OutlinedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                preferredCameraDevice: CameraDevice.rear);
                            debugPrint("Media ${image!.name}");
                            File file = File.fromUri(Uri.parse(image.path));
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            String id = await client.getChatId(
                                GlobalsWidgets.uid, widget.chatName);
                            debugPrint("ID $id");
                            client
                                .addStory(id, GlobalsWidgets.uid,
                                    StoryType.PHOTO, file)
                                .then((value) {
                              setState(() {});
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              debugPrint("Error image $error");
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: Colors.white),
                          child: Text(
                            S.of(context).photo,
                            style: const TextStyle(color: Color(0xff317EFA)),
                          )),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 5.h,
                      child: OutlinedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);
                            debugPrint("Media ${image!.name}");
                            File file = File.fromUri(Uri.parse(image.path));
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            String id = await client.getChatId(
                                GlobalsWidgets.uid, widget.chatName);
                            debugPrint("ID $id");
                            client
                                .addStory(id, GlobalsWidgets.uid,
                                    StoryType.PHOTO, file)
                                .then((value) {
                              setState(() {});
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              debugPrint("Error image $error");
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: Colors.white),
                          child: Text(
                            S.of(context).photo_,
                            style: const TextStyle(color: Color(0xff317EFA)),
                          )),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 5.h,
                      child: OutlinedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? video = await picker.pickVideo(
                                source: ImageSource.gallery);
                            debugPrint("Media ${video!.name}");
                            File file = File.fromUri(Uri.parse(video.path));
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            String id = await client.getChatId(
                                GlobalsWidgets.uid, widget.chatName);
                            client
                                .addStory(id, GlobalsWidgets.uid,
                                    StoryType.VIDEO, file)
                                .then((value) {
                              setState(() {});
                              Navigator.pop(context);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: Colors.white),
                          child: Text(
                            S.of(context).video,
                            style: const TextStyle(color: Color(0xff317EFA)),
                          )),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 5.h,
                      child: OutlinedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? video = await picker.pickVideo(
                                source: ImageSource.camera,
                                preferredCameraDevice: CameraDevice.rear);
                            debugPrint("Media ${video!.name}");
                            File file = File.fromUri(Uri.parse(video.path));
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            String id = await client.getChatId(
                                GlobalsWidgets.uid, widget.chatName);
                            client
                                .addStory(id, GlobalsWidgets.uid,
                                    StoryType.VIDEO, file)
                                .then((value) {
                              setState(() {});
                              Navigator.pop(context);
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: Colors.white),
                          child: Text(
                            S.of(context).video_,
                            style: const TextStyle(color: Color(0xff317EFA)),
                          )),
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
                                color: !storyLoad ? Colors.transparent : null,
                                gradient: storyLoad
                                    ? const LinearGradient(colors: [
                                        Colors.blueAccent,
                                        Color(0xffee2a7b),
                                        Colors.blueAccent
                                      ])
                                    : null),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(27), // Image radius
                          child: Container(
                            color:
                                storyLoad ? Colors.white : Colors.transparent,
                          ),
                        ),
                      ),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(25), // Image radius
                          child: Image.network(GlobalsWidgets.getUserPhoto(),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  !storyLoad && active
                      ? Container(
                          height: 2.h,
                          width: 2.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: GlobalsColor.blue),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 2.h,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
              Text(name)
            ],
          ),
          SizedBox(
            width: 2.w,
          )
        ],
      ),
    );
  }

  Widget user(
      String name, bool active, bool current, int index, String? photo) {
    return InkWell(
      onTap: !current
          ? () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(S.of(context).add_stor),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: 5.h,
                            child: OutlinedButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  debugPrint("Media ${image!.name}");
                                  File file =
                                      File.fromUri(Uri.parse(image.path));
                                  Dio dio = Dio();
                                  RestClient client = RestClient(dio);
                                  String id = await client.getChatId(
                                      GlobalsWidgets.uid, widget.chatName);
                                  debugPrint("ID $id");
                                  client
                                      .addStory(id, GlobalsWidgets.uid,
                                          StoryType.PHOTO, file)
                                      .then((value) {})
                                      .onError((error, stackTrace) {
                                    debugPrint("Error image $error");
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    backgroundColor: Colors.white),
                                child: Text(
                                  S.of(context).photo,
                                  style:
                                      const TextStyle(color: Color(0xff317EFA)),
                                )),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            height: 5.h,
                            child: OutlinedButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? video = await picker.pickVideo(
                                      source: ImageSource.gallery);
                                  debugPrint("Media ${video!.name}");
                                  File file =
                                      File.fromUri(Uri.parse(video.path));
                                  Dio dio = Dio();
                                  RestClient client = RestClient(dio);
                                  String id = await client.getChatId(
                                      GlobalsWidgets.uid, widget.chatName);
                                  client
                                      .addStory(id, GlobalsWidgets.uid,
                                          StoryType.VIDEO, file)
                                      .then((value) {});
                                },
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    backgroundColor: Colors.white),
                                child: Text(
                                  S.of(context).video,
                                  style:
                                      const TextStyle(color: Color(0xff317EFA)),
                                )),
                          )
                        ],
                      ),
                    );
                  });
            }
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoryViewPage(
                            usersStory: allStories,
                            index: index,
                          )));
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
                      storyLoad || current
                          ? ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(29), // Image radius
                                child: Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                    Colors.blueAccent,
                                    Color(0xffee2a7b),
                                    Colors.blueAccent
                                  ])),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      storyLoad || current
                          ? ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(27), // Image radius
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(25), // Image radius
                          child: Image.network(GlobalsWidgets.getPhoto(photo),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  !storyLoad && active
                      ? Container(
                          height: 2.h,
                          width: 2.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: GlobalsColor.blue),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 2.h,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
              Text(name)
            ],
          ),
          SizedBox(
            width: 2.w,
          )
        ],
      ),
    );
  }

  Color _getBackGround(MessageEntity message) {
    BubbleType type = _getType(message);
    if (type == BubbleType.sendBubble) {
      return const Color(0xff317EFA);
    } else {
      return const Color(0xffF8F8FA);
    }
  }

  Alignment _getAlignment(MessageEntity message) {
    BubbleType type = _getType(message);
    if (type == BubbleType.sendBubble) {
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }

  BubbleType _getType(MessageEntity message) {
    if (message.user.uid.contains(GlobalsWidgets.uid)) {
      return BubbleType.sendBubble;
    } else {
      return BubbleType.receiverBubble;
    }
  }

  void disconnectFromServer() {
    if (socket.active) {
      socket.off('connect');
      socket.off('disconnect');
      socket.off('read_message');
      socket.disconnect();
      socket.dispose();
      socket.close();
    } else {
      socket.off('connect');
      socket.off('disconnect');
      socket.off('read_message');
      socket.dispose();
      socket.close();
    }
  }

  void connectToServer() {
    try {
      debugPrint("Connect to room $name");
      OptionBuilder optionBuilder = OptionBuilder();
      Map<String, dynamic> opt = optionBuilder
          .disableAutoConnect()
          .setTransports(["websocket"]).setQuery(
              {"room": name, "uid": GlobalsWidgets.uid}).build();
      opt.addAll({"forceNew": true});
      socket = io('http://${GlobalsWidgets.ip}:8081', opt);
      socket.connect();
      socket.on('connect', (_) {
        debugPrint("Connect");
      });
      socket.on('disconnect', (_) {
        debugPrint("Disconnect");
      });
      socket.on("read_message", (data) async {
        getMessages();
        setState(() {});
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getMessages() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    debugPrint("Uid ${GlobalsWidgets.uid} name $name");
    String id = await client.getChatId(GlobalsWidgets.uid, name);
    debugPrint("ChatId $id");
    setState(() {
      messages = client.getMessages(GlobalsWidgets.uid, id);
    });
  }

  Future<void> sendMessage() async {
    debugPrint("Send");
    if (_controller.text.isNotEmpty &&
        _controller.text.replaceAll(" ", "").isNotEmpty) {
      socket.emit("send_message", {"content": _controller.value.text});
      getMessages();
      setState(() {});
    }
    _controller.text = '';
  }
}
