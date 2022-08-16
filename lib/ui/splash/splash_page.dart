import 'dart:io';

import 'package:firebase_sample/controller/splash_controller.dart';
import 'package:firebase_sample/core/const/constants.dart';
import 'package:firebase_sample/core/service/analytics_service.dart';
import 'package:firebase_sample/data/data_source/local_source.dart';
import 'package:firebase_sample/routes/app_pages.dart';
import 'package:firebase_sample/ui/splash/widgets/do_not_ask_again_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash'),
      ),
      body: GetBuilder<SplashController>(
        initState: (state) async {
          await checkLatestVersion();
        },
        builder: (ctr) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SelectableText(
                  LocalSource.getInstance().getFcmToken(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    AnalyticsService.instance.logMain();
                    Get.toNamed(Routes.main);
                  },
                  child: const Text("Main"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    AnalyticsService.instance.logHome();
                    Get.toNamed(Routes.home);
                  },
                  child: const Text("Home"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Checking for update
  Future<void> checkLatestVersion() async {
    await Firebase.initializeApp();
    //Get Latest version info from firebase config
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentVersion = int.parse(packageInfo.version.replaceAll(".", ""));

      int androidVersion = int.parse(
          remoteConfig.getString('android_version').replaceAll(".", ""));
      int iosVersion =
          int.parse(remoteConfig.getString('ios_version').replaceAll(".", ""));
      int appVersion = Platform.isIOS ? iosVersion : androidVersion;
      final required = remoteConfig
          .getBool(Platform.isAndroid ? "android_required" : "ios_required");
      if (appVersion > currentVersion) {
        if (required) {
          _showCompulsoryUpdateDialog(
            Constants.navigatorKey.currentContext,
            "please_update".tr,
          );
        } else {
          final sharedPreferences = LocalSource.getInstance();
          bool showUpdates = true;
          showUpdates = sharedPreferences.getUpdateDialog();
          if (showUpdates == false) {
            return;
          }
          _showOptionalUpdateDialog(
            Constants.navigatorKey.currentContext,
            "available".tr,
          );
        }
      } else {}
    } on Exception catch (exception) {
      debugPrint("$exception");
    } catch (exception) {
      debugPrint("$exception");
    }
  }

  _showOptionalUpdateDialog(context, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "app_update_available".tr;
        String btnLabel = 'update_now'.tr;
        String btnLabelCancel = 'later'.tr;
        String btnLabelDontAskAgain = 'do_not'.tr;
        return DoNotAskAgainDialog(
          'update_dialog'.tr,
          title,
          message,
          btnLabel,
          btnLabelCancel,
          _onUpdateNowClicked,
          doNotAskAgainText:
              Platform.isIOS ? btnLabelDontAskAgain : 'never_ask_again'.tr,
        );
      },
    );
  }

  _onUpdateNowClicked() {
    LaunchReview.launch(
      androidAppId: "uz.udevs.paymart_mobile",
      iOSAppId: "1579281935",
    );
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = 'app_update_available'.tr;
        String btnLabel = 'update_now'.tr;
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff1E1E1E),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xff1E1E1E),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                    child: Text(
                      btnLabel,
                      style: const TextStyle(
                        color: Color(0xff1E1E1E),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  "$title $message",
                  style: const TextStyle(
                    color: Color(0xff1E1E1E),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: _onUpdateNowClicked,
                    child: Text(
                      btnLabel,
                      style: const TextStyle(
                        color: Color(0xff1E1E1E),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
