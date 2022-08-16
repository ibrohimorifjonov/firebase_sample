import 'dart:async';

import 'package:firebase_sample/core/service/notifications_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_sample/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/const/constants.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await GetStorage.init();
      await NotificationsService.initialize();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      runApp(const MyRoot());
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

class MyRoot extends StatefulWidget {
  const MyRoot({Key? key}) : super(key: key);

  @override
  State<MyRoot> createState() => _MyRootState();
}

class _MyRootState extends State<MyRoot> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    // _handleIncomingLinks();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Constants.navigatorKey,
      onInit: () async {
        await _initNotification();
        // await _initUniLinks();
      },
      title: 'Flutter Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onReady: () {
        fcmSubscribe();
      },
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
    );
  }

  void fcmSubscribe() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.subscribeToTopic('FCM');
  }

  Future<void> _initNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data["screen"] == "/main") {
        Get.toNamed(Routes.main);
      } else if (initialMessage.data["screen"] == "/home") {
        Get.toNamed(Routes.home);
      }
    }
  }

  // Future<void> _initUniLinks() async {
  //   try {
  //     final initialLink = await getInitialLink();
  //     if (initialLink != null) {
  //       debugPrint("////////////////////////");
  //       debugPrint(initialLink);
  //       final id = initialLink.split('/').last;
  //       Get.toNamed(Routes.welcome, arguments: id);
  //     }
  //   } on PlatformException catch (err) {
  //     debugPrint(err.message);
  //   }
  // }
  //
  // void _handleIncomingLinks() {
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     debugPrint("======================");
  //     if (!mounted) return;
  //     debugPrint('got uri: $uri');
  //     final id = uri?.path.split('/').last ?? '';
  //     Get.toNamed(Routes.welcome, arguments: id);
  //   }, onError: (Object err) {
  //     if (!mounted) return;
  //     debugPrint('got err: $err');
  //   });
  // }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
