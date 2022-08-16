import 'en.dart';
import 'ru.dart';
import 'uz.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en': en,
    'ru': ru,
    'uz': uz,
  };
}
