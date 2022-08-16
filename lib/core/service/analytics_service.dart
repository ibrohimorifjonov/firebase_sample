import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  logMain() {
    _analytics.logEvent(
      name: "main_page",
      parameters: {"open": "Main Page"},
    );
  }

  logHome() {
    _analytics.logEvent(
      name: "home_page",
      parameters: {"open": "Home Page Open"},
    );
  }
}
