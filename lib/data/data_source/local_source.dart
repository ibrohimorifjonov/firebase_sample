import 'package:firebase_sample/data/keys/app_keys.dart';
import 'package:get_storage/get_storage.dart';

class LocalSource {
  final _localStorage = GetStorage();
  LocalSource._();

  static LocalSource? _instance;

  static LocalSource getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      return LocalSource._();
    }
  }

  bool getUrl() {
    return _localStorage.read<bool>(AppKeys.URL) ?? false;
  }

  Future<void> setUrl(bool isProd) async {
    await _localStorage.write(AppKeys.URL, isProd);
  }

  Future<void> setWishList(List<int> wishes) async {
    await _localStorage.write(AppKeys.WISHES, wishes);
  }

  List<dynamic>? getWishes() {
    return _localStorage.read<List<dynamic>?>(AppKeys.WISHES);
  }

  Future<void> logout() async {
    await _localStorage.remove(AppKeys.USER);
    await _localStorage.remove(AppKeys.X_AUTH_TOKEN);
    await _localStorage.remove(AppKeys.MY_ADDRESS);
    await _localStorage.remove(AppKeys.HAS_PROFILE);
  }

  bool getUpdateDialog() {
    return _localStorage.read<bool>('update_dialog') ?? true;
  }

  Future<void> setUpdateDialog(bool b) async {
    await _localStorage.write('update_dialog', b);
  }

  String getAccessToken() {
    return _localStorage.read<String>(AppKeys.ACCESS_TOKEN) ?? '';
  }

  String getLocale() {
    return _localStorage.read<String>(AppKeys.LOCALE) ?? 'ru';
  }

  void setLocale(String value) async {
    await _localStorage.write(AppKeys.LOCALE, value);
  }

  String getRefreshToken() {
    return _localStorage.read<String>(AppKeys.REFRESH_TOKEN) ?? '';
  }

  Future<void> setFcmToken(String value) async {
    await _localStorage.write(AppKeys.FCM_TOKEN, value);
  }

  String getFcmToken() {
    return _localStorage.read<String>(AppKeys.FCM_TOKEN) ?? '';
  }

  void removeAddress() async {
    return _localStorage.remove(AppKeys.MY_ADDRESS);
  }

  Future<void> setCompanyId(int id) async {
    await _localStorage.write(AppKeys.COMPANY_ID, id);
  }

  Future<void> setCompanyIndex(int id) async {
    int companyId = 78;
    switch (id) {
      case 0:
        companyId = 78;
        break;
      case 1:
        companyId = 98;
        break;
      case 2:
        companyId = 78;
        break;
    }
    setCompanyId(companyId);
    await _localStorage.write(AppKeys.COMPANY_INDEX, id);
  }

  int getCompanyIndex() {
    return _localStorage.read<int>(AppKeys.COMPANY_INDEX) ?? 0;
  }

  int getCompanyId() {
    return _localStorage.read<int>(AppKeys.COMPANY_ID) ?? -1;
  }

  Future<void> setRefreshedTokens(
      {required String? refreshToken, required String? accessToken}) async {
    await _localStorage.write(AppKeys.REFRESH_TOKEN, refreshToken ?? '');
    await _localStorage.write(AppKeys.ACCESS_TOKEN, accessToken ?? '');
  }
}
