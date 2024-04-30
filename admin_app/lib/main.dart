import 'package:admin_app/auth/login_page.dart';
import 'package:admin_app/firebase_options.dart';
import 'package:admin_app/home_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import "package:admin_app/utils/globals.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'api/RestClient.dart';
import 'api/entity/UserEntity.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  if(auth.currentUser!=null){
    print("Current user not null");
    uid = auth.currentUser!.uid;
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    client.setUserUid(sharedPreferences.getString("phone")??"null", uid);
  }else{
    (await SharedPreferences.getInstance()).remove("phone");
    print("Current user null");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (_,__,___){
      return MaterialApp(
        title: 'Gnext Pro',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales:  const [
          Locale('ru', ''),
        ],
        locale: const Locale("ru", ''),
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: uid.isNotEmpty?FutureBuilder(future: getUser(), builder: (context, snapshot){
          if(snapshot.hasData){
            UserEntity user = snapshot.data!;
            name = user.name;
            surname = user.surname;
            image = user.photo;
            return HomePage(user: user);
          }else{
            if(snapshot.error is DioException){
              print("User error ${snapshot.error}");
              FirebaseAuth.instance.signOut();
              return const LoginPage();
            }else{
              print("User error ${snapshot.error}");
              return const SizedBox.shrink();
            }
          }
        }):const LoginPage(),
      );
    });
  }
  Future<UserEntity> getUser(){
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getUserByUid(uid);
  }
}
