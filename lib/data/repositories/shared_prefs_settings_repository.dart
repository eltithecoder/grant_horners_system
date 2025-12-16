import 'package:grant_horners_system/domain/entities/app_language.dart';
import 'package:grant_horners_system/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsSettingsRepository implements SettingsRepository {
  static const _languageKey = 'app_language_v1';
  static const _useBiblaKey = 'use_bibla_al_v1';

  @override
  Future<AppLanguage> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_languageKey);
    if (name == null) return AppLanguage.english;

    return AppLanguage.values.firstWhere(
      (lang) => lang.name == name,
      orElse: () => AppLanguage.english,
    );
  }

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.name);
  }

  @override
  Future<bool> loadUseBiblaAl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useBiblaKey) ?? false;
  }

  @override
  Future<void> saveUseBiblaAl(bool useBiblaAl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useBiblaKey, useBiblaAl);
  }
}
