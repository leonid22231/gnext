import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/FilterEntity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ControlChatFilterPage extends StatefulWidget{
  const ControlChatFilterPage({super.key});
  @override
  State<StatefulWidget> createState() => _ControlChatFilterPage();
}
class _ControlChatFilterPage extends State<ControlChatFilterPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context, state){
            String? word;
            return AlertDialog(
              title: Text("Добавить слово", style: TextStyle(fontSize: 18.sp),),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Слово", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
                    SizedBox(height: 1.h,),
                    SizedBox(
                      width: 50.w,
                      height: 8.h,
                      child: TextFormField(
                        onChanged: (value){
                          word = value;
                        },
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: "Введите слово",
                          hintStyle: TextStyle(fontSize: 16.sp),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: const BorderSide(color: Color(0xffD9D9D9))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: const BorderSide(color: Color(0xffD9D9D9))
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Отмена",style: TextStyle(color: mainColor, fontSize: 14.sp))),
                          SizedBox(width: 5.w,),
                          TextButton(onPressed: (){
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            client.addFilter(word!).then((value){
                              Navigator.pop(context);
                            }).onError((error, stackTrace){
                              if(error is DioException){
                                displayError(error.response!.data, context);
                              }
                            });
                          }, child: Text("Добавить", style: TextStyle(color: mainColor, fontSize: 14.sp),)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          })).then((value) {
            setState(() {

            });
          });
        },
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 5.w,
            ), onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        title: Text("Управление фильтрами слов", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
              Text("Фильтруемые слова", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: mainColor),),
              Divider(color: mainColor,),
              SizedBox(height: 2.h,),
              FutureBuilder(
                future: getFilters(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<FilterEntity> list = snapshot.data!;
                    return ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context,index){
                          return _word(list[index]);
                        },
                        separatorBuilder: (_,__){
                          return SizedBox(height: 2.h,);
                        },
                        itemCount: list.length
                    );
                  }else{
                    return Center(child: Text("Загрузка..."),);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<List<FilterEntity>> getFilters(){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.findFilters();
  }

  Widget _word(FilterEntity word) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: mainColor
      ),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(word.word.replaceFirst(word.word[0], word.word[0].toUpperCase()), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 18.sp),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent
              ),
              child: IconButton(onPressed: (){
                Dio dio = Dio();
                RestClient client = RestClient(dio);
                client.deleteFilter(word.id).then((value){
                  setState(() {

                  });
                }).onError((error, stackTrace){
                  if(error is DioException){
                    displayError(error.response!.data, context);
                  }
                });
            }, icon: Icon(Icons.delete, color: Colors.white,size: 18.sp,)),
            )
          ],
        ),
      ),
    );
  }
}