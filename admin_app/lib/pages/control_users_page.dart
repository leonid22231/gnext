import 'package:admin_app/api/RestClient.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/UserRole.dart';
import 'package:admin_app/userprofile_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/utils/globals.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ControlUsersPage extends StatefulWidget{
  bool? selectMode;
  bool? filter;
  ControlUsersPage({this.filter,this.selectMode,super.key});
  @override
  State<StatefulWidget> createState() => _ControlUsersPage();
}
class _ControlUsersPage extends State<ControlUsersPage>{
  String? query;
  bool grid = false;
  bool selectMode = false;
  @override
  Widget build(BuildContext context) {
    if(widget.selectMode!=null){
      selectMode = widget.selectMode!;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 5.w,
            ), onPressed: () {
          Navigator.pop(context);
        }),
        centerTitle: true,
        title: Text(!selectMode?"Управление пользователями":"Выберите пользователя", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: mainColor),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
             IntrinsicHeight(
               child:  Row(
                 children: [
                   Flexible(child: SizedBox(
                     child: TextFormField(
                       onChanged: (value){
                         query = value;
                         setState(() {

                         });
                       },
                       style: TextStyle(fontSize: 16.sp),
                       decoration: InputDecoration(
                         hintText: "Поиск...",
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
                   )),
                   SizedBox(width: 2.w,),
                   AspectRatio(
                     aspectRatio: 1,
                     child: InkWell(
                       onTap: (){
                         changeView();
                       },
                       borderRadius: BorderRadius.circular(10),
                       child: Ink(
                         decoration: BoxDecoration(
                             color: mainColor,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: Center(
                           child: Icon(
                             !grid?Icons.grid_view_rounded:Icons.list_outlined,
                             color: Colors.white,
                             size: 5.w,
                           ),
                         ),
                       ),
                     ),
                   )
                 ],
               ),
             ),
             SizedBox(height: 2.h,),
             FutureBuilder(
                 future: getUsers(query), builder: (context, snapshot){
               if(snapshot.hasData){
                 List<UserEntity> users = snapshot.data!;
                 if(widget.filter??false){
                   List<UserEntity> filtering = [];
                   for(int i = 0; i < users.length; i++){
                     if(users[i].role==UserRole.USER){
                       filtering.add(users[i]);
                     }
                   }
                   users = filtering;
                 }
                 if(grid){
                   double max = 100.w - 4.h;
                   int count = (max/40.w).floor();
                   return GridView.count(
                     primary: false,
                     crossAxisCount: count,
                     crossAxisSpacing: 2.w,
                     mainAxisSpacing: 2.w,
                     shrinkWrap: true,
                     children: users.map((e) => _userGrid(e)).toList(),
                   );
                 }else{
                   return ListView.separated(
                       shrinkWrap: true,
                       primary: false,
                       itemBuilder: (context, index){
                         return _userList(users[index]);
                       },
                       separatorBuilder: (context, index){
                         return SizedBox(height: 2.h,);
                       },
                       itemCount: users.length
                   );
                 }
               }else{
                 print("Users error ${snapshot.error}");
                 return const Center(child: Text("Загрузка..."),);
               }
             }
             )
            ],
          ),
        ),
      ),
    );
  }
  Widget _userGrid(UserEntity user){
    return InkWell(
      onTap: selectMode?(){
            Navigator.pop(context, user);
      }:(){
          debugPrint("Click");
          Navigator.push(context,
          MaterialPageRoute(builder: (context)=>UserProfile(user: user)));
      },
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          user.uid==uid?Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Text("( Вы )", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),),
            ),
          ):const SizedBox.shrink(),
          Ink(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(2.h).copyWith(bottom: 0),
              child: Column(
                children: [
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(10.w), // Image radius
                      child: Image.network(getUserPhoto(), fit: BoxFit.cover),
                    ),
                  ),
                  Text("${user.name} ${user.surname}",maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),),
                  SizedBox(height: 1.h,),
                  Text("+${user.phone}", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                  SizedBox(height: 1.h,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFAEB4B7), width: 0.3.w),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Text(getRole(user.role), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _userList(UserEntity user){
    return InkWell(
      onTap: selectMode?(){
          Navigator.pop(context, user);
      }:(){
        debugPrint("Click");
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>UserProfile(user: user))).then((value) => setState(() {
              
            }));
      },
      borderRadius: BorderRadius.circular(50),
      child: Ink(
        height: 10.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: mainColor
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(5.w), // Image radius
                        child: Image.network(getPhoto(user.photo), fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width: 3.w,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          user.uid==uid?Text("${user.name} ${user.surname} (Вы)", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),):Text("${user.name} ${user.surname}", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                          Text("+${user.phone}", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFAEB4B7), width: 0.3.w),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Text(getRole(user.role), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    ),
                    SizedBox(width: 2.w,),
                    Icon(Icons.keyboard_arrow_right_outlined, size: 5.w,color: Colors.white,)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<List<UserEntity>> getUsers(String? query){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    if(query!=null && query.isEmpty || query==null){
      return client.findUsers(null);
    }else{
      return client.findUsers(query);
    }

  }
  void changeView() {
      grid = !grid;
      setState(() {

      });
  }
}