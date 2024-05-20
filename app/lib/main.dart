import 'dart:io';

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/firebase_options.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/preload/preload_page.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:app/utils/localization/localization_block.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser != null) {
    debugPrint("Current user not null");
    GlobalsWidgets.uid = auth.currentUser!.uid;
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    client.setUserUid(
        sharedPreferences.getString("phone") ?? "null", GlobalsWidgets.uid);
  } else {
    (await SharedPreferences.getInstance()).remove("phone");
    debugPrint("Current user null");
  }
  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LanguageBloc())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  LanguageBloc? languageBloc;
  @override
  void initState() {
    languageBloc = LanguageBloc();
    super.initState();
    initLocalization();
  }

  @override
  void dispose() {
    languageBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Locale(
        Platform.localeName.split("_")[0], Platform.localeName.split("_")[1]);
    debugPrint("Locale is $currentLocale");
    return ResponsiveSizer(builder: (_, __, ___) {
      return BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          if (state is LanguageLoaded) {
            debugPrint("Lng state $state");
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
              locale: Locale(state.locale, ''),
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
                            debugPrint("Sign out 1 ${snapshot.error}");
                            FirebaseAuth.instance.signOut();
                            return const LoginPage();
                          }
                          debugPrint("Sign out 2 ${snapshot.error}");
                          return const SizedBox.shrink();
                        }
                      })
                  : PreloadPage(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    });
  }

  void initLocalization() async {
    var prefs = await SharedPreferences.getInstance();
    String? lng = prefs.getString("lng");
    debugPrint("Language $lng");
    final loginBloc = BlocProvider.of<LanguageBloc>(context);
    if (lng != null) {
      loginBloc.add(
        ToggleLanguageEvent(lng),
      );
    } else {}
  }

  Future<UserEntity> getUser() {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    return client.getUserByUid(GlobalsWidgets.uid);
  }
}
