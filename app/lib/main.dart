import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/WalletEvent.dart';
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
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  _showNotification(message);
  log("Message resive chat ${message.data['chat']} title[${message.data['title']}] body[${message.data['body']}]");
}

Future<void> _showNotification(RemoteMessage remotemessage) async {
  log("From ${remotemessage.from} id ${remotemessage.messageId}");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          'gnextlogistics_notification', 'Уведомления о заказах',
          channelDescription: 'Уведомления о заказах',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.cancelAll();
  await flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      remotemessage.data["title"],
      remotemessage.data['body'],
      notificationDetails,
      payload: 'item x');
}

Future<void> _requestPermissions() async {
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? grantedNotificationPermission =
        await androidImplementation?.requestNotificationsPermission();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isAndroid) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  log("${await FirebaseMessaging.instance.getToken()}");
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher_foreground');

  DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  log("${await FirebaseMessaging.instance.getToken()}");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _requestPermissions();
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
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;
  @override
  void initState() {
    languageBloc = LanguageBloc();
    super.initState();
    initLocalization();
    initStore();
  }

  void initStore() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    debugPrint("Store availabale is $isAvailable");
    _purchasesSubscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _purchasesSubscription.cancel();
      },
      onError: (error) {},
    );
  }

  handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (int index = 0; index < purchaseDetailsList.length; index++) {
      var purchaseStatus = purchaseDetailsList[index].status;
      var productId = purchaseDetailsList[index].productID;
      debugPrint("Product Id $productId");
      debugPrint("Product Status $purchaseStatus");
      switch (purchaseDetailsList[index].status) {
        case PurchaseStatus.pending:
          print(' purchase is in pending ');
          continue;
        case PurchaseStatus.error:
          print(' purchase error ');
          break;
        case PurchaseStatus.canceled:
          print(' purchase cancel ');
          break;
        case PurchaseStatus.purchased:
          print(' purchased ');
          break;
        case PurchaseStatus.restored:
          print(' purchase restore ');
          break;
      }

      if (purchaseDetailsList[index].pendingCompletePurchase) {
        await _inAppPurchase
            .completePurchase(purchaseDetailsList[index])
            .then((value) {
          if (purchaseStatus == PurchaseStatus.purchased) {
            Dio dio = Dio();
            RestClient client = RestClient(dio);
            client
                .walletEvent(GlobalsWidgets.uid, WalletEvent.ADD,
                    double.parse(productId.split("_")[1]))
                .then((value) {
              GlobalsWidgets.wallet += double.parse(productId.split("_")[1]);
              Navigator.pop(context);
            });
          }
        });
      }
    }
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
                LocaleNamesLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale('ru', 'RU'),
                Locale('kk', 'KZ'),
                Locale('hi', 'IN'),
                Locale('hy', 'AM'),
                Locale('ky', 'KG'),
                Locale('ko', 'KR'),
                Locale('zh', 'CN'),
                Locale('uz', 'UZ'),
                Locale('pl', 'PL')
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
