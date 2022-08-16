import 'package:flutter/cupertino.dart';

class Constants {
  static const shipperId = /*kDebugMode ? */
      'd4b1658f-3271-4973-8591-98a82939a664' /*  'e2d30f35-3d1e-4363-8113-9c81fdb2a762'*/ /*: 'e2d30f35-3d1e-4363-8113-9c81fdb2a762'*/;

  static const baseUrl = /* !kDebugMode ?*/ 'https://test.customer.api.delever.uz/v1/';

  /*'https://customer.api.delever.uz/v1/';*/
  static const androidPlatformID = "6bd7c2e3-d35e-47df-93ce-ed54ed53f95f";
  static const iosPlatformID = "f6631db7-09d0-4cd9-a03a-b7a590abb8c1";

  // static const apiKey = '66e41b39-b5ee-40f6-8e51-52c6c6b4ddf1';
  ///not active
  static const apiKey = 'e190819a-d0df-4e60-923d-8a64fb149936';
  static const yandexKey = 'https://geocode-maps.yandex.ru/1.x/';
  static const String appName = "FCM";

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: appName,
  );
}
