import 'dart:math';
import 'dart:ui';

import 'package:app/generated/l10n.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatPreviewPage extends StatelessWidget {
  final String title;
  const ChatPreviewPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              SizedBox(
                height: 12.h,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _user(index);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 2.w,
                        );
                      },
                      itemCount: 5),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    reverse: true,
                    children: [
                      _message(),
                      _message(),
                      _message(),
                      _message(),
                      _message(),
                      _message(),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                        width: 100.w - 25.w,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1B26),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.only(left: 18),
                        child: TextField(
                          readOnly: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: S.of(context).text,
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.white,
                              ),
                            ),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(width: 1.w),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(
                      Icons.mic,
                      size: 8.w,
                    ),
                    color: Colors.black,
                  ),
                ],
              )
            ],
          ),
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const Opacity(opacity: 0.01, child: SizedBox.expand()),
          ),
        ),
        Center(
          child: Text(
            S.of(context).register_please,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        )
      ],
    );
  }

  Widget _message() {
    var rnd = Random();
    return ChatBubble(
      margin: const EdgeInsets.only(bottom: 20),
      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
      alignment: Alignment.centerLeft,
      backGroundColor: const Color(0xff317EFA),
      child: Container(
        width: 70.w,
        height: (rnd.nextInt(10) + 5).h,
        child: Text(
          "Simple text, not simple text lol hello priver",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _user(int index) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(29), // Image radius
                child: Container(
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blueAccent, Color(0xffee2a7b), Colors.blueAccent])),
                ),
              ),
            ),
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(27), // Image radius
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(25), // Image radius
                child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnGZWTF4dIu8uBZzgjwWRKJJ4DisphDHEwT2KhLNxBAA&s", fit: BoxFit.cover),
              ),
            ),
          ],
        ),
        Text("User $index")
      ],
    );
  }
}
