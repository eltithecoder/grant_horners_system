// translation_service.dart
import 'package:grant_horners_system/domain/entities/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static const _key = 'bible_translation_v1';

  Future<BibleTranslation> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    if (name == null) return BibleTranslation.esv; // default

    return BibleTranslation.values.firstWhere(
      (t) => t.name == name,
      orElse: () => BibleTranslation.esv,
    );
  }

  Future<void> save(BibleTranslation translation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, translation.name);
  }
}