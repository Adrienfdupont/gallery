import 'package:shared_preferences/shared_preferences.dart';

class FavoritesUtil {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setFavorite(String key, bool value) async =>
      await _preferences?.setBool(key, value);

  static bool? isFavorite(String key) => _preferences?.getBool(key);

  static Map<String, bool> getAllFavorites() {
    return _preferences?.getKeys().fold<Map<String, bool>>({},
            (Map<String, bool> map, String key) {
          final bool? isFav = _preferences?.getBool(key);
          if (isFav != null && isFav) {
            map[key] = isFav;
          }
          return map;
        }) ??
        {};
  }
}
