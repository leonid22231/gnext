import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/firebase_options.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/preload/preload_page.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser != null) {
    print("Current user not null");
    GlobalsWidgets.uid = auth.currentUser!.uid;
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    client.setUserUid(
        sharedPreferences.getString("phone") ?? "null", GlobalsWidgets.uid);
  } else {
    (await SharedPreferences.getInstance()).remove("phone");
    print("Current user null");
  }
  runApp(const MyApp());
}

_checkStoragePermission() async {
  PermissionStatus status;
  if (Platform.isAndroid) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    if ((info.version.sdkInt) >= 33) {
      status = await Permission.manageExternalStorage.request();
    } else {
      status = await Permission.storage.request();
    }
  } else {
    status = await Permission.storage.request();
  }

  switch (status) {
    case PermissionStatus.denied:
      return false;
    case PermissionStatus.granted:
      return true;
    case PermissionStatus.restricted:
      return false;
    case PermissionStatus.limited:
      return true;
    case PermissionStatus.permanentlyDenied:
      return false;
    case PermissionStatus.provisional:
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Locale(
        Platform.localeName.split("_")[0], Platform.localeName.split("_")[1]);
    debugPrint("Locale is $currentLocale");
    return ResponsiveSizer(builder: (_, __, ___) {
      return MaterialApp(
        title: 'Gnext Logistics',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        supportedLocales: const [
          Locale('ru', 'RU'),
          Locale('kk', 'KZ'),
        ],
        locale: currentLocale,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: GlobalsWidgets.uid.isNotEmpty
            ? FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    GlobalsWidgets.name = snapshot.data!.name;
                    GlobalsWidgets.surname = snapshot.data!.surname;
                    GlobalsWidgets.image = snapshot.data!.photo;
                    GlobalsWidgets.role = snapshot.data!.role;
                    return MainRoute(
                      userEntity: snapshot.data!,
                    );
                  } else {
                    if (snapshot.error is DioException) {
                      print("Sign out 1 ${snapshot.error}");
                      FirebaseAuth.instance.signOut();
                      return const LoginPage();
                    }
                    print("Sign out 2 ${snapshot.error}");
                    return const SizedBox.shrink();
                  }
                })
            : PreloadPage(),
      );
    });
  }

  Future<UserEntity> getUser() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getUserByUid(GlobalsWidgets.uid);
  }
}
