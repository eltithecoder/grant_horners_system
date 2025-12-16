import 'package:grant_horners_system/domain/entities/app_language.dart';

abstract class SettingsRepository {
  Future<AppLanguage> loadLanguage();
  Future<void> saveLanguage(AppLanguage language);

  Future<bool> loadUseBiblaAl();
  Future<void> saveUseBiblaAl(bool useBiblaAl);
}
