import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/ChatEntity.dart';
import 'package:admin_app/api/entity/CityEntity.dart';
import 'package:admin_app/custom_chat_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ControlChatsPage extends StatefulWidget {
  CityEntity city;
  ControlChatsPage({required this.city, super.key});
  @override
  State<StatefulWidget> createState() => _ControlChatsPage();
}

class _ControlChatsPage extends State<ControlChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 5.w,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          "Управление чатами",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
              Text(
                "Глобальные чаты",
                style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 22.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              FutureBuilder(
                  future: findChats(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ChatEntity> list = snapshot.data!;
                      return ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return _chat(list[index]);
                          },
                          separatorBuilder: (_, __) {
                            return SizedBox(
                              height: 1.h,
                            );
                          },
                          itemCount: list.length);
                    } else {
                      debugPrint("Chat ${widget.city.id} error ${snapshot.error}");
                      return const Center(
                        child: Text("Загрузка..."),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _chat(ChatEntity chat) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomChatPage(
                      city: widget.city,
                      title: getChatNameByDefaultName(chat.name),
                      chatName: chat.name,
                      showTitle: true,
                    )));
      },
      child: Ink(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: mainColor),
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Text(
            getChatNameByDefaultName(chat.name),
            style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<List<ChatEntity>> findChats() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findChats(1, widget.city.id);
  }
}
